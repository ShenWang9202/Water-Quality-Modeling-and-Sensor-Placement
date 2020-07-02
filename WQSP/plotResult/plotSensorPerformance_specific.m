function plotSensorPerformance_specific(numberofSensors,achieved,filename,Hq_min)

nSensorEachLayer = numberofSensors(1,1:end); % remove 0 sensors
achieved = achieved(:,1:end); % remove the data of 0 sensors
% achieved = -achieved;

figure1 = figure();

[time,nLayers] = size(achieved);
data = achieved;  % Sample data, one curve per column

% Create data matrices:
[X, Y] = meshgrid(0:(nLayers-1), [1 1:time time]);
Z = [zeros(1, nLayers); data; zeros(1, nLayers)];
patchColor = [0 0.4470 0.7410];  % RGB color for patch edge and face


% Create axes
axes1 = axes('Parent',figure1);
fontsize = 30;
% Plot patches:
hFill = fill3(X, Y, Z, patchColor, 'LineWidth', 1, 'EdgeColor', patchColor, ...
              'FaceAlpha', 0.5);
set(gca, 'YDir', 'reverse', 'YLim', [1 time]);
grid on

 

ylabel(  'Time','FontSize',fontsize,'interpreter','latex')
zlabel(  '$f(\mathcal{S})$','FontSize',fontsize,'interpreter','latex')
xlabel( 'Sensor numbers','FontSize',fontsize,'interpreter','latex')
set(gca, 'TickLabelInterpreter', 'latex','fontsize',fontsize);
set(get(gca,'xlabel'),'rotation',-15)
set(get(gca,'ylabel'),'rotation',15)


% yticklabels
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

yticks(labelIndex);
yticklabels(cellString);

% xtick labels
labelIndex = zeros(1,nLayers);
cellString = cell(1,nLayers);
for i = 1:nLayers
    labelIndex(i) = i - 1;
    cellString{i} = strcat(num2str(nSensorEachLayer(i)),'');
end

xticks(labelIndex)
xticklabels(cellString);

% view 
view(axes1,[-132.4375 67.4896815286624]);
fileName = ['Reached_',filename];
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 16 5])
print(figure1,fileName,'-depsc2','-r300');
print(figure1,fileName,'-dpng','-r300');