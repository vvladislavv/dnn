%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% bpr_training.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ FF,a] = bpr_training_gan(FF,  X, Y, X_test, Y_test, opts)
m = opts.batchsize;
N =size(X,2);
numbatches = floor(N/opts.batchsize);
err_hist = [];
len = length(FF.W)+1;

%% Create discriminator
insize = size(X,1);
DD.scale = 1;
DD.struct = {insize insize/2 insize/4 1}; 
% NN.struct = {insize 150 100 25 insize}; % network structure
DD.afun = {'linear', 'tanh', 'tanh', 'sigmoid'};
% Generate random weights (if no pretraining)
for i = 2:length(DD.struct)
    eps_initt = sqrt(6)/sqrt((DD.struct{i} + DD.struct{i-1}));
    DD.W{i-1} = randn(DD.struct{i}, DD.struct{i-1}) * eps_initt;
    DD.B{i-1} = zeros(DD.struct{i},1);
end
dlen = length(DD.W)+1;

for d = 1:dlen-1 
    xdW{d} = zeros(size(DD.W{d})); 
    xhdW{d} = zeros(size(DD.W{d}));
    xacchdW{d} = zeros(size(DD.W{d}));
    xgradW{d} = zeros(size(DD.W{d})); 
    xdB{d} = zeros(size(DD.B{d})); 
    xhdB{d} = zeros(size(DD.B{d})); 
    xgradB{d} = zeros(size(DD.B{d})); 
    xacchdB{d} = zeros(size(DD.B{d}));
end
%%
hD_L = []; %????D????
hG_L = []; %????G????   

for d = 1:len-1 
    dW{d} = zeros(size(FF.W{d})); 
    hdW{d} = zeros(size(FF.W{d}));
    acchdW{d} = zeros(size(FF.W{d}));
    gradW{d} = zeros(size(FF.W{d})); 
    dB{d} = zeros(size(FF.B{d})); 
    hdB{d} = zeros(size(FF.B{d})); 
    gradB{d} = zeros(size(FF.B{d})); 
    acchdB{d} = zeros(size(FF.B{d}));
end
epsi = 1e-6;
err_test = 0;
for epoch = 1:opts.maxepoch 
    randomorder=randperm(N);
    err = 0;
    simerr = 0;
    accuracy = 0;
    err_rel = [];
    for d = 1:len-1
        % Weight save
        W{d} = FF.W{d};
        % Bias unit save
        B{d} = FF.B{d};
    end
D_L = []; %????D????
G_L = []; %????G????    
    
% for it = 1:N
%     [mIdx] = knnsearch(X',X','K',10);
% end
    
for batch = 1:numbatches     
data = X(:,randomorder(1+(batch-1)*opts.batchsize:batch*opts.batchsize));
target = Y(:,randomorder(1+(batch-1)*opts.batchsize:batch*opts.batchsize));

    if opts.denoise>0
      ndata = data+opts.denoise*bsxfun(@times,std(data(:)),randn(size(data)));
%        ndata = data.*binornd(1,opts.denoise,size(data));  
    else
    ndata = data;
    end 
    
%     target = ndata;


