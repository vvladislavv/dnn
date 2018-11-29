close all;
clear all;
%% Загрузка аудио-файлов
[orig.p1, fs] = audioread('Audio_newest\Original\es01_m44.wav');
[orig.p2, fs] = audioread('Audio_newest\Original\es02_m44.wav');
[orig.p3, fs] = audioread('Audio_newest\Original\es03_m44.wav');
[orig.p4, fs] = audioread('Audio_newest\Original\sc01_m44.wav');
[orig.p5, fs] = audioread('Audio_newest\Original\sc03_m44.wav');
[orig.p6, fs] = audioread('Audio_newest\Original\si01_m44.wav');
[orig.p7, fs] = audioread('Audio_newest\Original\si02_m44.wav');
[orig.p8, fs] = audioread('Audio_newest\Original\sm02_m44.wav');

[qnt200.p1, fs] = audioread('Audio_newest\Quantization\200atoms\es01_m44_200at_rec.wav');
[qnt200.p2, fs] = audioread('Audio_newest\Quantization\200atoms\es02_m44_200at_rec.wav');
[qnt200.p3, fs] = audioread('Audio_newest\Quantization\200atoms\es03_m44_200at_rec.wav');
[qnt200.p4, fs] = audioread('Audio_newest\Quantization\200atoms\sc01_m44_200at_rec.wav');
[qnt200.p5, fs] = audioread('Audio_newest\Quantization\200atoms\sc03_m44_200at_rec.wav');
[qnt200.p6, fs] = audioread('Audio_newest\Quantization\200atoms\si01_m44_200at_rec.wav');
[qnt200.p7, fs] = audioread('Audio_newest\Quantization\200atoms\si02_m44_200at_rec.wav');
[qnt200.p8, fs] = audioread('Audio_newest\Quantization\200atoms\sm02_m44_200at_rec.wav');

[qnt300.p1, fs] = audioread('Audio_newest\Quantization\300atoms\es01_m44_300at_rec.wav');
[qnt300.p2, fs] = audioread('Audio_newest\Quantization\300atoms\es02_m44_300at_rec.wav');
[qnt300.p3, fs] = audioread('Audio_newest\Quantization\300atoms\es03_m44_300at_rec.wav');
[qnt300.p4, fs] = audioread('Audio_newest\Quantization\300atoms\sc01_m44_300at_rec.wav');
[qnt300.p5, fs] = audioread('Audio_newest\Quantization\300atoms\sc03_m44_300at_rec.wav');
[qnt300.p6, fs] = audioread('Audio_newest\Quantization\300atoms\si01_m44_300at_rec.wav');
[qnt300.p7, fs] = audioread('Audio_newest\Quantization\300atoms\si02_m44_300at_rec.wav');
[qnt300.p8, fs] = audioread('Audio_newest\Quantization\300atoms\sm02_m44_300at_rec.wav');

[qnt400.p1, fs] = audioread('Audio_newest\Quantization\400atoms\es01_m44_400at_rec.wav');
[qnt400.p2, fs] = audioread('Audio_newest\Quantization\400atoms\es02_m44_400at_rec.wav');
[qnt400.p3, fs] = audioread('Audio_newest\Quantization\400atoms\es03_m44_400at_rec.wav');
[qnt400.p4, fs] = audioread('Audio_newest\Quantization\400atoms\sc01_m44_400at_rec.wav');
[qnt400.p5, fs] = audioread('Audio_newest\Quantization\400atoms\sc03_m44_400at_rec.wav');
[qnt400.p6, fs] = audioread('Audio_newest\Quantization\400atoms\si01_m44_400at_rec.wav');
[qnt400.p7, fs] = audioread('Audio_newest\Quantization\400atoms\si02_m44_400at_rec.wav');
[qnt400.p8, fs] = audioread('Audio_newest\Quantization\400atoms\sm02_m44_400at_rec.wav');

[qnt500.p1, fs] = audioread('Audio_newest\Quantization\500atoms\es01_m44_500at_rec.wav');
[qnt500.p2, fs] = audioread('Audio_newest\Quantization\500atoms\es02_m44_500at_rec.wav');
[qnt500.p3, fs] = audioread('Audio_newest\Quantization\500atoms\es03_m44_500at_rec.wav');
[qnt500.p4, fs] = audioread('Audio_newest\Quantization\500atoms\sc01_m44_500at_rec.wav');
[qnt500.p5, fs] = audioread('Audio_newest\Quantization\500atoms\sc03_m44_500at_rec.wav');
[qnt500.p6, fs] = audioread('Audio_newest\Quantization\500atoms\si01_m44_500at_rec.wav');
[qnt500.p7, fs] = audioread('Audio_newest\Quantization\500atoms\si02_m44_500at_rec.wav');
[qnt500.p8, fs] = audioread('Audio_newest\Quantization\500atoms\sm02_m44_500at_rec.wav');

