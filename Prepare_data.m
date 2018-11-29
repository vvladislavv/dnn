clear all

training_data = struct;

training_elements = dir('Training_set\Speech\MAT_files\*trees*');

for smpls_count = 1:length(training_elements)
    smpl_name = training_elements(smpls_count, 1).name;
    load(['Training_set\Speech\MAT_files\' smpl_name]);
    
    frames_count = length(fieldnames(all_trees));
    
    for frameN = 1:frames_count
        frame_name = ['frame' sprintf('%d', frameN)];
        tmp = all_trees.(frame_name).weight;
    end
end

% save('test_data_es03', 'training_data');