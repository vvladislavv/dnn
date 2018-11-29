close all;
clear all;
%% Загрузка аудио-файлов
[orig.p1, fs] = audioread('Training_data\Audio\Original\es01_m44.wav');
[orig.p2, fs] = audioread('Training_data\Audio\Original\es02_m44.wav');
[orig.p3, fs] = audioread('Training_data\Audio\Original\es03_m44.wav');
[orig.p4, fs] = audioread('Training_data\Audio\Original\sc01_m44.wav');
[orig.p5, fs] = audioread('Training_data\Audio\Original\sc03_m44.wav');
[orig.p6, fs] = audioread('Training_data\Audio\Original\si01_m44.wav');
[orig.p7, fs] = audioread('Training_data\Audio\Original\si02_m44.wav');

[appr.p1, fs] = audioread('Training_data\Audio\Approximation\es01_m44_200at_rec.wav');
[appr.p2, fs] = audioread('Training_data\Audio\Approximation\es02_m44_200at_rec.wav');
[appr.p3, fs] = audioread('Training_data\Audio\Approximation\es03_m44_200at_rec.wav');
[appr.p4, fs] = audioread('Training_data\Audio\Approximation\sc01_m44_200at_rec.wav');
[appr.p5, fs] = audioread('Training_data\Audio\Approximation\sc03_m44_200at_rec.wav');
[appr.p6, fs] = audioread('Training_data\Audio\Approximation\si01_m44_200at_rec.wav');
[appr.p7, fs] = audioread('Training_data\Audio\Approximation\si02_m44_200at_rec.wav');

[qnt.p1, fs] = audioread('Training_data\Audio\Quantization\es01_m44_200at_rec.wav');
[qnt.p2, fs] = audioread('Training_data\Audio\Quantization\es02_m44_200at_rec.wav');
[qnt.p3, fs] = audioread('Training_data\Audio\Quantization\es03_m44_200at_rec.wav');
[qnt.p4, fs] = audioread('Training_data\Audio\Quantization\sc01_m44_200at_rec.wav');
[qnt.p5, fs] = audioread('Training_data\Audio\Quantization\sc03_m44_200at_rec.wav');
[qnt.p6, fs] = audioread('Training_data\Audio\Quantization\si01_m44_200at_rec.wav');
[qnt.p7, fs] = audioread('Training_data\Audio\Quantization\si02_m44_200at_rec.wav');

[qnt_new.p1, fs] = audioread('Training_data\Audio_new\Quantization\es01_m44_200at_rec.wav');
[qnt_new.p2, fs] = audioread('Training_data\Audio_new\Quantization\es02_m44_200at_rec.wav');
[qnt_new.p3, fs] = audioread('Training_data\Audio_new\Quantization\es03_m44_200at_rec.wav');
[qnt_new.p4, fs] = audioread('Training_data\Audio_new\Quantization\sc01_m44_200at_rec.wav');
[qnt_new.p5, fs] = audioread('Training_data\Audio_new\Quantization\sc03_m44_200at_rec.wav');
[qnt_new.p6, fs] = audioread('Training_data\Audio_new\Quantization\si01_m44_200at_rec.wav');
[qnt_new.p7, fs] = audioread('Training_data\Audio_new\Quantization\si02_m44_200at_rec.wav');

vorbis15.p1 = audioread('Training_data\Audio\Vorbis15\es01_m44_ogg.wav');
vorbis15.p2 = audioread('Training_data\Audio\Vorbis15\es02_m44_ogg.wav');
vorbis15.p3 = audioread('Training_data\Audio\Vorbis15\es03_m44_ogg.wav');
vorbis15.p4 = audioread('Training_data\Audio\Vorbis15\sc01_m44_ogg.wav');
vorbis15.p5 = audioread('Training_data\Audio\Vorbis15\sc03_m44_ogg.wav');
vorbis15.p6 = audioread('Training_data\Audio\Vorbis15\si01_m44_ogg.wav');
vorbis15.p7 = audioread('Training_data\Audio\Vorbis15\si02_m44_ogg.wav');

