close all
text = {'es01',	'es02',	'es03',	'sc01',	'sc03',	'si01',	'si02'};
unsorted = [0.0028	0.0139	0.0185	0.0064	0.016	0.0017	0.0015];
% sorted = [0.00000717	0.00002939	0.00003511	0.00001738	0.00003776	0.00000467	0.00000324];
sorted = [4.821196e-06	1.914732e-05	2.193100e-05	1.294289e-05 	2.718382e-05	3.036311e-06	2.553168e-06 ];
sorted_hash = [2.57e-5 1.22e-4 1.69e-4 5.27e-5 1.32e-4 1.76e-5 1.45e-5];
sorted_vq = [5.860356e-05 2.385873e-04 3.554833e-04 1.077335e-04 2.449122e-04 3.837485e-05  2.973366e-05];
sorted_msvq_32_20 = [5.199730e-06 1.939204e-05 2.551994e-05 1.506083e-05 2.824331e-05 3.312502e-06  2.189940e-06];
sorted_msvq_16_25 = [5.580153e-06 2.187221e-05  2.911928e-05 1.797689e-05 2.999940e-05  3.822895e-06   2.416050e-06];

figure();
semilogy(1:7, sorted, 'b-s', 'MarkerFaceColor', 'b', 'MarkerSize', 7, 'LineWidth',2);
hold on
semilogy(1:7, unsorted, 'r--o', 'MarkerFaceColor', 'r', 'MarkerSize', 7, 'LineWidth',2);
grid on;
xlabel('Образец');
ylabel('СКО');
legend('Сортировка','Без сортировки');
% xticks([1:7])
% xticklabels(text)
ax1 = gca;
ax1.XTick = 1:7;
ax1.XTickLabel = text;
% ax1 = gca; ax1_pos = ax1.Position; % position of first axes
% ax2 = axes('Position',ax1_pos,...
%     'XAxisLocation','bottom',...
%     'YAxisLocation','right',...
%     'YTick', [],...
%     'XTick', 0:1/7:1,...
%     'XTickLabel', text,...
%     'Color','none');

figure();
semilogy(1:7, sorted, 'b-s', 'MarkerFaceColor', 'b', 'MarkerSize', 7, 'LineWidth',2);
hold on
semilogy(1:7, sorted_hash, 'r--o',  'MarkerFaceColor', 'r', 'MarkerSize', 7, 'LineWidth',2);
grid on;
xlabel('Образец');
ylabel('СКО');
legend('Ступенчатая функция','Введение ограничений');
% xticks([1:7])
% xticklabels(text)
ax1 = gca;
ax1.XTick = 1:7;
ax1.XTickLabel = text;


figure();
semilogy(1:7, sorted, 'b-s', 'MarkerFaceColor', 'b', 'MarkerSize', 7, 'LineWidth',2);
% hold on
% semilogy(1:7, sorted_vq, 'r-s', 'MarkerFaceColor', 'r', 'MarkerSize', 7);
hold on
semilogy(1:7, sorted_msvq_32_20, 'r--o', 'MarkerFaceColor', 'r', 'MarkerSize', 7, 'LineWidth',2);
% hold on
% semilogy(1:7, sorted_msvq_16_25, 'k-s', 'MarkerFaceColor', 'k', 'MarkerSize', 7);
grid on;
xlabel('Образец');
ylabel('СКО');
legend('NNQ','MSVQ(32,20)');%,'MSVQ(32,20)');
% xticks([1:7])
% xticklabels(text)
ax1 = gca;
ax1.XTick = 1:7;
ax1.XTickLabel = text;

load test_asc
load test_pos
load temp_pos_proc
figure();



