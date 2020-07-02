function plotSensorSelectionResult_specific_net3(sensorSelectionResult,NodeID4Legend,fileName,sensorNumberArray,Hq_min,SimutionTimeInMinute,errorAchievedResult)
[~,time5mins] = size(sensorSelectionResult);
i = 1;
sensorSelection5minsResult = sensorSelectionResult(i);
sensorSolution5minsResult = sensorSelection5minsResult.sensorSolution;
[nLayers,nSensors] = size(sensorSolution5minsResult);

sensorPosition_Time_Number = -1 * ones(time5mins,nSensors,nLayers);
numberofSensorsEachLayer = [];
achieved = [];
for i = 1:time5mins
    sensorSelection5minsResult = sensorSelectionResult(i);
    sensorSolution5minsResult = sensorSelection5minsResult.sensorSolution;
    achieved5minsResult = sensorSelection5minsResult.achieved;
    numberofSensors5minsResult = sensorSelection5minsResult.numberofSensors;
    
    sensorPosition_Time_Number(i,:,:) = sensorSolution5minsResult';
    numberofSensorsEachLayer = [numberofSensorsEachLayer;numberofSensors5minsResult];
    achieved = [achieved;achieved5minsResult'];
end

% numberofSensorsEachLayer = numberofSensorsEachLayer(:,2:end);
% sensorPosition_Time_Number = sensorPosition_Time_Number(:,:,2:end);
% achieved = achieved(:,2:end);
% 
% numberofSensorsEachLayer = numberofSensorsEachLayer(:,[1 4 7]);
% sensorPosition_Time_Number = sensorPosition_Time_Number(:,:,[1 4 7]);
% achieved = achieved(:,[1 4 7]);

% remove the 0 and all installed case;
numberofSensorsEachLayer = numberofSensorsEachLayer(:,2:end-1);
sensorPosition_Time_Number = sensorPosition_Time_Number(:,:,2:end-1);
achieved = achieved(:,2:end-1);

numberofSensorsEachLayer = numberofSensorsEachLayer(:,sensorNumberArray);
sensorPosition_Time_Number = sensorPosition_Time_Number(:,:,sensorNumberArray);
achieved = achieved(:,sensorNumberArray);

% plotSensoPostition_specific(nSensors,numberofSensorsEachLayer,time5mins,sensorPosition_Time_Number,NodeID4Legend,fileName,Hq_min,SimutionTimeInMinute);
% plotSensorPerformance_specific(numberofSensorsEachLayer,achieved,fileName,Hq_min)
% plotSensorSelectionRate(nSensors,numberofSensorsEachLayer,time5mins,sensorPosition_Time_Number,NodeID4Legend,fileName,Hq_min);

plotSensoPostition_paper_net3(nSensors,numberofSensorsEachLayer,time5mins,sensorPosition_Time_Number,NodeID4Legend,fileName,Hq_min,SimutionTimeInMinute);
% plotSensorPerformance_paper1(numberofSensorsEachLayer,achieved,fileName,Hq_min)
plotSensorPerformance_paper_Random(numberofSensorsEachLayer,achieved,fileName,Hq_min,errorAchievedResult)

end