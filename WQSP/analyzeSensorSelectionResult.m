function [finalResultCell,finalOccupationTimePlusNodeID,achievedError]= analyzeSensorSelectionResult(sensorSelectionResult,NodeID4Legend,fileName,sensorNumberArray)
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
achievedError = achieved(:,sensorNumberArray);
occupationEachNode_All_r = occupationTimeAnalysis(sensorPosition_Time_Number);

occupationEachNode_All_r_cell = num2cell(occupationEachNode_All_r);

[T_total,numofNode,r] = size(sensorPosition_Time_Number);
 
finalOccupationTimePlusNodeID = cell(numofNode + 1,r + 1);

finalOccupationTimePlusNodeID{1,1} = 'ID';
finalOccupationTimePlusNodeID(1,2:end) = num2cell(sensorNumberArray);
finalOccupationTimePlusNodeID(2:end,1) = NodeID4Legend(:,1);
finalOccupationTimePlusNodeID(2:end,2:end) = occupationEachNode_All_r_cell(:,1:end);

numberofSensor = numberofSensorsEachLayer(1,:);
finalResultCell = cell(r,1);
for i = 1:r
    [finalOccupationTime,indexOfSensor] = maxk_my(occupationEachNode_All_r(:,i),numberofSensor(i));
    tempNode = NodeID4Legend(indexOfSensor);
    tempCell = cell(numberofSensor(i),2);
    for j = 1:numberofSensor(i)
        tempCell{j,1} = tempNode{j};
        tempCell{j,2} = num2cell(finalOccupationTime(j));
    end
    finalResultCell{i} = tempCell;
end

end