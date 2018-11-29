text = {'es01',	'es02',	'es03',	'sc01',	'sc03',	'si01',	'si02'};
unsorted = [0.0028	0.0139	0.0185	0.0064	0.016	0.0017	0.0015];
sorted = [0.00000717	0.00002939	0.00003511	0.00001738	0.00003776	0.00000467	0.00000324];
sorted_hash = [2.57e-5 1.22e-4 1.69e-4 5.27e-5 1.32e-4 1.76e-5 1.45e-5];
sorted_vq = [5.860356e-05 2.385873e-04 3.554833e-04 1.077335e-04 2.449122e-04 3.837485e-05  2.973366e-05];

figure();
semilogy(1:7, sorted, 'b-s', 'MarkerFaceColor', 'b', 'MarkerSize', 7);
hold on
semilogy(1:7, unsorted, 'r-s', 'MarkerFaceColor', 'r', 'MarkerSize', 7);
grid on;
xlabel('Sample');
ylabel('MSE');
legend('Sorted','Unsorted');
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
semilogy(1:7, sorted, 'b-s', 'MarkerFaceColor', 'b', 'MarkerSize', 7);
hold on
semilogy(1:7, sorted_hash, 'r-s', 'MarkerFaceColor', 'r', 'MarkerSize', 7);
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
semilogy(1:7, sorted, 'b-s', 'MarkerFaceColor', 'b', 'MarkerSize', 7);
hold on
semilogy(1:7, sorted_vq, 'r-s', 'MarkerFaceColor', 'r', 'MarkerSize', 7);
grid on;
xlabel('Образец');
ylabel('СКО');
legend('NNQ','VQ');
% xticks([1:7])
% xticklabels(text)
ax1 = gca;
ax1.XTick = 1:7;
ax1.XTickLabel = text;


