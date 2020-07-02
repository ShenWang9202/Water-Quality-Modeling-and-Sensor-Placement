function plotSensoPostition_specific(sensorNumebers,numberofSensorsEachLayer,time,rawData,NodeID4Legend,filename,Hq_min,SimutionTimeInMinute)

ThreeDPLOT = 0;
[~,nLayers] = size(numberofSensorsEachLayer);

% extend one more row and column.
M = ones(time+1,sensorNumebers+1,nLayers)*10;
imgCell = cell(nLayers,1);
for i = 1:nLayers
    imgFake = ones(time + 1,sensorNumebers + 1);
    img = ones(time,sensorNumebers) - rawData(:,:,nLayers - i + 1);%(randi(2,sensorNumebers,time)-1); % put the sensor selection data here
    imgFake(2:time+1,2:sensorNumebers+1) = img;
    imgCell{i} = img;
%     figure
%     imagesc(img);
%     hold on
%     title(['r = ',num2str(numberofSensorsEachLayer(1,nLayers - i + 1))]);
%     colormap(gray);
    M(:,:,i) =  imgFake;
end
hf2 = figure;

for i = 1:nLayers
    subplot(1,nLayers,i);
    imagesc(imgCell{nLayers - i + 1});
    hold on
    title(['r = ',num2str(numberofSensorsEachLayer(1,i))]);
    colormap(gray);
    hold on
end

fileName = ['SS_Result4',filename];
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 16 9])
print(hf2,fileName,'-depsc2','-r300');
print(hf2,fileName,'-dpng','-r300');



if(ThreeDPLOT)
    hf2 = figure;
    fontsize = 37;
    hs = slice(M,[],[],1:nLayers) ;
    %shading interp
    set(hs,'FaceAlpha',0.95);
    
    % change the grid edgealpha of each layer
    for i = 1:nLayers
        hss = hs(i);
        hss.EdgeColor = [0.32 0.32 0.32];
        hss.EdgeAlpha = 0.25;
    end
    
    
    axh = hs(1).Parent;    %alternative: axh = gca;
    % title(axh, 'title')
    ylabel(axh, 'Time','FontSize',fontsize,'interpreter','latex')
    xlabel(axh, 'Sensor location','FontSize',fontsize,'interpreter','latex')
    zlabel(axh, 'Sensor numbers','FontSize',fontsize,'interpreter','latex')
    set(gca, 'TickLabelInterpreter', 'latex','fontsize',fontsize);
    
    ax = get(gca,'XtickLabel');
    set(gca, 'XtickLabel',ax,'fontsize',fontsize-8);
    
    % rotate xlabel a little bit
    set(get(gca,'xlabel'),'rotation',10)
    
    
    % y axis
    labelIndex = [];
    everyHowManyHours = 4;
    SimulationHour = SimutionTimeInMinute/60;
    cellString = cell(1,int16(SimulationHour/everyHowManyHours)+1);
    every60minutes = int16(everyHowManyHours*60/Hq_min);
    temp = 1;
    
    for i = 0:every60minutes:time
        labelIndex = [labelIndex i];
        cellString{temp} =  strcat(num2str(i*Hq_min/60),'h');
        temp = temp +1;
    end
    
    yticks(labelIndex);
    yticklabels(cellString);
    
    % x axis
    labelIndex = zeros(1,sensorNumebers);
    %cellString = cell(1,sensorNumebers);
    for i = 1:sensorNumebers
        labelIndex(i) = i*1.08 + 0.1;
        %cellString{i} =  strcat(num2str(i),'s');
    end
    
    cellString = NodeID4Legend;
    
    xticks(labelIndex)
    xticklabels(flipud(cellString));
    % xticklabels([])
    
    a = gca;
    a.XRuler.TickLabelGapOffset
    
    % z axis
    labelIndex = 1:nLayers;
    zticks(labelIndex);
    
    nSensorEachLayer = numberofSensorsEachLayer(1,1:end); % remove 0 sensors
    
    cellString = cell(1,nLayers);
    for i = 1:nLayers
        cellString{i} = strcat(num2str(nSensorEachLayer(nLayers + 1 - i)),'');
    end
    
    zticklabels(cellString);
    %
    view(axh,[130.660457274984 22.8988085784382]);
    colormap(gray);
    
    fileName = [filename,'sensor'];
    pos  = get(gcf,'PaperPosition')
    set(gcf,'PaperUnits','inches','PaperPosition',[0 0 16 9])
    print(hf2,fileName,'-depsc2','-r300');
    print(hf2,fileName,'-dpng','-r300');
else
    ;
end