%         images_real = train_x(kk((t - 1) * batch_size + 1:t * batch_size), :, :);
%         noise = unifrnd(-1, 1, batch_size, 100);
%         % ????
%         % -----------??generator???discriminator
%         +generator = nnff(generator, noise);
%         +images_fake = generator.layers{generator.layers_count}.a;
%         +discriminator = nnff(discriminator, images_fake);
%         +logits_fake = discriminator.layers{discriminator.layers_count}.z;
%         +discriminator = nnbp_d(discriminator, logits_fake, ones(batch_size, 1));
%         +generator = nnbp_g(generator, discriminator);
%         +generator = nnapplygrade(generator, learning_rate);
%         % -----------??discriminator???generator
%         +generator = nnff(generator, noise);
%         +images_fake = generator.layers{generator.layers_count}.a;
%         +images = [images_fake;images_real];
%         +discriminator = nnff(discriminator, images);
%         +logits = discriminator.layers{discriminator.layers_count}.z;
%         +labels = [zeros(batch_size,1);ones(batch_size,1)];
%         discriminator = nnbp_d(discriminator, logits, labels);
%         discriminator = nnapplygrade(discriminator, learning_rate);
%    
% [a, z, drop, qnt] = ffprop(FF, ndata, opts.quantize,opts.dropout);
% [dda, ddz, dddrop, ddqnt] = ffprop(DD, a{end}, opts.quantize,opts.dropout);
% %
% dddelta = cell(size(dda));      
% % dddelta{dlen} = delta_sigmoid_cross_entropy(ddz{end}, ones(1,opts.batchsize)); 
% dddelta{dlen} = -(ones(1,opts.batchsize)-dda{end}).*dafunc(ddz{dlen}, dda{dlen}, DD.afun{dlen}).*dddrop{dlen};  
% [DD,~,~,~,~,dddelta] = bp_grad(DD,dda,ddz,dddrop,ddqnt,m,epoch,opts,target,xdW, xdB,xhdW,xhdB,dddelta,false);
% %
% delta = cell(size(a));      
% delta{len} = 16*(DD.W{1}' * dddelta{2}).*dafunc(z{len}, a{len}, FF.afun{len}); %  -(target - a{end})
% [FF,dW,dB,hdW,hdB,delta] = bp_grad(FF,a,z,drop,qnt,m,epoch,opts,target,dW, dB,hdW,hdB,delta,true);
% %-------------------------------------------------------------------------------------
% [a, z, drop, qnt] = ffprop(FF, ndata, opts.quantize,opts.dropout);
% samples = [a{end} data];
% [dda, ddz, dddrop, ddqnt] = ffprop(DD, samples, opts.quantize,opts.dropout);
% labels = [-ones(1,opts.batchsize) ones(1,opts.batchsize)];
% dddelta = cell(size(dda));      
% % dddelta{dlen} = delta_sigmoid_cross_entropy(ddz{end}, labels); 
% dddelta{dlen} = -(labels - dda{end}).*dafunc(ddz{dlen}, dda{dlen}, DD.afun{dlen}).*dddrop{dlen}; 
% [DD,xdW,xdB,xhdW,xhdB,dddelta] = bp_grad(DD,dda,ddz,dddrop,ddqnt,2*m,epoch,opts,target,xdW, xdB,xhdW,xhdB,dddelta,true);




[a, z, drop, qnt] = ffprop(FF, ndata, opts.quantize,opts.dropout);
samples = [a{end} data];
labels = [zeros(1,opts.batchsize) ones(1,opts.batchsize)];
[dda, ddz, dddrop, ddqnt] = ffprop(DD, samples, opts.quantize,opts.dropout);
netD_loss = (dda{end} - labels); %D??????
netG_loss = (dda{end} .* (labels == 0) - (labels==0)); %G??????  
D_L = [D_L;sum(1/2*(netD_loss).^2)/length(labels)]; %D????
G_L = [G_L;sum(1/2*(netG_loss).^2)/length(labels)*2]; %G????

dddelta = cell(size(dda)); 
dddelta{dlen} = netG_loss.*dafunc(ddz{dlen}, dda{dlen}, DD.afun{dlen}).*dddrop{dlen}; 
[DD,~,~,~,~,dddelta] = bp_grad(DD,dda,ddz,dddrop,ddqnt,m,epoch,opts,target,xdW, xdB,xhdW,xhdB,dddelta,false);

delta = cell(size(a));      
delta{len} = (DD.W{1}' * dddelta{2}(:,1:opts.batchsize))-0.1*(target - a{end});%.*dafunc(z{len}, a{len}, FF.afun{len}); %  -(target - a{end})
[FF,dW,dB,hdW,hdB,delta] = bp_grad(FF,a,z,drop,qnt,m,epoch,opts,target,dW, dB,hdW,hdB,delta,true);

dddelta = cell(size(dda)); 
dddelta{dlen} = netD_loss.*dafunc(ddz{dlen}, dda{dlen}, DD.afun{dlen}).*dddrop{dlen}; 
[DD,xdW,xdB,xhdW,xhdB,dddelta] = bp_grad(DD,dda,ddz,dddrop,ddqnt,m,epoch,opts,target,xdW, xdB,xhdW,xhdB,dddelta,true);


%     netD_D = backward(netD, netD_loss); % D??????
%     netD_G = backward(netD, netG_loss); 
%     
%     netG_o_loss_temp = netD_G.w' * netD_G.d_hi; % G????(??????????)
%     % G??????(?????????)
%     temp_data = [rand_idx', netG_o_loss_temp']; 
%     temp_data = sortrows(temp_data,1); %??rand_idx??????????[1-batchsize]?G??????????
%     netG_o_loss = temp_data(1:32, 2:end)'; % G??????
%     
%     netG = backward(netG, netG_o_loss); %G??????
%     netD = upgrading(netD_D); %D??????
% netG = upgrading(netG); %G??????






    err = err + mse(a{end},target);  
    err_rel = abs((a{end}-target))./abs(target);
    err_rel(isnan(err_rel))=[];
    err_rel(isinf(err_rel))=[];
    err_rel((err_rel)>std(err_rel(:)))=std(err_rel(:));

%     100*sum(sum(1-err_rel))/(size(err_rel,1)*size(err_rel,2))
    accuracy = accuracy + 100*sum(sum(1-err_rel))/(size(err_rel,1)*...
        size(err_rel,2));

    
    
end
hD_L = [hD_L mean(D_L)]; %D????
hG_L = [hG_L mean(G_L)]; %G????
err_hist = [err_hist err/numbatches];

% Validation (if X_test is not empty)
if ~isempty(X_test)
    data = X_test;
    [a, ~,~,~] = ffprop(FF, data, opts.quantize,0);    
    err_test = mse(a{end},Y_test);
end

fprintf('Epoch %d Train error %4.6f Test error %4.6f Accuracy %2.2f %%\n',...
    epoch, 16*err_hist(end), err_test, (accuracy/numbatches));

%              c_loss = sigmoid_cross_entropy(dda{end}(1:opts.batchsize), ones(1,opts.batchsize));
%              d_loss = sigmoid_cross_entropy(dda{end}, labels);
             c_loss = mse(dda{end}(1:opts.batchsize), ones(1,opts.batchsize));
             d_loss = mse(dda{end}, labels);
            fprintf('c_loss:"%f",d_loss:"%f"\n',hD_L(end), hG_L(end));

% Generate output data & Stop conditions
if (epoch == opts.maxepoch) %|| ...
%   (stop_condition(err_hist, opts.eps, opts.err_win_len))
   data = X;
   [a, ~,~,~] = ffprop(FF, data, opts.quantize,0);   
   break;
end
end
end

function result = delta_sigmoid_cross_entropy(logits, labels)
    temp1 = max(logits, 0);
    temp1(temp1>0) = 1;
    temp2 = logits;
    temp2(temp2>0) = -1;
    temp2(temp2<0) = 1;
    result = temp1 - labels + exp(-abs(logits))./(1+exp(-abs(logits))) .* temp2;
end

function result = sigmoid_cross_entropy(logits, labels)
    result = max(logits, 0) - logits .* labels + log(1 + exp(-abs(logits)));
    result = mean(result);
end

