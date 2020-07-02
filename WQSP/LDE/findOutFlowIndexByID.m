function indexP = findOutFlowIndexByID(LocationNodeIndex,MassEnergyMatrix,CurrentFlow)
ConnectMatrixofJunction = MassEnergyMatrix(:,LocationNodeIndex);
TureCurrentFlow = CurrentFlow.*ConnectMatrixofJunction;
indexP = find(TureCurrentFlow<0);
indexP = indexP';
end