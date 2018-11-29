x = -1:0.001:1;
figure; 
plot(x,cattan(x),'k'); xlabel('z'); ylabel('S(z)'); grid on; 
% set(0,'DefaultAxesFontSize',14);
figure;
plot(x,cattanderiv(x),'k'); xlabel('z'); ylabel('dS(z)/dz'); grid on; 
set(0,'DefaultAxesFontSize',14);