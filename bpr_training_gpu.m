function [ FF,a] = bpr_training_gpu(FF,  X, Y, X_test, Y_test, opts)
m = opts.batchsize;
N =size(X,2);
numbatches = floor(N/opts.batchsize);
err_hist = [];
len = length(FF.layers)+1;

for d = 1:len-1 
    dW{d} = zeros(size(FF.layers(d).W),'gpuArray'); 
    gradW{d} = zeros(size(FF.layers(d).W), 'gpuArray'); 
    dB{d} = zeros(size(FF.layers(d).B), 'gpuArray'); 
    gradB{d} = zeros(size(FF.layers(d).B), 'gpuArray'); 
end

err_test = 0;

for epoch = 1:opts.maxepoch 
    randomorder=randperm(N);
    err = 0;
    for d = 1:len-1
        % Weight save
        W{d} = FF.layers(d).W;
        % Bias unit save
        B{d} = FF.layers(d).B;
    end
for batch = 1:numbatches     
    data = X(:,randomorder(1+(batch-1)*opts.batchsize:batch*opts.batchsize));
    target = Y(:,randomorder(1+(batch-1)*opts.batchsize:batch*opts.batchsize));
    a{1} = data;
    act = a{1};
    for d = 1:len-1
        z{d+1} = FF.layers(d).W*act + repmat(FF.layers(d).B, 1, m);
        a{d+1} = afunc(z{d+1},FF.afun{d+1});
        if d == (len-1)/2 && opts.quantize
            act = ((round(((a{d+1}/2)+1/2)*31)/31)-1/2)*2;
        else
            act = a{d+1};
        end
    end
    
    err = err + mse(a{d+1},target);    

    delta = cell(size(a));      
    delta{len} = -(target - a{d+1}).*dafunc(z{len}, a{len}, FF.afun{len});      
    for d = len-1:-1:2 
        delta{d} = FF.layers(d).W' * delta{d+1} .* dafunc(z{d}, a{d}, FF.afun{d});
    end
    
    for d = 1:len-1
        gradB{d} = sum(delta{d+1},2)/m;
        gradW{d} = (delta{d+1}*a{d}')/m + opts.lambda*FF.layers(d).W;
    end

    for d = 1:len-1
        % Weight update
        dW{d} = opts.step*gradW{d} + opts.momentum*dW{d};
        FF.layers(d).W = FF.layers(d).W - dW{d};
        % Bias unit update
        dB{d} = opts.step*gradB{d} + opts.momentum*dB{d};
        FF.layers(d).B = FF.layers(d).B - dB{d};
    end
end
gpuarray
err_hist = [err_hist err/numbatches];

% Adaptive opts.step size
if epoch>1
    if err_hist(end) > 1.01*err_hist(end-1) && opts.step > opts.step_min
        opts.step = opts.step*opts.step_dec;
        % The new weights and biases are discarded
        for d = 1:len-1
            FF.layers(d).W = W{d};
            FF.layers(d).B = B{d};
        end
        fprintf('The new weights and biases are DISCARDED!\n');
    elseif err_hist(end) < err_hist(end-1) && opts.step < opts.step_max
        opts.step = opts.step*opts.step_inc;
    else 
        opts.step = opts.step;
    end
end

% Test error calculation (if X_test is not empty)
if ~isempty(X_test)
    data = X_test;
    M =size(X_test,2);
    a{1} = data;
    for d = 1:len-1
        z{d+1} = FF.layers(d).W*a{d} + repmat(FF.layers(d).B, 1, M);
        a{d+1} = afunc(z{d+1},FF.afun{d+1});
        if d == (len-1)/2 && opts.quantize
            a{d+1} = ((round(((a{d+1}/2)+1/2)*31)/31)-1/2)*2;
        end
    end
    err_test = mse(a{d+1},Y_test);
end

fprintf('Epoch %d Train error %4.7f Test error %4.7f\n', epoch, err_hist(end), err_test);

% Generate output data & Stop conditions
if (stop_condition(err_hist, opts.eps, opts.err_win_len) || (epoch == opts.maxepoch)) && FF.pretrain
    data = X;
    a{1} = data;
    for d = 1:len-1
        z{d+1} = FF.layers(d).W*a{d} + repmat(FF.layers(d).B, 1, N);
        a{d+1} = afunc(z{d+1},FF.afun{d+1});
        if d == (len-1)/2 && opts.quantize
            a{d+1} = ((round(((a{d+1}/2)+1/2)*31)/31)-1/2)*2;
        end
    end
    break;
end
end
end

