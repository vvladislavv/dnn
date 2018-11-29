% close all;
clear all;
% clc;

%% training data 
% train_data_dir = 'Training_data_old\training_set_v2\';
% test_data_dir = 'Training_data_old\data\';

dirname1 = dir('training_set');
dirname2 = dir('test_set');
for i = 1:length(dirname1(3:end))
    train_data_dir{i} = ['training_set\' dirname1(i+2).name '\'];
end

for i = 1:length(dirname2(3:end))
    test_data_dir{i} = ['test_set\'  dirname2(i+2).name '\'];
end
NNtest = true;
NNtrain = true;



if NNtrain
for num  = 1:length(train_data_dir)-3
[X, ~] = load_data(train_data_dir{num}, []);
% X = cropmas(X);
% X_test = cropmas(X_test);
train = X;
train = bsxfun(@rdivide,train,std(train));
X = sort(train,1);

% test = X_test;
% test = bsxfun(@rdivide,test,std(test));
% X_test = sort(test,1);


X(isnan(X)) = 0;
% X_test(isnan(X_test)) = 0;

clear train test;

%% Creation and initialization
insize = size(X,1);
data = X;
for ks = 1:20
NN{ks}.scale = 1;
NN{ks}.struct = {insize 1 insize}; % network structure
NN{ks}.afun = {'linear', 'staircase', 'linear'};
NN{ks}.type = 'DAE'; %'DNN{ks}'
NN{ks}.pretrain =  false; %false; 
NN{ks}.atoms = dirname1(num+2).name;

%% Generate random weights (if no pretraining)
for i = 2:length(NN{ks}.struct)
    eps_initt = sqrt(6)/sqrt((NN{ks}.struct{i} + NN{ks}.struct{i-1}));
    NN{ks}.W{i-1} = 0.01 * randn(NN{ks}.struct{i}, NN{ks}.struct{i-1}) * eps_initt;
    NN{ks}.B{i-1} = zeros(NN{ks}.struct{i},1);
end

%% Training setup
opts.method = 'momentum';    %'momentum', 'adadelta', 'RMSprop'
opts.step = 0.001;          % learning rate
opts.momentum = 0.9;        % momentum rate
opts.lambda = 1e-4;         % L2-norm scale
opts.maxepoch = 100;         % max number of training iterations
opts.eps = 0.000001;         % min error threshold
opts.batchsize = 200;      % number of samples per batch
opts.quantize = false;      % conditional enabling of quantization
opts.step_dec = 0.7;        % rate of decreasing learning speed
opts.step_inc = 1.05;       % rate of increasing learning speed
opts.step_max = 0.1;        % maximal step
opts.step_min = 0.00001;    % minimal step
opts.err_win_len = 16;      % error control window
opts.shake = false;
opts.similar = false;
                   
%% Stacked autoencoder pretraining (if number of layers more than 3)
if (length(NN{ks}.struct)>3) && NN{ks}.pretrain
    if strcmp(NN{ks}.type,'DAE')
        aenum = floor(length(NN{ks}.struct)/2);
    else
        aenum = length(NN{ks}.struct)-2;
    end

%% Train encoders
    data = X;
%%
    for j = 1:aenum   
        AE{j}.struct = {NN{ks}.struct{j}, NN{ks}.struct{j+1}, NN{ks}.struct{j}}; % AE structure  
        AE{j}.afun = {NN{ks}.afun{j}, NN{ks}.afun{j+1}, NN{ks}.afun{j}}; % AE activation
        AE{j}.scale = NN{ks}.scale;
        for i = 2:length(AE{1}.struct)
            eps_init(i) =  sqrt(1/(std(data(:))))/sqrt((AE{j}.struct{i} + AE{j}.struct{i-1} + 1)/NN{ks}.scale);
            AE{j}.W{i-1} = randn(AE{j}.struct{i}, AE{j}.struct{i-1}) * eps_init(i);
            AE{j}.mask{i-1} = zeros(size(AE{j}.W{i-1}));
            for idx = 1:NN{ks}.scale
                 AE{j}.mask{i-1}(((size(AE{j}.mask{i-1},1)/NN{ks}.scale)*(idx-1)+1):(size(AE{j}.mask{i-1},1)/NN{ks}.scale)*idx, ((size(AE{j}.mask{i-1},2)/NN{ks}.scale)*(idx-1)+1):(size(AE{j}.mask{i-1},2)/NN{ks}.scale)*idx) = ones(size(AE{j}.mask{i-1})/NN{ks}.scale);
            end
            AE{j}.W{i-1} = AE{j}.W{i-1}.*(AE{j}.mask{i-1});
            AE{j}.B{i-1} = zeros(AE{j}.struct{i},1);
        end
        fprintf('\n================ Train %d autoencoder ================\n', j);
        tic
%         if j == 3
%             opts.maxepoch = 500;
%             opts.shake = true;
%         end;
            
        [ AE{j},out] = bpr_training(AE{j},  data, data, [], [], opts);
        toc
        data = out{end-1};
    end 
    clear data;

%% Reconstruction of network
    for j = 1:aenum
        NN{ks}.W{j} = AE{j}.W{1};
        NN{ks}.B{j} = AE{j}.B{1};
        NN{ks}.mask{j} = AE{j}.mask{1}
    end
    if strcmp(NN{ks}.type,'DAE')
        for j = 1:aenum
            NN{ks}.W{j+aenum} = AE{aenum-j+1}.W{2};
            NN{ks}.B{j+aenum} = AE{aenum-j+1}.B{2};
            NN{ks}.mask{j+aenum} = AE{aenum-j+1}.mask{2};
        end   
    end
end

%% Fine-tuning
fprintf('\n================ Fine-tuning ================\n');
opts.quantize = false;
opts.step = 0.001;
opts.momentum = 0.0;
opts.lambda = 1e-4;
opts.maxepoch = 100;
opts.batchsize = 50;
opts.similar = false;
tic
[NN{ks},out] = bpr_training(NN{ks},  X, X, [], [], opts);
toc
X  = X - out{end};

% net_name = (['NN{ks}_' dirname1(num+2).name '_' char(datetime('now', 'Format', 'yyyy-MM-dd_HH-mm'))]);


end
end
end
net_name = (['NN_test_ms']);
save(net_name, 'NN');
%% Test network
if NNtest
% dirname2 = dir('test_set');
    for i = 1:length(test_data_dir)
%         net_name = ['NN{ks}_test' dirname2(i+2).name]
        test_script_ms(test_data_dir{i},NN);
    end
end

