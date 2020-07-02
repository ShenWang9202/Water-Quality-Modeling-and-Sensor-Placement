function plotSensorSelectionRate(sensorNumebers,numberofSensorsEachLayer,time,rawData,NodeID4Legend,filename,Hq_min)

[~,layers] = size(numberofSensorsEachLayer);
nLayers = layers-1; % remove the 0
M = zeros(time,sensorNumebers);
for i = 1:nLayers
    img = rawData(:,:,layers- i+1);%(randi(2,sensorNumebers,time)-1); % put the sensor selection data here
    M = M + img;
end

hf = figure ;
width = 0.4;
hs = bar3h(M,width) ;
for i = 1:length(hs)
    hs(i).FaceAlpha = 0.7;
end

axh = hs(1).Parent;    %alternative: axh = gca;
% title(axh, 'title')

xlabel(axh, 'Sensor location')
ylabel(axh, 'Frequence')
zlabel(axh, 'Time')

labelIndex = [];
everyHowManyHours = 2;
SimulationHour = Constants4Concentration.SimutionTimeInMinute/60;
cellString = cell(1,int16(SimulationHour/everyHowManyHours)+1);
every60minutes = int16(everyHowManyHours*60/Hq_min);
temp = 1;

for i = 0:every60minutes:time
    labelIndex = [labelIndex i];
    cellString{temp} =  strcat(num2str(i*Hq_min/60),'h');
    temp = temp +1;
end

zticks(labelIndex);
zticklabels(cellString);

labelIndex = zeros(1,sensorNumebers);
for i = 1:sensorNumebers
    labelIndex(i) = i+0.5;
end
xticks(labelIndex)
xticklabels(NodeID4Legend);

labelIndex = 1:nLayers;
yticks(labelIndex);

nSensorEachLayer = numberofSensorsEachLayer(1,2:end); % remove 0 sensors
cellString = cell(1,nLayers);
for i = 1:nLayers
    cellString{i} = strcat(num2str(nSensorEachLayer(nLayers + 1 - i)),'');
end
yticklabels(cellString);

view(axh,[-33.5101153054501 73.221401249214]);
% % imagesc(randi(2,25,50)-1)
% colormap(gray);