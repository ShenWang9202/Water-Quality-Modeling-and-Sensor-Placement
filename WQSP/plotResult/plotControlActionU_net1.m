function plotControlActionU_net1(ControlActionU,BoosterLocationIndex,Location_B)
figure1 = figure
fontsize = 40;
plot(ControlActionU(:,BoosterLocationIndex),'LineWidth',3);
xticks([0 360 720 1080 1440])
%yticks([0 0.8 2 3])
xlim([0,1440])
%ylim([200,900]);
set(gca, 'TickLabelInterpreter', 'latex','fontsize',fontsize,'YGrid','off','XGrid','on');
lgd = legend(Location_B,'Location','Best','Interpreter','Latex','Orientation','horizontal');
lgd.FontSize = fontsize;
%title('$h^{M} = s^2 (h_0 - r (q/s)^{\nu})$','interpreter','latex','FontSize',fontsize+7)
set(lgd,'box','off')
set(lgd,'Interpreter','Latex');

xlabel('Time (minute)','FontSize',fontsize,'interpreter','latex')
ylabel('Mass rate at boosters (mg/minute)','FontSize',fontsize,'interpreter','latex')
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 16 8])
print(figure1,'ControlActionU_net1','-depsc2','-r300');
end