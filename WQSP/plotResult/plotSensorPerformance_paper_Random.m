function plotSensorPerformance_paper_Random(numberofSensors,achieved,filename,Hq_min,errorAchievedResult)

% nSensorEachLayer = numberofSensors(1,1:end); % remove 0 sensors
% achieved = (achieved(:,1:end)); % remove the data of 0 sensors
% achieved = -achieved;

achieved = achieved(:,end);
randomAchieved = errorAchievedResult;
[time,~] = size(randomAchieved);
randomAchieved14 = [];
for i = 1:time
     randomAchieved_All_r = randomAchieved{i};
     randomAchieved_r_14 = randomAchieved_All_r(4,:);
     randomAchieved_r_14 = cell2mat(randomAchieved_r_14);
     randomAchieved14 = [randomAchieved14;randomAchieved_r_14];
end

figure1 = figure();

[time,nLayers] = size(achieved);
randomAchieved14 = randomAchieved14 - repmat(achieved,1,10);
fontsize = 30;

yyaxis left
plot(achieved,'LineWidth',3)
ylabel('$f(\mathcal{S}_{r=14}^{*})$','FontSize',fontsize,'interpreter','latex')
yyaxis right
plot(randomAchieved14);
ylim([0 350]);

% xlabel(  'Time','FontSize',fontsize,'interpreter','latex')
ylabel(  '$\Delta f(\hat{\mathcal{S}}_{r=14})$','FontSize',fontsize,'interpreter','latex')
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
fileName = 'Random_Net3_Reached_all'
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 16 5])
print(figure1,fileName,'-depsc2','-r300');
print(figure1,fileName,'-dpng','-r300');