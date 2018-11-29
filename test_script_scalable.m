function test_script_scalable(test_data_dir, net_name)

%% Загрузка тестовых данных
test_elements = dir(fullfile(test_data_dir, '*.mat'));
labels = [];
scodes = [];
err = [];
errt = [];
load(net_name);

%% Обработка и запаковка данных для аудиокодера
sample_count = length(test_elements);
for sampleN = 1:sample_count
    sample_name = test_elements(sampleN, 1).name;
    sample_name(find(sample_name=='.',1,'last'):end) = [];
    data = load([test_data_dir sample_name]);  
    name = char(fieldnames(data));
    frames_count = length(fieldnames(data.(name)));
    for frameN = 1:frames_count
        frame_name = ['frame' sprintf('%d', frameN)];      
        % Ascend sorting for DAE
        temp.(frame_name).weight = sort_atoms_asc_scalable(data.(name).(frame_name).weight,NN.scale*size(data.(name).(frame_name).weight,1)/NN.struct{1});
        test_asc(:,frameN) = temp.(frame_name).weight(:, 1);
        % Sorting by positions for for visual evaluation       
%         temp_pos.(frame_name).weight = sort_atoms_all(data.(name).(frame_name).weight);
%         test_pos(:,frameN) = temp_pos.(frame_name).weight(:,1);
    end
    test_processed.(sample_name) = temp;
    test_processed_sort.(sample_name) = temp;
    test_pos = test_asc;
    N = size(test_asc,1);
    %% Normalization
    test_asc = [test_asc; zeros((NN.struct{1}-size(test_asc,1)),size(test_asc,2))];
     sg = std(test_asc(1:(size(test_asc,1)/NN.scale),:));
     test_asc = bsxfun(@rdivide, test_asc, sg);
%     if size(test_asc,1) < NN.struct{1}
        
        
    %% Process with DAE
    [processed, ~] = ffprop(NN, test_asc, true);
    processed = processed{end}(1:size(test_pos,1),:);

    %% Denormalization
    errt = [errt mse(processed,test_asc)]; 
    proc.(name) = bsxfun(@times, processed, sg);
%     codes.(name) = code;
%     labels = [labels sampleN*ones(1,length(codes.(name)))]; 
%     scodes = [scodes code(:,1:end-1)'];
%     codes.(name) = code';

%     temp_pos_proc = []; % Temporary array for visualization
    %% Pack processed data
    re = [];
    for frameN = 1:frames_count
        frame_name = ['frame' sprintf('%d', frameN)];
        test_processed.(sample_name).(frame_name).weight(:,1) = proc.(name)(:,frameN);
        % Sorted data by positions for visual evaluation   
%         test_processed_sort.(name).(frame_name).weight(:,1) = proc.(name)(:,frameN);
%         test_processed_sort.(name).(frame_name).weight = sort_atoms_all(test_processed_sort.(name).(frame_name).weight);
%          temp_pos_proc(:,frameN) = test_processed.(sample_name).(frame_name).weight(:,1);
    end       
    err = [err mse(proc.(name),test_pos)]; 
%     fprintf(1,[sample_name ' MSE = %e \n'], mse(proc.(name),test_pos));
    re = abs((proc.(name)-test_pos))./abs(test_pos);
    re(isnan(re))=[];
    re(isinf(re))=[];
%    re(re < 0) = [];
%     fprintf(1,[sample_name ' MSE = %e \n'], 100*sum(sum(re))/(size(re,1)*size(re,2)));
    fprintf(1,[sample_name ' ACCURACY = %2.2f %%  \n'], 100*sum(sum(1-re))/(size(re,1)*size(re,2)));
    clear test_asc test_pos
    clear temp 
end
fprintf(1,'AVG MSE = %6.6f \n',sum(err)/sample_count);
fname = ['test_processed_scalable_' sprintf('%d', N) 'atoms'];
%% Сохранение данных для аудиокодера('test_processed','test_processed');
save(fname ,'test_processed');
% save('test_processed_sort','test_processed_sort');
% figure;
% Y = tsne(scodes');
% gscatter(Y(:,1),Y(:,2),labels);
end



