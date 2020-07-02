function plotSensorPerformance_paper1(numberofSensors,achieved,filename,Hq_min)

nSensorEachLayer = numberofSensors(1,1:end); % remove 0 sensors
achieved = (achieved(:,1:end)); % remove the data of 0 sensors
% achieved = -achieved;

figure1 = figure();

[time,nLayers] = size(achieved);
data = achieved;  % Sample data, one curve per column

plot(data)
fontsize = 30;

xlabel(  'Time','FontSize',fontsize,'interpreter','latex')
ylabel(  '$f(\mathcal{S})$','FontSize',fontsize,'interpreter','latex')
% xlabel( 'Sensor numbers','FontSize',fontsize,'interpreter','latex')
set(gca, 'TickLabelInterpreter', 'latex','fontsize',fontsize);
% set(get(gca,'xlabel'),'rotation',-15)
% set(get(gca,'ylabel'),'rotation',15)
% set(gca, 'YScale', 'log')


% xticklabels
labelIndex = [];
everyHowManyHours = 4;
cellString = cell(1,int16(24/everyHowManyHours)+1);
every60minutes = int16(everyHowManyHours*60/Hq_min);
temp = 1;

for i = 0:every60minutes:time
    labelIndex = [labelIndex i];
    cellString{temp} =  strcat(num2str(i*Hq_min/60),'h');
    temp = temp +1;
end

xticks(labelIndex);
xticklabels(cellString);
% 
% % ytick labels
% labelIndex = zeros(1,nLayers);
% cellString = cell(1,nLayers);
% for i = 1:nLayers
%     labelIndex(i) = i - 1;
%     cellString{i} = strcat(num2str(nSensorEachLayer(i)),'');
% end
% 
% yticks(labelIndex)
% yticklabels(cellString);

 
% fileName = 'Threenode_Reached'
fileName = 'Net3_Reached_all'
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 16 5])
print(figure1,fileName,'-depsc2','-r300');
print(figure1,fileName,'-dpng','-r300');