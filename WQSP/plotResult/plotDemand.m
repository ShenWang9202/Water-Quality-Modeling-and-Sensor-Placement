function plotDemand(JunctionActualDemand)
figure1 = figure
fontsize = 26;

plot(JunctionActualDemand,'LineWidth',2);
xticks([0 360 720 1080 1440])
xlim([0,1440])
ylim([200,900]);
set(gca, 'TickLabelInterpreter', 'latex','fontsize',fontsize);
% lgd = legend('$J2$','Location','Best','Interpreter','Latex');
% lgd.FontSize = fontsize;
% %title('$h^{M} = s^2 (h_0 - r (q/s)^{\nu})$','interpreter','latex','FontSize',fontsize+7)
% set(lgd,'box','off')
% set(lgd,'Interpreter','Latex');

xlabel('Time (minute)','FontSize',fontsize,'interpreter','latex')
ylabel('Demand (GPM)','FontSize',fontsize,'interpreter','latex')
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 8 4])
print(figure1,'3nodesDemand','-depsc2','-r300');
end