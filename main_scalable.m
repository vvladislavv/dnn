% close all;
% clear all;
% clc;

%% training data 
% train_data_dir = 'Training_data_old\training_set_v2\';
% test_data_dir = 'Training_data_old\data\';

dirname1 = dir('training_set');
dirname2 = dir('test_set');
% for i = 1:length(dirname1(3:end))
    train_data_dir{1} = ['training_set\' dirname1(end).name '\'];
% end

for i = 1:length(dirname2(3:end))
    test_data_dir{i} = ['test_set\'  dirname2(i+2).name '\'];
end
nntest = true;
nntrain = false;



if nntrain
for num  = 1:length(train_data_dir)
NN.scale = 5;
    
    
    [X, ~] = load_data(train_data_dir{num}, []);
% X = cropmas(X);
% X_test = cropmas(X_test);
if NN.scale > 1
st = std(X(1:100,:));
train = bsxfun(@rdivide,X,st);
    for ind = 1:NN.scale
        X(((ind-1)*(size(X,1)/NN.scale)+1):(ind)*(size(X,1)/NN.scale),:) = sort(train(((ind-1)*(size(X,1)/NN.scale)+1):(ind)*(size(X,1)/NN.scale),:),1);
    end
    
else
    train = X;
    train = bsxfun(@rdivide,train,std(train));
    X = sort(train,1);
end
% test = X_test;
% test = bsxfun(@rdivide,test,std(test));
% X_test = sort(test,1);


X(isnan(X)) = 0;
% X_test(isnan(X_test)) = 0;

clear train test;

%% Creation and initialization
insize = size(X,1);
NN.scale = 5;
NN.struct = {insize insize/2 (insize/2)/2 ((insize/2)/2)/2.5 (insize/2)/2 insize/2 insize}; % network structure
NN.afun = {'linear', 'tanh', 'tanh', 'staircase', 'tanh', 'tanh', 'linear'};
NN.type = 'DAE'; %'DNN'
NN.pretrain = true; % false
NN.atoms = dirname1(num+2).name;



%% Generate random weights (if no pretraining)
for i = 2:length(NN.struct)
    eps_initt = sqrt(6)/sqrt((NN.struct{i} + NN.struct{i-1}));
    NN.W{i-1} = randn(NN.struct{i}, NN.struct{i-1}) * eps_initt;
    NN.B{i-1} = zeros(NN.struct{i},1);
end

%% Training setup
opts.method = 'adam';    %'momentum', 'adadelta', 'RMSprop'
opts.step = 0.001;          % learning rate
opts.momentum = 0.9;        % momentum rate
opts.lambda = 1e-4;         % L2-norm scale
opts.maxepoch = 200;         % max number of training iterations
opts.eps = 0.00001;         % min error threshold
opts.batchsize = 1000;      % number of samples per batch
opts.quantize = false;      % conditional enabling of quantization
opts.step_dec = 0.7;        % rate of decreasing learning speed
opts.step_inc = 1.05;       % rate of increasing learning speed
opts.step_max = 0.1;        % maximal step
opts.step_min = 0.00001;    % minimal step
opts.err_win_len = 16;      % error control window
                   
%% Stacked autoencoder pretraining (if number of layers more than 3)
if (length(NN.struct)>3) && NN.pretrain
    if strcmp(NN.type,'DAE')
        aenum = floor(length(NN.struct)/2);
    else
        aenum = length(NN.struct)-2;
    end

%% Train encoders
    data = X;
%%
    for j = 1:aenum   
        AE{j}.struct = {NN.struct{j}, NN.struct{j+1}, NN.struct{j}}; % AE structure  
        AE{j}.afun = {NN.afun{j}, NN.afun{j+1}, NN.afun{j}}; % AE activation
        AE{j}.scale = NN.scale;
        for i = 2:length(AE{1}.struct)
            eps_init(i) =  sqrt(1/(std(data(:))))/sqrt((AE{j}.struct{i} + AE{j}.struct{i-1} + 1)/NN.scale);
            AE{j}.W{i-1} = randn(AE{j}.struct{i}, AE{j}.struct{i-1}) * eps_init(i);
            AE{j}.mask{i-1} = zeros(size(AE{j}.W{i-1}));
            for idx = 1:NN.scale
                 AE{j}.mask{i-1}(((size(AE{j}.mask{i-1},1)/NN.scale)*(idx-1)+1):(size(AE{j}.mask{i-1},1)/NN.scale)*idx, ((size(AE{j}.mask{i-1},2)/NN.scale)*(idx-1)+1):(size(AE{j}.mask{i-1},2)/NN.scale)*idx) = ones(size(AE{j}.mask{i-1})/NN.scale);
            end
            AE{j}.W{i-1} = AE{j}.W{i-1}.*(AE{j}.mask{i-1});
            AE{j}.B{i-1} = zeros(AE{j}.struct{i},1);
        end
        fprintf('\n================ Train %d autoencoder ================\n', j);
        tic
        [ AE{j},out] = bpr_training(AE{j},  data, data, [], [], opts);
        toc
        data = out{end-1};
    end 
    clear data;

%% Reconstruction of network
    for j = 1:aenum
        NN.W{j} = AE{j}.W{1};
        NN.B{j} = AE{j}.B{1};
        NN.mask{j} = AE{j}.mask{1}
    end
    if strcmp(NN.type,'DAE')
        for j = 1:aenum
            NN.W{j+aenum} = AE{aenum-j+1}.W{2};
            NN.B{j+aenum} = AE{aenum-j+1}.B{2};
            NN.mask{j+aenum} = AE{aenum-j+1}.mask{2};
        end   
    end
end

%% Fine-tuning
fprintf('\n================ Fine-tuning ================\n');
opts.quantize = true;
opts.step = 0.001;
opts.momentum = 0.9;
opts.lambda = 1e-4;
opts.maxepoch = 1000;
opts.batchsize = 1000;
tic
[NN,out] = bpr_training(NN,  X, X, [], [], opts);
toc

% net_name = (['NN_' dirname1(num+2).name '_' char(datetime('now', 'Format', 'yyyy-MM-dd_HH-mm'))]);
net_name = (['NN_scalable']);
save(net_name, 'NN');

end
end
%% Test network
if nntest
% dirname2 = dir('test_set');
    for i = 1:length(test_data_dir)
        net_name = ['NN_scalable']
        test_script_scalable(test_data_dir{i},net_name);
    end
end

