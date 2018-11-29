function rez = msvq_prop(C,test_asc)

data = test_asc;
rez = zeros(size(test_asc));
for i = 1:length(C)
    vqenc{i} = dsp.VectorQuantizerEncoder(...
    'Codebook', C{i}', ...
    'CodewordOutputPort', true, ...
    'QuantizationErrorOutputPort', true, ...
    'OutputIndexDataType', 'uint16');
ind{i} = step(vqenc{i},data);
vqdec{i} = dsp.VectorQuantizerDecoder;
vqdec{i}.Codebook = C{i}';
processed{i} = step(vqdec{i}, ind{i});
rez = rez + processed{i};
data = data - processed{i};
end