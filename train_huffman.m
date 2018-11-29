clear all
close all
clc;
dirname1 = dir('training_set');
train_data_dir{1} = ['training_set\' dirname1(3).name '\'];
load NN_200atoms
[X, ~] = load_data(train_data_dir{1}, []);
[pos1, pos2] = load_tree(train_data_dir{1});
train = X;
sd = std(train);
train = bsxfun(@rdivide,train,sd);
train = sort(train,1);
train(isnan(train)) = 0;
[processed, ~] = ffprop(NN, train, true);
mse(bsxfun(@times,processed{end},sd),sort(X,1))
activations = processed{4};
activations_quantized = fix((31*((((round(((processed{4}/2)+1/2)*31)/31)-1/2)*2+1)/2))+1);
N = 1000;
idex = randperm(size(activations_quantized,2));
numb = idex(1:N);
d{1} = fix(activations_quantized(:,numb));
d{2} = fix(pos1(:,numb));
d{3} = fix(pos2(:,numb));
for i = 1:length(d)
    a = []; idx = []; prob = [];
    a = hist(d{i}(:),[min(d{i}(:)):max(d{i}(:))]);
    idx = find((a>0))+(min(d{i}(:))-1);
    a(a==0) = [];
    prob = a/length(d{i}(:));
    [dict,avglen] = huffmandict(idx',prob'); 
    comp = huffmanenco(d{i}(:),dict);
    dsig = huffmandeco(comp,dict);
    isequal(d{i}(:),dsig)
    binaryComp = de2bi(comp);
    encodedLen(i) = fix(numel(binaryComp)/1000)
    huffdict{i} = dict;
end
save huffdict huffdict;  
sum(encodedLen)
save activations activations
save activations_quantized activations_quantized

