clear;
clc;
% -----------????
load('mnist_uint8', 'train_x');
train_x = double(reshape(train_x, 60000, 28, 28))/255;
train_x = permute(train_x,[1,3,2]);
train_x = reshape(train_x, 60000, 784);
% -----------------????
generator = nnsetup([100, 512, 784]);
discriminator = nnsetup([784, 512, 1]);
% -----------????
batch_size = 60;
epoch = 100;
images_num = 60000;
batch_num = ceil(images_num / batch_size);
learning_rate = 0.001;
for e=1:epoch
    kk = randperm(images_num);
    for t=1:batch_num
        % ????
        images_real = train_x(kk((t - 1) * batch_size + 1:t * batch_size), :, :);
        noise = unifrnd(-1, 1, batch_size, 100);
        % ????
        % -----------??generator???discriminator
        generator = nnff(generator, noise);
        images_fake = generator.layers{generator.layers_count}.a;
        discriminator = nnff(discriminator, images_fake);
        logits_fake = discriminator.layers{discriminator.layers_count}.z;
        discriminator = nnbp_d(discriminator, logits_fake, ones(batch_size, 1));
        generator = nnbp_g(generator, discriminator);
        generator = nnapplygrade(generator, learning_rate);
        % -----------??discriminator???generator
        generator = nnff(generator, noise);
        images_fake = generator.layers{generator.layers_count}.a;
        images = [images_fake;images_real];
        discriminator = nnff(discriminator, images);
        logits = discriminator.layers{discriminator.layers_count}.z;
        labels = [zeros(batch_size,1);ones(batch_size,1)];
        discriminator = nnbp_d(discriminator, logits, labels);
        discriminator = nnapplygrade(discriminator, learning_rate);
        % ----------------??loss
        if t == batch_num
            c_loss = sigmoid_cross_entropy(logits(1:batch_size), ones(batch_size, 1));
            d_loss = sigmoid_cross_entropy(logits, labels);
            fprintf('c_loss:"%f",d_loss:"%f"\n',c_loss, d_loss);
        end
%         if t == batch_num
%             path = ['/pics/epoch_',int2str(e),'_t_',int2str(t),'.png'];
%             save_images(images_fake, [4, 4], path);
%             fprintf('save_sample:%s\n', path);
%         end
    end
    mse(images_fake,images_real)
end
% sigmoid????
function output = sigmoid(x)
    output =1./(1+exp(-x));
end
% relu
function output = relu(x)
    output = max(x, 0);
end
% relu?x???
function output = delta_relu(x)
    output = max(x,0);
    output(output>0) = 1;
end
% ???????????logits????sigmoid???
% https://www.tensorflow.org/api_docs/python/tf/nn/sigmoid_cross_entropy_with_logits
function result = sigmoid_cross_entropy(logits, labels)
    result = max(logits, 0) - logits .* labels + log(1 + exp(-abs(logits)));
    result = mean(result);
end
% sigmoid_cross_entropy?logits???????logits????sigmoid???
function result = delta_sigmoid_cross_entropy(logits, labels)
    temp1 = max(logits, 0);
    temp1(temp1>0) = 1;
    temp2 = logits;
    temp2(temp2>0) = -1;
    temp2(temp2<0) = 1;
    result = temp1 - labels + exp(-abs(logits))./(1+exp(-abs(logits))) .* temp2;
end
% ???????????
function nn = nnsetup(architecture)
    nn.architecture   = architecture;
    nn.layers_count = numel(nn.architecture);
    % t,beta1,beta2,epsilon,nn.layers{i}.w_m,nn.layers{i}.w_v,nn.layers{i}.b_m,nn.layers{i}.b_v???adam???????????
    nn.t = 0;
    nn.beta1 = 0.9;
    nn.beta2 = 0.999;
    nn.epsilon = 10^(-8);
    % ?????[100, 512, 784]???3?????100???????100*512?512*784, ????????a??????
    for i = 2 : nn.layers_count   
        nn.layers{i}.w = normrnd(0, 0.02, nn.architecture(i-1), nn.architecture(i));
        nn.layers{i}.b = normrnd(0, 0.02, 1, nn.architecture(i));
        nn.layers{i}.w_m = 0;
        nn.layers{i}.w_v = 0;
        nn.layers{i}.b_m = 0;
        nn.layers{i}.b_v = 0;
    end