plakat = false;
zapiska = true;
% %% Построение графиков во временной области
% for sampleN = 1:length(fieldnames(orig))
% sample_name = ['p' sprintf('%d', sampleN)];
% 
% figure('name',[sample_name ' time plot']);
% subplot(211);
% plot((1:length(orig.(sample_name)))./fs,orig.(sample_name));
% set(gca,'xtick',[])
% title('Исходный сигнал')
% subplot(212);
% plot((1:length(orig.(sample_name)))./fs,qnt200.(sample_name));
% title('Реконструированный с нейросетевым квантованием')
% xlabel('Время, сек.');
% set(0,'DefaultAxesFontSize',18,'DefaultAxesFontName','Lato');
% set(0,'DefaultTextFontSize',18,'DefaultTextFontName','Lato');  
% 
% end; 


%% Построение спектрограмм для плаката
if plakat == true
for sampleN = 1:length(fieldnames(orig))
sample_name = ['p' sprintf('%d', sampleN)];

fig = figure('name',[sample_name ' time plot_orig']);
set(gca,'FontSize',22)
% set(0,'DefaultAxesFontSize',14,'DefaultAxesFontName','Times New Roman');
% set(0,'DefaultTextFontSize',14,'DefaultTextFontName','Times New Roman'); 
plot((1:length(orig.(sample_name)))./44100,orig.(sample_name));
% set(gca,'xtick',[])
xlim([0 10])
ylabel('Амплитуда');
xlabel('Время, с');
set(gca,'FontSize',22)

fig = figure('name',[sample_name ' spectrogram plot_orig']);
set(gca,'FontSize',16)
% set(0,'DefaultAxesFontSize',14,'DefaultAxesFontName','Times New Roman');
% set(0,'DefaultTextFontSize',14,'DefaultTextFontName','Times New Roman'); 
spectrogram(orig.(sample_name),4096,4064,4096,fs,'yaxis');
% set(gca,'xtick',[])
ylabel('Частота, кГц');
% ylim([0 4])
xlabel('Время, с');
colorbar off;
title('Исходный сигнал')
colormap jet;
print(fig,[sample_name 'spectrogram_plot_orig_cut'],'-dmeta')

fig = figure('name',[sample_name 'spectrogram_plot_200']);
set(gca,'FontSize',16)
% set(0,'DefaultAxesFontSize',14,'DefaultAxesFontName','Times New Roman');
% set(0,'DefaultTextFontSize',14,'DefaultTextFontName','Times New Roman'); 
spectrogram(qnt200.(sample_name),4096,4064,4096,fs,'yaxis');
ylabel('Частота, кГц');
% ylim([0 4])
xlabel('Время, с');
colorbar off;
title('Реконструированный (200 атомов)')
colormap jet;
print(fig,[sample_name 'spectrogram_plot_200_cut'],'-dmeta')

fig = figure('name',[sample_name 'spectrogram_plot_300']);
set(gca,'FontSize',16)
% set(0,'DefaultAxesFontSize',14,'DefaultAxesFontName','Times New Roman');
% set(0,'DefaultTextFontSize',14,'DefaultTextFontName','Times New Roman'); 
spectrogram(qnt300.(sample_name),4096,4064,4096,fs,'yaxis');
ylabel('Частота, кГц');
% ylim([0 4])
xlabel('Время, с');
colorbar off;
title('Реконструированный (300 атомов)')
colormap jet;
print(fig,[sample_name 'spectrogram_plot_300_cut'],'-dmeta')

fig = figure('name',[sample_name 'spectrogram_plot_400']);
set(gca,'FontSize',16)
% set(0,'DefaultAxesFontSize',14,'DefaultAxesFontName','Times New Roman');
% set(0,'DefaultTextFontSize',14,'DefaultTextFontName','Times New Roman'); 
spectrogram(qnt400.(sample_name),4096,4064,4096,fs,'yaxis');
ylabel('Частота, кГц');
% ylim([0 4])
xlabel('Время, с');
colorbar off;
title('Реконструированный (400 атомов)')
colormap jet;
print(fig,[sample_name 'spectrogram_plot_400_cut'],'-dmeta')

