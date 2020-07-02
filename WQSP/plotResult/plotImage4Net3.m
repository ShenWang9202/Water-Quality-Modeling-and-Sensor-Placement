function plotImage4Net3
clear
close all
% load('Net3_1day_Result.mat')
load('Network9_1_1_Net3_1day_Expected45_5min.mat')
load('Random_SensorSelction9_1_1_Net3_1day_Expected45_5min.mat')
fileLongName = 'Net3_t45_5min_SSPaper';
sensorNumberArray = [2 8 14];
% [finalResultCell,finalOccupationTimePlusNodeID,achievedError] = analyzeSensorSelectionResult(sensorSelectionResult,NodeID4Legend,filenameSplit{1},sensorNumberArray);
fileLongName = ['SensorSelction',num2str(Network),'_',num2str(COMPARE),'_',num2str(SENSORSELECT),'_',filenameSplit{1},'_','Expected',num2str(round(Expected_t)),'_',num2str(Hq_min),'min'];
plotSensorSelectionResult_specific_net3(sensorSelectionResult,NodeID4Legend,fileLongName,sensorNumberArray,Hq_min,SimutionTimeInMinute,errorAchievedResult);
plotSensorPerformance_3typicalTime(sensorSelectionResult,NodeID4Legend,fileLongName,sensorNumberArray,Hq_min,SimutionTimeInMinute)
end