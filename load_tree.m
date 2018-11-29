function [X, Y] = load_tree(train_data_dir)

training_elements = dir(fullfile(train_data_dir, '*.mat'));
%% Load training data 
temp = [];
X = [];
Y = [];
sample_count = length(training_elements);
for sampleN = 1:sample_count
    sample_name = training_elements(sampleN, 1).name;
    data = load([train_data_dir sample_name]);  
    name = char(fieldnames(data));
    frames_count = length(fieldnames(data.(name)));
    for frameN = 1:frames_count
        frame_name = ['frame' sprintf('%d', frameN)];      
        pos1(:,frameN) = data.(name).(frame_name).weight(:,2);
        pos2(:,frameN) = data.(name).(frame_name).weight(:,3);
    end
    X = [X pos1];
    Y = [Y pos2];
    pos1 = [];
    pos2 = [];
end

