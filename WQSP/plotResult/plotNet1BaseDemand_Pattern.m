function plotNet1BaseDemand_Pattern

load('Network6_1_1_Net1_1days_demand-pattern1_Expected5_5min.mat')
baseDemand{1}
nodePattern1 = nodePattern;
baseDemand1 = baseDemand{1};
load('Network6_1_1_Net1_1days_demand-pattern3_Expected5_5min.mat')
nodePattern2 = nodePattern;
load('Network6_1_1_Net1_1days_demand-pattern4_Expected5_5min.mat')
nodePattern3 = nodePattern;

load('Network6_1_1_Net1_1days_demand-pattern1-basedemand1_Expected5_5min.mat')
baseDemand{1}
baseDemand2 = baseDemand{1};
load('Network6_1_1_Net1_1days_demand-pattern1-basedemand2_Expected5_5min.mat')
baseDemand{1}
baseDemand3 = baseDemand{1};

hf2 = figure;

fontsize = 40;

baseDemand = [baseDemand1;baseDemand2;baseDemand3];
bar(baseDemand');
set(gca, 'TickLabelInterpreter', 'latex','fontsize',fontsize);
% 'Orientation','horizontal'
ylim([0 700])
lgd = legend({'Base demand 1','Base demand 2','Base demand 3'},'Location','Best','Interpreter','Latex','Orientation','horizontal');
lgd.FontSize = fontsize;
set(lgd,'box','off')
set(lgd,'Interpreter','Latex');
labelIndex = 1:11;
set(gca,'XTick',labelIndex);
set(gca,'XTickLabel',NodeID4Legend,'fontsize',fontsize);
hold on
ylabel('GPM')

filename = 'Net1BaseDemand';
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 18 4])
print(hf2,filename,'-depsc2','-r300');
print(hf2,filename,'-dpng','-r300');


% set(gca, 'TickLabelInterpreter', 'latex','fontsize',fontsize);
% set(ha(1).Title,'String',['$r = ',num2str(numberofSensorsEachLayer(1,1)),'$']);
% ax = gca;
% ax.Title.Interpreter = 'latex';
 hf2 = figure;

stairs([nodePattern1 nodePattern1],'LineWidth',4,'LineStyle',':');
hold on
stairs([nodePattern2 nodePattern2],'LineWidth',4);
hold on
stairs([nodePattern3 nodePattern3],'LineWidth',4);
set(gca, 'TickLabelInterpreter', 'latex','fontsize',fontsize);
lgd = legend({'Pattern I','Pattern II','Pattern III'},'Location','Best','Interpreter','Latex','Orientation','horizontal');
lgd.FontSize = fontsize;
set(lgd,'box','off')
set(lgd,'Interpreter','Latex');
labelIndex = 6:6:24;
cellString = cell(1,4);
for i = 1:4
    cellString{i} = strcat(num2str(labelIndex(i)),'h');
end
ylim([0 3.7])
set(gca,'XTick',labelIndex);
set(gca,'XTickLabel',cellString,'fontsize',fontsize);hold on
ylabel('                                  ')


filename = 'Net1DemandPattern'
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 18 4])
print(hf2,filename,'-depsc2','-r300');
print(hf2,filename,'-dpng','-r300');


    

end