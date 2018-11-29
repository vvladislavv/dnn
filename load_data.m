%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% load_data.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [X, X_test] = load_data(train_data_dir, test_data_dir)

training_elements = dir(fullfile(train_data_dir, '*.mat'));
%% Load training data 
temp = [];
X = [];
X_test = [];
sample_count = length(training_elements);
for sampleN = 1:sample_count
    sample_name = training_elements(sampleN, 1).name;
    data = load([train_data_dir sample_name]);  
    name = char(fieldnames(data));
    frames_count = length(fieldnames(data.(name)));
    for frameN = 1:frames_count
        frame_name = ['frame' sprintf('%d', frameN)];      
        temp(:,frameN) = data.(name).(frame_name).weight(:,1);
    end
    X = [X temp];
    temp = [];
end

%% Load test data 
if ~isempty(test_data_dir)
test_elements = dir(fullfile(test_data_dir, '*.mat'));
sample_count = length(test_elements);
temp = [];
X_test = [];
for sampleN = 1:sample_count
    sample_name = test_elements(sampleN, 1).name;
    data = load([test_data_dir sample_name]);  
    name = char(fieldnames(data));
    frames_count = length(fieldnames(data.(name)));
    for frameN = 1:frames_count
        frame_name = ['frame' sprintf('%d', frameN)];      
        temp(:,frameN) = data.(name).(frame_name).weight(:,1);
    end
    X_test = [X_test temp];
    temp = [];
end

end
end






