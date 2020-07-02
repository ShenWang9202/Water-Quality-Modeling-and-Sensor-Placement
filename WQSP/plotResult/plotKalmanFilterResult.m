load('Net1_1days_test1_KalmanResult.mat')
xp_Record1 = xp_Record_norm;
x_EPANET = x_EPANET_norm;
load('Net1_1days_test2_KalmanResult.mat')
xp_Record2 = xp_Record_norm;



x_EPANET_norm = [];
xp_Record_norm1 = [];
xp_Record_norm2 = [];
for k = 1:1440
    x_EPANET_norm = [x_EPANET_norm mean(x_EPANET(:,k))];
    xp_Record_norm1 = [xp_Record_norm1 mean(xp_Record1(:,k))];
    xp_Record_norm2 = [xp_Record_norm2 mean(xp_Record2(:,k))];
end
 
hf2 = figure;
fontsize = 40;
h1 = plot(x_EPANET_norm,'DisplayName','cos(3x)')
title('The result of true value of $||x||$','Interpreter','latex')
xlabel('$\mathrm{Time\ (minutes)}$','Interpreter','latex','FontSize',fontsize)
ylabel(' ','Interpreter','latex','FontSize',fontsize)

grid on
hold on
 
h2 = plot(xp_Record_norm1)
hold on 
h3 = plot(xp_Record_norm2)

hold off

lgd = legend([h1 h2 h3],{'Real','1','2'});
lgd.FontSize = fontsize-8;
set(lgd,'box','off')
 

    set(gca, 'TickLabelInterpreter', 'latex','fontsize',fontsize);
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 16 6])
filename = 'KalmanResult'
% set(gcf,'PaperUnits','inches','PaperPosition',[0 0 16 7])
print(hf2,filename,'-depsc2','-r300');
print(hf2,filename,'-dpng','-r300');


h4 = figure;
h1 = plot(x_EPANET','DisplayName','cos(3x)')
figure
h2 = plot(xp_Record1')
figure
h3 = plot(xp_Record2')

