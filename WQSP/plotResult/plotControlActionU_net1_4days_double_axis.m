function plotControlActionU_net1_4days_double_axis(ControlActionU,BoosterLocationIndex,Location_B)
figure1 = figure
fontsize = 40;
plot(ControlActionU(:,BoosterLocationIndex(1)),'LineWidth',3);

yyaxis right
plot(ControlActionU(:,BoosterLocationIndex(2:3)),'LineWidth',3);


xticks([0 1440 2880 4320 5660]);
xticklabels({'0 (0D)','1440 (1D)', '2880 (2D)', '4320 (3D)', '5760 (4D)'})
%yticks([0 1 2 3])
xlim([0,5761])

set(gca, 'TickLabelInterpreter', 'latex','fontsize',fontsize,'YGrid','off','XGrid','on');
lgd = legend(Location_B,'Location','Best','Interpreter','Latex','Orientation','horizontal');
lgd.FontSize = fontsize;
set(lgd,'box','off')
set(lgd,'Interpreter','Latex');

xlabel('Time (minute \& day)','FontSize',fontsize,'interpreter','latex')
ylabel({'Mass rate at boosters';'   (mg/minute)'},'FontSize',fontsize,'interpreter','latex')

set(gca, 'TickLabelInterpreter', 'latex','fontsize',fontsize-5);
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 16 8])
print(figure1,'ControlActionU_net1','-depsc2','-r300');
end