end
% ????
function nn = nnff(nn, x)
    nn.layers{1}.a = x;
    for i = 2 : nn.layers_count
        input = nn.layers{i-1}.a;
        w = nn.layers{i}.w;
        b = nn.layers{i}.b;
        nn.layers{i}.z = input*w + repmat(b, size(input, 1), 1);
        if i ~= nn.layers_count
            nn.layers{i}.a = relu(nn.layers{i}.z);
        else
            nn.layers{i}.a = sigmoid(nn.layers{i}.z);
        end
    end
end
% discriminator?bp????bp???????????
% ???????????????????bp??????weights?biases?????????bp
% ????w,b????????loss?w?b???????????w?b?????????????
function nn = nnbp_d(nn, y_h, y)
    % d????????????loss????????z?????????????????????-???????
    n = nn.layers_count;
    % ???????
    nn.layers{n}.d = delta_sigmoid_cross_entropy(y_h, y);
    for i = n-1:-1:2
        d = nn.layers{i+1}.d;
        w = nn.layers{i+1}.w;
        z = nn.layers{i}.z;
        % ????????????????????????????????w,????????????????
        nn.layers{i}.d = d*w' .* delta_relu(z);    
    end
    % ?????????????????????loss?weights?biases????
    for i = 2:n
        d = nn.layers{i}.d;
        a = nn.layers{i-1}.a;
        % dw?????weights????????
        nn.layers{i}.dw = a'*d / size(d, 1);
        nn.layers{i}.db = mean(d, 1);
    end
end
% generator?bp
function g_net = nnbp_g(g_net, d_net)
    n = g_net.layers_count;
    a = g_net.layers{n}.a;
    % generator?loss??label_fake????(images_fake?discriminator??label_fake)
    % ?g??bp???????g?d???????
    % g?????????d?2??????(a .* (a_o))
    g_net.layers{n}.d = d_net.layers{2}.d * d_net.layers{2}.w' .* (a .* (1-a));
    for i = n-1:-1:2
        d = g_net.layers{i+1}.d;
        w = g_net.layers{i+1}.w;
        z = g_net.layers{i}.z;
        % ????????????????????????????????w,????????????????
        g_net.layers{i}.d = d*w' .* delta_relu(z);    
    end
    % ?????????????????????loss?weights?biases????
    for i = 2:n
        d = g_net.layers{i}.d;
        a = g_net.layers{i-1}.a;
        % dw?????weights????????
        g_net.layers{i}.dw = a'*d / size(d, 1);
        g_net.layers{i}.db = mean(d, 1);
    end
end
% ????
% ??adam????????????
% https://www.tensorflow.org/api_docs/python/tf/train/AdamOptimizer
function nn = nnapplygrade(nn, learning_rate)
    n = nn.layers_count;
    nn.t = nn.t+1;
    beta1 = nn.beta1;
    beta2 = nn.beta2;
    lr = learning_rate * sqrt(1-nn.beta2^nn.t) / (1-nn.beta1^nn.t);
    for i = 2:n
        dw = nn.layers{i}.dw;
        db = nn.layers{i}.db;
        % ???6??????adam??weights?biases
        nn.layers{i}.w_m = beta1 * nn.layers{i}.w_m + (1-beta1) * dw;
        nn.layers{i}.w_v = beta2 * nn.layers{i}.w_v + (1-beta2) * (dw.*dw);
        nn.layers{i}.w = nn.layers{i}.w - lr * nn.layers{i}.w_m ./ (sqrt(nn.layers{i}.w_v) + nn.epsilon);
        nn.layers{i}.b_m = beta1 * nn.layers{i}.b_m + (1-beta1) * db;
        nn.layers{i}.b_v = beta2 * nn.layers{i}.b_v + (1-beta2) * (db.*db);
        nn.layers{i}.b = nn.layers{i}.b - lr * nn.layers{i}.b_m ./ (sqrt(nn.layers{i}.b_v) + nn.epsilon); 
    end
end
% ?????????generator???images_fake
function save_images(images, count, path)
    n = size(images, 1);
    row = count(1);
    col = count(2);
    I = zeros(row*28, col*28);
    for i = 1:row
        for j = 1:col
            r_s = (i-1)*28+1;
            c_s = (j-1)*28+1;
            index = (i-1)*col + j;
            pic = reshape(images(index, :), 28, 28);
            I(r_s:r_s+27, c_s:c_s+27) = pic;
        end
    end
    imwrite(I, path);
end