function plotImageFusion4Net1

clear
% load('Network6_1_1_Net1_1days_demand-pattern1_Expected5_5min.mat')
% SSBase = sensorSelectionResult;
% 
% load('Network6_1_1_Net1_1days_demand-pattern3_Expected5_5min.mat')
% SSBase_P2 = sensorSelectionResult;
% 
% load('Network6_1_1_Net1_1days_demand-pattern4_Expected5_5min.mat')
% SSBase_P3 = sensorSelectionResult;
% 
% 
% load('Network6_1_1_Net1_1days_demand-pattern1-basedemand1_Expected5_5min.mat')
% SSBase_P1_b2 = sensorSelectionResult;
% 
% 
load('Network6_1_1_Net1_1days_demand-pattern1-basedemand2_Expected5_5min.mat')
% SSBase_P1_b3 = sensorSelectionResult;

load('fusionData.mat')

tempSensorSelectionResult = struct('sensorSolution',0,...
    'achieved',0,...
    'numberofSensors',0,...
    'fromCase',0);

numberofSensors = SSBase.numberofSensors;
[~,consideredSensors] = size(numberofSensors);

allSS = [SSBase;
    SSBase_P2;
    SSBase_P3;
    SSBase_P1_b2;
    SSBase_P1_b3;];

finalSensorSelectionResult = [];
achievedIndexAll = [];
for t = 1:289

    achievedTemp = [];
    sensorSolutionTemp = [];

    
    for i = 1:5
        SS = allSS(i,t);
        achieved = SS.achieved;
        achieved = achieved(1:consideredSensors);
        achievedTemp = [achievedTemp achieved];
    end
    [minAchieved, achievedIndex] = min(achievedTemp');
    achievedIndexAll = [achievedIndexAll; achievedIndex];
    tempSensorSelectionResult.fromCase = achievedIndex;
    tempSensorSelectionResult.achieved = minAchieved';

    
    for j = 1:consideredSensors
        achievedIndex(j)
        newSS = allSS(achievedIndex(j),t);
        sensorSolution = newSS.sensorSolution;
        sensorSolutionTemp = [sensorSolutionTemp; sensorSolution(j,:)];
    end
    tempSensorSelectionResult.sensorSolution = sensorSolutionTemp;
    tempSensorSelectionResult.numberofSensors = numberofSensors;
    
    finalSensorSelectionResult = [finalSensorSelectionResult tempSensorSelectionResult];
end
 


fileLongName = 'fusion';
plotSensorSelectionResult_specific(finalSensorSelectionResult,NodeID4Legend,fileLongName,sensorNumberArray,Hq_min,SimutionTimeInMinute);
