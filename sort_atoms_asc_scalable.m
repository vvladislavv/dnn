function [ temp ] = sort_atoms_asc_scalable( training_data,scale)
train = training_data(:, 1);
fpos = [];
    for ind = 1:scale
        [val, pos]= sort(train(((ind-1)*(size(training_data,1)/scale)+1):(ind)*(size(training_data,1)/scale),1),1);
        fpos = [fpos (ind-1)*size(training_data,1)/scale+pos'];
    end  

% [val, ind]  = sort(training_data(:, 1), 'ascend');
temp = training_data(fpos, :);
end