opus15.p1 = audioread('Training_data\Audio\Opus15\es01_m44_opus.wav');
opus15.p2 = audioread('Training_data\Audio\Opus15\es02_m44_opus.wav');
opus15.p3 = audioread('Training_data\Audio\Opus15\es03_m44_opus.wav');
opus15.p4 = audioread('Training_data\Audio\Opus15\sc01_m44_opus.wav');
opus15.p5 = audioread('Training_data\Audio\Opus15\sc03_m44_opus.wav');
opus15.p6 = audioread('Training_data\Audio\Opus15\si01_m44_opus.wav');
opus15.p7 = audioread('Training_data\Audio\opus15\si02_m44_opus.wav');

%% Загрузка тестовых данных
td.p1 = load('Training_data\data\es01_m44_200atoms_orig');
td.p2 = load('Training_data\data\es02_m44_200atoms_orig');
td.p3 = load('Training_data\data\es03_m44_200atoms_orig');
td.p4 = load('Training_data\data\sc01_m44_200atoms_orig');
td.p5 = load('Training_data\data\sc03_m44_200atoms_orig');
td.p6 = load('Training_data\data\si01_m44_200atoms_orig');
td.p7 = load('Training_data\data\si02_m44_200atoms_orig');
% td.p8 = load('Training_data\data\cut070_015_200atoms_orig');

