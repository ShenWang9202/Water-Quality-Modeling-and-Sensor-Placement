function plotDemandTogether


Pattern3node = [0.12 0.2 0.3 0.4];
Pattern3node = repmat(Pattern3node,[1 6]);

load('Network6_1_1_Net1_1days_demand-pattern1_Expected5_5min.mat')

PatternNet1 = nodePattern;%[1.0 1.2 1.4 1.6 1.4 2 1.0 2.5 2 1.8 1.2 1.4];
PatternNet1 =  repmat(PatternNet1,[1 2]);


figure1 = figure
fontsize = 40;
yyaxis left
stairs(Pattern3node,'LineWidth',4,'Color',[0.85 0.33 0.1]);
 ylim([0,1.4])
% yticks([0.005 0.03  0.07])
% yticklabels({'0.5\%','3.0\%','7\%'})
%ylabel({'Three-node ';'   network'},'FontSize',fontsize,'interpreter','latex')
yyaxis right
stairs(PatternNet1,'LineWidth',4,'Color',[0 0.45 0.74]);
xlim([0,24]);
xticks([6 12 18 24])
% yticks([0.005 0.03  0.07])
xticklabels({'6h','12h','18h','24h'})
ylim([0,2.6]);
set(gca, 'TickLabelInterpreter', 'latex','fontsize',fontsize);
ax = gca
ax.YAxis(1).Color = [0.85 0.33 0.1];
ax.YAxis(2).Color = [0 0.45 0.74];

lgd = legend({'Pattern I (Three-node)','Pattern I (Net1)'},'Location','Best','Interpreter','Latex','Orientation','horizontal');
lgd.FontSize = fontsize-6;
set(lgd,'box','off')
set(lgd,'Interpreter','Latex');

% xlabel('Time','FontSize',fontsize,'interpreter','latex')
%ylabel({'Relative error between ';'   EPANET and LDE'},'FontSize',fontsize,'interpreter','latex')
% ylabel('Net1','FontSize',fontsize,'interpreter','latex')
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 16 4])
print(figure1,'demandpattern','-depsc2','-r300');
print(figure1,'demandpattern','-dpng','-r300');
