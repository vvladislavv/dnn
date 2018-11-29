close all
load err_hist_rms;
load err_hist_sgd;
load err_hist_momentum;
load err_hist_adam;
load err_hist_adam_b50;
load err_hist_adam_b100;
load err_hist_adam_b200;
load err_hist_adam_b500;
load err_hist_ae1;
load err_hist_ae2;
load err_hist_ae3;
load err_hist_fine;
load err_hist_nopr;

figure; 
semilogy(err_hist_sgd, '-','LineWidth',2); hold on;
semilogy(err_hist_momentum,':','LineWidth',2); hold on;
semilogy(err_hist_rms,'--','LineWidth',2); hold on;
semilogy(err_hist_adam,'-.','LineWidth',2); 
legend('SGD', 'SGDM', 'RMSprop', 'Adam');
xlabel('Ёпоха'); ylabel('ќшибка'); grid on;

figure; 
semilogy(err_hist_adam,'-','LineWidth',2); hold on;
semilogy(err_hist_adam_b500,':','LineWidth',2); hold on;
semilogy(err_hist_adam_b200,'--','LineWidth',2); hold on;
semilogy(err_hist_adam_b100,'-.','LineWidth',2); hold on
% semilogy(err_hist_adam_b50,'LineWidth',2); hold on
legend('1000', '500', '200', '100');
xlabel('Ёпоха'); ylabel('ќшибка'); grid on;

figure; 
semilogy(err_hist_ae1,'LineWidth',2);
xlabel('Ёпоха'); ylabel('ќшибка'); grid on;

figure; 
semilogy(err_hist_ae2,'LineWidth',2);
xlabel('Ёпоха'); ylabel('ќшибка'); grid on;

figure; 
semilogy(err_hist_ae3, 'LineWidth',2);
xlabel('Ёпоха'); ylabel('ќшибка'); grid on;


figure; 
semilogy(err_hist_fine,'LineWidth',2); hold on
semilogy(err_hist_nopr,'--','LineWidth',2); hold on
legend('ѕредобученна€','Ѕез предобучени€');
xlabel('Ёпоха'); ylabel('ќшибка'); grid on;


sorted = [0.00000717	0.00002939	0.00003511	0.00001738	0.00003776	0.00000467	0.00000324]
unsorted = [0.0028	0.0139	0.0185	0.0064	0.016	0.0017	0.0015]
text = {'es01',	'es02',	'es03',	'sc01',	'sc03',	'si01',	'si02'}