% labels = [];
% scodes = [];
% %% Обработка и запаковка данных для аудиокодера
% for smpls_count = 1:length(td)
%     num = 0;
% sample_count = length(fieldnames(td));
%    for sampleN = 1:sample_count
%     sample_name = ['p' sprintf('%d', sampleN)];
%     name = char(fieldnames(td.(sample_name)));
%     frames_count = length(fieldnames(td.(sample_name).(name)));
%     for frameN = 1:frames_count
%         num = num + 1;
%         frame_name = ['frame' sprintf('%d', frameN)];
%         frame_num = ['frame' sprintf('%d', num)];
%         
% 
% temp.(frame_name).weight = sort_atoms_all(td.(sample_name).(name).(frame_name).weight);
% % tmp.(name)(:,num) =  temp.(frame_name).weight(:, 1);
% ttest(:,frameN) = temp.(frame_name).weight(:, 1);
% % test_processed.(name).(frame_num).weight = temp.(frame_name).weight;
%     end
%     ttest = ttest;
% test_processed.(name) = temp;
% tmp.(name) = ttest;
% % [ttest mu sigma] = zscore(ttest);
% [ttest mu] = mapstd(ttest');
% test_std.(name) = ttest';
% sn = ones(size(ttest));
% sn(ttest<0) = -1;
% ttest = abs(ttest)';
% 
% 
% 
% 
% test_normalized.(name) = ttest;
% 
% [ processed code] = ffpropagation_6layers_b(ttest);
% 
% processed = processed.*sn;
% proc.(name) = mapstd('reverse', processed,mu)';
% codes.(name) = code;
% labels = [labels sampleN*ones(1,length(codes.(name)))]; 
% scodes = [scodes code(:,1:end-1)'];
% codes.(name) = code';
% % figure;
% % set(0,'DefaultAxesFontSize',18,'DefaultAxesFontName','Lato');
% % set(0,'DefaultTextFontSize',18,'DefaultTextFontName','Lato'); 
% % imshow(tmp.(name)(:,7:505),'colormap',jet)
% % % set(gca,'YDir','normal')
% % axis on
% % axis xy
% % xlabel('Вектор');
% % ylabel('Коэффициент');
% 
% 
% % figure; 
% % set(0,'DefaultAxesFontSize',16,'DefaultAxesFontName','Times New Roman');
% % set(0,'DefaultTextFontSize',16,'DefaultTextFontName','Times New Roman'); 
% % plot(tmp.(name))
% % hold on
% % plot(proc.(name))
% % xlabel('Коэффициент');
% % ylabel('Амплитуда');
% % legend('Оригинал','Реконструкция')
% % % 
% % figure;
% % imshow(codes.(name))
% % 
% % axis on
% % axis xy
% % xlabel('Вектор');
% % ylabel('Коэффициент');
% % set(0,'DefaultAxesFontSize',16,'DefaultAxesFontName','Times New Roman');
% % set(0,'DefaultTextFontSize',16,'DefaultTextFontName','Times New Roman'); 
% % figure;
% % imshow(codes.(name))
% % axis on
% % axis xy
% % xlabel('Вектор');
% % ylabel('Бит');
% 
% clear ttest
% clear temp
% 
% % Pack data
%    for frameN = 1:frames_count
%         num = num + 1;
%         frame_name = ['frame' sprintf('%d', frameN)];
%         frame_num = ['frame' sprintf('%d', num)];
%         
% test_processed.(name).(frame_name).weight(:,1) = proc.(name)(:,frameN);
%     end
%    end
%    
%    
% end
% 
% 
% 
% 
% 
% %% Сохранение данных для аудиокодераave('test_processed','test_processed');
% save('test_normalized','test_normalized');
% save('test_processed','test_processed');
% 
% % figure;
% % Y = tsne(scodes');
% % gscatter(Y(:,1),Y(:,2),labels);
% 
% %% Построение графиков во временной области
% for sampleN = 1:length(fieldnames(orig))
% sample_name = ['p' sprintf('%d', sampleN)];
% 
% figure('name',[sample_name ' time plot']);
% subplot(311);
% plot((1:length(orig.(sample_name)))./fs,orig.(sample_name));
% set(gca,'xtick',[])
% title('Исходный сигнал')
% subplot(312);
% plot((1:length(orig.(sample_name)))./fs,appr.(sample_name));
% set(gca,'xtick',[])
% title('Реконструированный без квантования')
% ylabel('Амплитуда');
% subplot(313);
% plot((1:length(orig.(sample_name)))./fs,qnt.(sample_name));
% title('Реконструированный с нейросетевым квантованием')
% xlabel('Время, сек.');
% set(0,'DefaultAxesFontSize',18,'DefaultAxesFontName','Lato');
% set(0,'DefaultTextFontSize',18,'DefaultTextFontName','Lato');  
% 
% end;

%% PEAQ

FileIn.p1 = char('Training_data\Audio\Original\es01_m44.wav');
FileIn.p2 = char('Training_data\Audio\Original\es02_m44.wav');
FileIn.p3 = char('Training_data\Audio\Original\es03_m44.wav');
FileIn.p4 = char('Training_data\Audio\Original\sc01_m44.wav');
FileIn.p5 = char('Training_data\Audio\Original\sc03_m44.wav');
FileIn.p6 = char('Training_data\Audio\Original\si01_m44.wav');
FileIn.p7 = char('Training_data\Audio\Original\si02_m44.wav');

FileQnt.p1 = char('Training_data\Audio\Quantization\es01_m44_200at_rec.wav');
FileQnt.p2 = char('Training_data\Audio\Quantization\es02_m44_200at_rec.wav');
FileQnt.p3 = char('Training_data\Audio\Quantization\es03_m44_200at_rec.wav');
FileQnt.p4 = char('Training_data\Audio\Quantization\sc01_m44_200at_rec.wav');
FileQnt.p5 = char('Training_data\Audio\Quantization\sc03_m44_200at_rec.wav');
FileQnt.p6 = char('Training_data\Audio\Quantization\si01_m44_200at_rec.wav');
FileQnt.p7 = char('Training_data\Audio\Quantization\si02_m44_200at_rec.wav');

FileVorbis15.p1 = char('Training_data\Audio\Vorbis15\es01_m44.ogg');
FileVorbis15.p2 = char('Training_data\Audio\Vorbis15\es02_m44.ogg');
FileVorbis15.p3 = char('Training_data\Audio\Vorbis15\es03_m44.ogg');
FileVorbis15.p4 = char('Training_data\Audio\Vorbis15\sc01_m44.ogg');
FileVorbis15.p5 = char('Training_data\Audio\Vorbis15\sc03_m44.ogg');
FileVorbis15.p6 = char('Training_data\Audio\Vorbis15\si01_m44.ogg');
FileVorbis15.p7 = char('Training_data\Audio\Vorbis15\si02_m44.ogg');

% for sampleN = 1:length(fieldnames(orig))
% sample_name = ['p' sprintf('%d', sampleN)];
% 
% In = FileIn.(sample_name);
% Out1 = FileQnt.(sample_name);
% Out2 = FileVorbis15.(sample_name);
% ODG_qnt(sampleN) = PQevalAudio_fn(In, Out1);
% ODG_vorbis(sampleN) = PQevalAudio_fn(In, Out2);
% % fprintf('PEAQ Objective Difference Grade Vorbis 15 kb/s: %8.4f\n', ODG_);
% % fprintf('PEAQ Objective Difference Grade DNN 15 kb/s: %8.4f\n', ODG2);
% end;


% figure('name',[sample_name ' spectrogram plot']);
% subplot(131);
% spectrogram(qnt.p5,8192,[],[],fs,'yaxis');
% xlabel('Время, сек.');
% ylabel('Частота, кГц');
% 
% title('MP NNQ')
% colorbar off;
% subplot(132);
% spectrogram(opus15.p5,8192,[],[],fs,'yaxis');
% title('Opus')
% colorbar off;
% % set(gca,'xtick',[],'ytick',[])
% set(gca,'ytick',[])
% ylabel('');
% xlabel('Время, сек.');
% subplot(133);
% spectrogram(vorbis15.p5,8192,[],[],fs,'yaxis');
% title('Vorbis')
% colormap jet;
% colorbar off;
% ylabel('');
% xlabel('Время, сек.');
% set(gca,'ytick',[])
% set(0,'DefaultAxesFontSize',16,'DefaultAxesFontName','Times New Roman');
% set(0,'DefaultTextFontSize',16,'DefaultTextFontName','Times New Roman'); 
% 
% 
% 
% figure('name',[sample_name ' time plot']);
% set(0,'DefaultAxesFontSize',16,'DefaultAxesFontName','Lato');
% set(0,'DefaultTextFontSize',16,'DefaultTextFontName','Lato');  
% subplot(311);
% plot((1:length(qnt.p5))./fs,qnt.p5);
% set(gca,'xtick',[])
% title('MP NNQ')
% subplot(312);
% plot((1:length(opus15.p5))./fs,opus15.p5);
% set(gca,'xtick',[])
% title('Opus')
% ylabel('Амплитуда');
% subplot(313);
% plot((1:length(vorbis15.p5))./fs,vorbis15.p5);
% title('Vorbis')
% xlabel('Время, сек.');
% set(0,'DefaultAxesFontSize',18,'DefaultAxesFontName','Lato');
% set(0,'DefaultTextFontSize',18,'DefaultTextFontName','Lato');  

    
    
%% Построение спектрограмм для плаката
for sampleN = 1:length(fieldnames(orig))
sample_name = ['p' sprintf('%d', sampleN)];

figure('name',[sample_name ' spectrogram plot']);
set(0,'DefaultAxesFontSize',14,'DefaultAxesFontName','Times New Roman');
set(0,'DefaultTextFontSize',14,'DefaultTextFontName','Times New Roman'); 
% subplot(311);
% spectrogram(orig.(sample_name),8192,[],[],fs,'yaxis');
% set(gca,'xtick',[])
% ylabel('');
% xlabel('');
% colorbar off;
% title('Исходный сигнал')
% subplot(312);
% spectrogram(appr.(sample_name),8192,[],[],fs,'yaxis');
% colorbar off;
% set(gca,'xtick',[])
% xlabel('');
% ylabel('Частота, кГц');
% title('Реконструированный без квантования')
% subplot(313);
spectrogram(qnt.(sample_name),(8192),8000,8192,fs,'yaxis');
% ylabel('');
ylabel('Частота, кГц');
xlabel('Время, сек.');
colorbar off;
% title('Реконструированный с нейросетевым квантованием')
colormap jet;

% snr_nn.(sample_name) = snr(orig.(sample_name), (orig.(sample_name)-qnt.(sample_name)));
% snr_vorbis.(sample_name) = snr(orig.(sample_name)(1:length(vorbis15.(sample_name))), (vorbis15.(sample_name) - orig.(sample_name)(1:length(vorbis15.(sample_name)))));
% snr_opus.(sample_name) = snr(orig.(sample_name), opus15.(sample_name)(1:length(orig.(sample_name))) - orig.(sample_name));
end;

%% Построение спектрограмм для плаката
for sampleN = 1:length(fieldnames(orig))
sample_name = ['p' sprintf('%d', sampleN)];

figure('name',[sample_name ' spectrogram plot']);
set(0,'DefaultAxesFontSize',14,'DefaultAxesFontName','Times New Roman');
set(0,'DefaultTextFontSize',14,'DefaultTextFontName','Times New Roman'); 
% subplot(311);
% spectrogram(orig.(sample_name),8192,[],[],fs,'yaxis');
% set(gca,'xtick',[])
% ylabel('');
% xlabel('');
% colorbar off;
% title('Исходный сигнал')
% subplot(312);
% spectrogram(appr.(sample_name),8192,[],[],fs,'yaxis');
% colorbar off;
% set(gca,'xtick',[])
% xlabel('');
% ylabel('Частота, кГц');
% title('Реконструированный без квантования')
% subplot(313);
spectrogram(qnt_new.(sample_name),(8192),8000,8192,fs,'yaxis');
% ylabel('');
ylabel('Частота, кГц');
xlabel('Время, сек.');
colorbar off;
% title('Реконструированный с нейросетевым квантованием')
colormap jet;

% snr_nn.(sample_name) = snr(orig.(sample_name), (orig.(sample_name)-qnt.(sample_name)));
% snr_vorbis.(sample_name) = snr(orig.(sample_name)(1:length(vorbis15.(sample_name))), (vorbis15.(sample_name) - orig.(sample_name)(1:length(vorbis15.(sample_name)))));
% snr_opus.(sample_name) = snr(orig.(sample_name), opus15.(sample_name)(1:length(orig.(sample_name))) - orig.(sample_name));
end;

%% Построение спектрограмм для плаката
for sampleN = 1:length(fieldnames(orig))
sample_name = ['p' sprintf('%d', sampleN)];

figure('name',[sample_name ' spectrogram plot']);
set(0,'DefaultAxesFontSize',14,'DefaultAxesFontName','Times New Roman');
set(0,'DefaultTextFontSize',14,'DefaultTextFontName','Times New Roman'); 
% subplot(311);
% spectrogram(orig.(sample_name),8192,[],[],fs,'yaxis');
% set(gca,'xtick',[])
% ylabel('');
% xlabel('');
% colorbar off;
% title('Исходный сигнал')
% subplot(312);
% spectrogram(appr.(sample_name),8192,[],[],fs,'yaxis');
% colorbar off;
% set(gca,'xtick',[])
% xlabel('');
% ylabel('Частота, кГц');
% title('Реконструированный без квантования')
% subplot(313);
spectrogram(orig.(sample_name),(8192),8000,8192,fs,'yaxis');
% ylabel('');
ylabel('Частота, кГц');
xlabel('Время, сек.');
colorbar off;
% title('Реконструированный с нейросетевым квантованием')
colormap jet;
figure('name',[sample_name ' appr time plot']);
plot((1:length(appr.(sample_name)))./fs,appr.(sample_name));
ylabel('Амплитуда');
xlabel('Время, сек.');
figure('name',[sample_name ' qnt time plot']);
plot((1:length(qnt_new.(sample_name)))./fs,qnt_new.(sample_name));
ylabel('Амплитуда');
xlabel('Время, сек.');

% snr_nn.(sample_name) = snr(orig.(sample_name), (orig.(sample_name)-qnt.(sample_name)));
% snr_vorbis.(sample_name) = snr(orig.(sample_name)(1:length(vorbis15.(sample_name))), (vorbis15.(sample_name) - orig.(sample_name)(1:length(vorbis15.(sample_name)))));
% snr_opus.(sample_name) = snr(orig.(sample_name), opus15.(sample_name)(1:length(orig.(sample_name))) - orig.(sample_name));
end;

%% Построение спектрограмм для записки
for sampleN = 1:length(fieldnames(orig))
sample_name = ['p' sprintf('%d', sampleN)];

figure('name',[sample_name ' spectrogram plot']);
subplot(311);
spectrogram(orig.(sample_name),2048,[],[],fs,'yaxis');
set(gca,'xtick',[])
ylabel('');
xlabel('');
colorbar off;
title('а)')
subplot(312);
spectrogram(appr.(sample_name),2048,[],[],fs,'yaxis');
colorbar off;
set(gca,'xtick',[])
xlabel('');
ylabel('Частота, кГц');
title('б)')
subplot(313);
spectrogram(qnt.(sample_name),2048,[],[],fs,'yaxis');
ylabel('');
xlabel('Время, сек.');
colorbar off;
title('в)')
colormap jet;
end;



