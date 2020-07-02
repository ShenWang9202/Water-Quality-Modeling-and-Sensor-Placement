function plotSensoPostition(sensorNumebers,numberofSensorsEachLayer,time,rawData,NodeID4Legend,filename)

[~,layers] = size(numberofSensorsEachLayer);
nLayers = layers-1; % remove the 0 
M = zeros(time+1,sensorNumebers+1,nLayers);
for i = 1:nLayers
    imgFake = zeros(time + 1,sensorNumebers + 1);
    img = ones(time,sensorNumebers) - rawData(:,:,nLayers- i+1);%(randi(2,sensorNumebers,time)-1); % put the sensor selection data here
    imgFake(1:time,1:sensorNumebers) = img;
%     figure
%     imagesc(img);
    colormap(gray);
    M(:,:,i) =  imgFake;
end


hf2 = figure ;
fontsize = 30;
hs = slice(M,[],[],1:nLayers) ;
%shading interp
set(hs,'FaceAlpha',0.5);
axh = hs(1).Parent;    %alternative: axh = gca; 
% title(axh, 'title') 
ylabel(axh, 'Time','FontSize',fontsize,'interpreter','latex')
xlabel(axh, 'Sensor location','FontSize',fontsize,'interpreter','latex')
zlabel(axh, 'Sensor numbers','FontSize',fontsize,'interpreter','latex')
set(gca, 'TickLabelInterpreter', 'latex','fontsize',fontsize);
set(get(gca,'xlabel'),'rotation',70)

labelIndex = [];
everyHowManyHours = 4;
SimulationHour = Constants4Concentration.SimutionTimeInMinute/60;
cellString = cell(1,int16(SimulationHour/everyHowManyHours)+1);
every60minutes = int16(everyHowManyHours*60/Constants4Concentration.Hq_min);
temp = 1;

for i = 0:every60minutes:time
    labelIndex = [labelIndex i];
    cellString{temp} =  strcat(num2str(i*Constants4Concentration.Hq_min/60),'h');
    temp = temp +1;
end

yticks(labelIndex);
yticklabels(cellString);

labelIndex = zeros(1,sensorNumebers);
%cellString = cell(1,sensorNumebers);
for i = 1:sensorNumebers
    labelIndex(i) = i+0.5;
    %cellString{i} =  strcat(num2str(i),'s');
end

cellString = NodeID4Legend;

xticks(labelIndex)
xticklabels(cellString);

labelIndex = 1:nLayers;
zticks(labelIndex);

nSensorEachLayer = numberofSensorsEachLayer(1,2:end); % remove 0 sensors

cellString = cell(1,nLayers);
for i = 1:nLayers
    cellString{i} = strcat(num2str(nSensorEachLayer(nLayers + 1 - i)),'');
end

zticklabels(cellString);
%  
view(axh,[93.644601763819 24.3186267410207]);
% imagesc(randi(2,25,50)-1)
colormap(gray);

fileName = [filename,'sensor'];

set(gcf,'PaperUnits','inches','PaperPosition',[0 0 16 5])
print(hf2,fileName,'-depsc2','-r300');
print(hf2,fileName,'-dpng','-r300');