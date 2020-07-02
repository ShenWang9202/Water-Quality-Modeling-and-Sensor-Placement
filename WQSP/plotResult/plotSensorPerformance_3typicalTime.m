function plotSensorPerformance_3typicalTime(sensorSelectionResult,NodeID4Legend,fileName,sensorNumberArray,Hq_min,SimutionTimeInMinute)

[~,time5mins] = size(sensorSelectionResult);
i = 1;
sensorSelection5minsResult = sensorSelectionResult(i);
sensorSolution5minsResult = sensorSelection5minsResult.sensorSolution;
[nLayers,nSensors] = size(sensorSolution5minsResult);

sensorPosition_Time_Number = -1 * ones(time5mins,nSensors,nLayers);
numberofSensorsEachLayer = [];
achieved = [];

timeSelected = [1 120 240];
numTime = length(timeSelected)
 
hf2 = figure;
fontsize = 25;
ha = tight_subplot(1,numTime,[.1 .08],[.3 .3],[.2 .3])
for ii = 1:numTime
    axes(ha(ii)); 
    timeSelectedIndex = timeSelected(ii);
    achieved_Time = sensorSelectionResult(timeSelectedIndex).achieved;
    achieved_Time = achieved_Time(2:nLayers);
    plot(achieved_Time,'-*','LineWidth',2);
    hold on
    ha(ii)
    set(gca, 'TickLabelInterpreter', 'latex','fontsize',fontsize-5);
    %set(ha(ii).Title,'String',['$ T_h = ',num2str(timeSelectedIndex*5/60),'$','h']);
    ax = gca
    ax.Title.Interpreter = 'latex';
    ax.YLabel.Interpreter = 'latex';
    ax.XLabel.Interpreter = 'latex';
end

hold on
% X axis
set(ha(1:end),'XTick',[1 5 10 15]);
set(ha(1:end),'XLim',[0 16]);
set(ha(1:end),'XTickLabel',{'1','5','10','95'},'fontsize',fontsize);
set(ha(1:end),'XTickLabel',{'1','5','10','95'},'fontsize',fontsize);
set(ha(2).XLabel,'String','${r} \in \{1,\ldots,14,95\}$ ','fontsize',fontsize);
set(ha(1).YLabel,'String','$f(\mathcal{S}^*_{r})$','fontsize',fontsize);

% xlabel( 'Sensor numbers','FontSize',fontsize,'interpreter','latex')
% set(gca, 'TickLabelInterpreter', 'latex','fontsize',fontsize);
% set(get(gca,'xlabel'),'rotation',-15)
% set(get(gca,'ylabel'),'rotation',15)
% set(gca, 'YScale', 'log')

 
 
% fileName = 'Threenode_Reached'
fileName = 'Net3_Reached'
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 16 5])
print(hf2,fileName,'-depsc2','-r300');
print(hf2,fileName,'-dpng','-r300');