fig = figure('name',[sample_name 'spectrogram_plot_500']);
set(gca,'FontSize',16)
% set(0,'DefaultAxesFontSize',14,'DefaultAxesFontName','Times New Roman');
% set(0,'DefaultTextFontSize',14,'DefaultTextFontName','Times New Roman'); 
spectrogram(qnt500.(sample_name),4096,4064,4096,fs,'yaxis');
ylabel('Частота, кГц');
% ylim([0 4])
xlabel('Время, с');
colorbar off;
title('Реконструированный (500 атомов)')
colormap jet;
print(fig,[sample_name 'spectrogram_plot_500_cut'],'-dmeta')
end;
end

if zapiska == true
%% Построение спектрограмм для записки
for sampleN = 1:length(fieldnames(orig))
sample_name = ['p' sprintf('%d', sampleN)];

% figure('name',[sample_name ' spectrogram plot']);
% set(0,'DefaultAxesFontSize',14,'DefaultAxesFontName','Times New Roman');
% set(0,'DefaultTextFontSize',14,'DefaultTextFontName','Times New Roman'); 
% spectrogram(orig.(sample_name),4096,4064,4096,fs,'yaxis');
% % set(gca,'xtick',[])
% ylabel('Частота, кГц');
% ylim([0 4])
% xlabel('Время, с');
% colorbar off;
% title('Исходный сигнал')
% colormap jet;

fig = figure('name',[sample_name 'spectrogram_plot']);

set(0,'DefaultAxesFontSize',16,'DefaultAxesFontName','Times New Roman');
set(0,'DefaultTextFontSize',16,'DefaultTextFontName','Times New Roman'); 

subplot(151);
spectrogram(orig.(sample_name),4096,0,4096,fs,'yaxis');
set(gca,'YScale','log')
ylabel('Частота, кГц');
% ylim([0 4])
xlabel('');
colorbar off;
title('Исходный сигнал')
colormap jet;
set(gca,'FontSize',16)



subplot(152);
spectrogram(qnt200.(sample_name),4096,0,4096,fs,'yaxis');
set(gca,'YScale','log')
ylabel('');
set(gca,'ytick',[])
% ylim([0 4])
xlabel('');
colorbar off;
title({'Реконструированный';'(200 атомов)'})
colormap jet;
set(gca,'FontSize',16)

subplot(153);
spectrogram(qnt300.(sample_name),4096,0,4096,fs,'yaxis');
set(gca,'YScale','log')
ylabel('');
set(gca,'ytick',[])
% ylim([0 4])
xlabel('Время, с');
colorbar off;
title({'Реконструированный';'(300 атомов)'})
colormap jet;
set(gca,'FontSize',16)


subplot(154);
spectrogram(qnt400.(sample_name),4096,0,4096,fs,'yaxis');
set(gca,'YScale','log')
ylabel('');
set(gca,'ytick',[])
% ylim([0 4])
xlabel('');
colorbar off;
title({'Реконструированный';'(400 атомов)'})
colormap jet;
set(gca,'FontSize',16)



subplot(155);
spectrogram(qnt500.(sample_name),4096,0,4096,fs,'yaxis');
set(gca,'YScale','log')
ylabel('');
set(gca,'ytick',[])
% ylim([0 4])
xlabel('');
colorbar off;
title({'Реконструированный';'(500 атомов)'})
colormap jet;
set(gca,'FontSize',16)
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 16 8];
print(fig,[sample_name 'spectrogram_plot'],'-dpng')
1;
end;
end

% %% Построение спектрограмм для записки
% for sampleN = 1:length(fieldnames(orig))
% sample_name = ['p' sprintf('%d', sampleN)];
% 
% figure('name',[sample_name ' spectrogram plot']);
% subplot(211);
% spectrogram(orig.(sample_name),2048,[],[],fs,'yaxis');
% set(gca,'xtick',[])
% ylabel('');
% xlabel('');
% colorbar off;
% title('а)')
% subplot(212);
% spectrogram(qnt200.(sample_name),2048,[],[],fs,'yaxis');
% ylabel('');
% xlabel('Время, сек.');
% colorbar off;
% title('в)')
% colormap jet;
% end;



