load aaa
dat=aaa(:).*4;
figure('Name','1')
set(0,'DefaultAxesFontSize',10);
% histogram(dat,1001,'BinLimits', [0 31],'FaceColor','k')
histogram(dat,1000,'BinLimits', [-1 1],'FaceColor','k')
xlabel('Активации');
ylabel('Частота');
set(gca,'FontSize',14)