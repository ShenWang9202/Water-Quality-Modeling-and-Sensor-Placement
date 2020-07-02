function plotSensorSelectionResult(sensorSelectionResult,NodeID4Legend,fileName)
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

plotSensoPostition(nSensors,numberofSensorsEachLayer,time5mins,sensorPosition_Time_Number,NodeID4Legend,fileName);
plotSensorPerformance(numberofSensorsEachLayer,achieved,fileName)
plotSensorSelectionRate(nSensors,numberofSensorsEachLayer,time5mins,sensorPosition_Time_Number,NodeID4Legend,fileName);
end