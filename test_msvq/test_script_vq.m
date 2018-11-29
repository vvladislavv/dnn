function test_script_vq(test_data_dir, finalCB)

%% Загрузка тестовых данных
test_elements = dir(fullfile(test_data_dir, '*.mat'));
err = [];
errt = [];

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
        temp.(frame_name).weight = sort_atoms_asc(data.(name).(frame_name).weight);
        test_asc(:,frameN) = temp.(frame_name).weight(:, 1);
        % Sorting by positions for for visual evaluation       
         temp_pos.(frame_name).weight = sort_atoms_all(data.(name).(frame_name).weight);
%          temp_pos.(frame_name).weight = (data.(name).(frame_name).weight);
        test_pos(:,frameN) = temp_pos.(frame_name).weight(:,1);
    end
    test_processed.(sample_name) = temp;
    test_processed_sort.(sample_name) = temp;

    %% Normalization
    sg = std(test_asc);
    test_asc = bsxfun(@rdivide, test_asc, sg);

    %% Process with DAE
%     [processed, ~] = ffprop(NN, test_asc, true);
    
    vqenc = dsp.VectorQuantizerEncoder(...
    'Codebook', finalCB, ...
    'CodewordOutputPort', true, ...
    'QuantizationErrorOutputPort', true, ...
    'OutputIndexDataType', 'uint16');
[ind, cw, err] = step(vqenc,test_asc);

vqdec = dsp.VectorQuantizerDecoder;
vqdec.Codebook = finalCB;
processed = step(vqdec, ind);



    %% Denormalization
    errt = [errt mse(processed{end},test_asc)]; 
    proc.(name) = bsxfun(@times, processed{end}, sg);
%     codes.(name) = code;
%     labels = [labels sampleN*ones(1,length(codes.(name)))]; 
%     scodes = [scodes code(:,1:end-1)'];
%     codes.(name) = code';

    temp_pos_proc = []; % Temporary array for visualization
    re = [];
    %% Pack processed data
    for frameN = 1:frames_count
        frame_name = ['frame' sprintf('%d', frameN)];
        test_processed.(sample_name).(frame_name).weight(:,1) = proc.(name)(:,frameN);
        % Sorted data by positions for visual evaluation   
        test_processed_sort.(sample_name).(frame_name).weight(:,1) = proc.(name)(:,frameN);
        test_processed_sort.(sample_name).(frame_name).weight = sort_atoms_all(test_processed_sort.(sample_name).(frame_name).weight);
        temp_pos_proc(:,frameN) = test_processed_sort.(sample_name).(frame_name).weight(:,1);
    end 
%       test_pos(isnan(test_pos)) = 0;
%       temp_pos_proc(isnan(temp_pos_proc)) = 0;
%       test_pos(isinf(test_pos)) = 0;
%       temp_pos_proc(isinf(temp_pos_proc)) = 0;
%       test_pos((test_pos==0)) = 0;
%       temp_pos_proc((temp_pos_proc==0)) = 0;
    
    err = [err mse(temp_pos_proc,test_pos)]; 
%     re = min(abs(test_pos), abs(temp_pos_proc))./max(abs(test_pos), abs(temp_pos_proc));
%     re = 1-abs((temp_pos_proc-test_pos)./(test_pos));
    re = abs((temp_pos_proc-test_pos))./abs(test_pos);
    re(isnan(re))=[];
    re(isinf(re))=[];
%    re(re < 0) = [];
     fprintf(1,[sample_name ' MSE = %e \n'], mse(temp_pos_proc,test_pos));
    fprintf(1,[sample_name ' ACCURACY = %2.2f %%  \n'], 100*sum(sum(1-re))/(size(re,1)*size(re,2)));
    clear test_asc test_pos temp_pos_proc
    clear temp 
end
test_name = (char(datetime('now', 'Format', 'yyyy-MM-dd_HH-mm')));
fprintf(1,'AVG MSE = %6.6f \n',sum(err)/sample_count);
fname = ['test_processed_' NN.atoms test_name];
%% Сохранение данных для аудиокодера('test_processed','test_processed');
save(fname ,'test_processed');
% save('test_processed_sort','test_processed_sort');
% scodes(isnan(scodes)) = 0
% figure;
% Y = tsne(scodes');
% gscatter(Y(:,1),Y(:,2),labels);
end



