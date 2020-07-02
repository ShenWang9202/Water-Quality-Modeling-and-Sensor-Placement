function PipeIndexConnectingLocation = findOutFlowIndexByNodeID(Location_B,NodeID,CurrentFlow,MassEnergyMatrix)
% 1. find LocationNodeIndex of Location_B
LocationNodeIndex = [];
[~,nB] = size(Location_B);
for i = 1:nB
    indexL = findIndexByID(Location_B{i},NodeID);
    LocationNodeIndex = [LocationNodeIndex indexL];
end
% 2. find all the PipeIndexConnectingLocatoin (only outflow) for each LocationNodeIndex
PipeIndexConnectingLocation = [];
for i = 1:nB
    indexP = findOutFlowIndexByID(LocationNodeIndex(i),MassEnergyMatrix,CurrentFlow);
    PipeIndexConnectingLocation = [PipeIndexConnectingLocation indexP];
end
end