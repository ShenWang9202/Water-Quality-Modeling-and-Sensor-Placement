function LDEResult = updateLDEResult(LDEResult,IndexInVar,MassEnergyMatrix)
% find the index of pump and valves;
pumpIndex = IndexInVar.PumpIndex;
valveIndex = IndexInVar.ValveIndex;

% find the nodes connecting to pumps and valves
PumpMatrix = MassEnergyMatrix(pumpIndex,:);
IndexofNodeforPump =  findIndexofNode_Link(PumpMatrix);

PumpIndexInOrder = IndexInVar.PumpIndexInOrder;
[pumpCount,~] = size(PumpMatrix);
for i = 1:pumpCount
upstream = IndexofNodeforPump(i,1);
downstream = IndexofNodeforPump(i,2);
LDEResult(:,PumpIndexInOrder(i)) = (LDEResult(:,upstream) + LDEResult(:,downstream))/2;
end

% update the result for pumps and valves
end