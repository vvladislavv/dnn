function [ temp1 ] = sort_atoms_all( training_data)
[val1, ind1]  = sort(training_data(:, 3), 'descend');
temp2 = training_data(ind1, :);
[val, ind]  = sort(temp2(:, 2), 'descend');
temp = temp2(ind,:);  
ind(temp(:,2)>=128) = rot90(ind(temp(:,2)>=128)');
ind(and(temp(:,2)>=64,  temp(:,2)<128)) = rot90(ind(and(temp(:,2)>=64, temp(:,2)<128))');
ind(and(temp(:,2)>=32,  temp(:,2)<64)) = rot90(ind(and(temp(:,2)>=32, temp(:,2)<64))');
ind(and(temp(:,2)>=16,  temp(:,2)<32)) = rot90(ind(and(temp(:,2)>=16, temp(:,2)<32))');
ind(and(temp(:,2)>=8,  temp(:,2)<16)) = rot90(ind(and(temp(:,2)>=8, temp(:,2)<16))');
ind(and(temp(:,2)>=4,  temp(:,2)<8)) = rot90(ind(and(temp(:,2)>=4, temp(:,2)<8))');
ind(and(temp(:,2)>=2,  temp(:,2)<4)) = rot90(ind(and(temp(:,2)>=2, temp(:,2)<4))');
ind(and(temp(:,2)>=1,  temp(:,2)<2)) = rot90(ind(and(temp(:,2)>=1, temp(:,2)<2))');
temp1 = temp2(ind,:);   
end

