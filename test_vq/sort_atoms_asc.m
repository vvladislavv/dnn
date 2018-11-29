function [ temp ] = sort_atoms_asc( training_data)
[val, ind]  = sort(training_data(:, 1), 'ascend');
temp = training_data(ind, :);
end

