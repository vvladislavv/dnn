clear all
close all

dirname1 = dir('training_set');
dirname2 = dir('test_set');
for i = 1:length(dirname1(3:end))
    train_data_dir{i} = ['training_set\' dirname1(i+2).name '\'];
end

for i = 1:length(dirname2(3:end))
    test_data_dir{i} = ['test_set\'  dirname2(i+2).name '\'];
end

[X, ~] = load_data(train_data_dir{1}, []);
% X = cropmas(X);
% X_test = cropmas(X_test);
train = X;
train = bsxfun(@rdivide,train,std(train));
X = sort(train,1);
% test = X_test;
% test = bsxfun(@rdivide,test,std(test));
% X_test = sort(test,1);
X(isnan(X)) = 0;


% vqenc = dsp.VectorQuantizerEncoder(...
%     'Codebook', X, ...
%     'CodewordOutputPort', true, ...
%     'QuantizationErrorOutputPort', true, ...
%     'OutputIndexDataType', 'uint16');
% [ind, cw, err] = step(vqenc,X);
% 
% vqdec = dsp.VectorQuantizerDecoder;
% vqdec.Codebook = finalCB;
% qout = step(vqdec, ind);

test_script(test_data_dir{1},X)