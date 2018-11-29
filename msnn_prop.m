function rez = msnn_prop(NN,test_asc)

data = test_asc;
rez = zeros(size(test_asc));
for i = 1:length(NN)
[processed, ~] = ffprop(NN{i}, data, true);

rez = rez + processed{end};
data = data - processed{end};
end