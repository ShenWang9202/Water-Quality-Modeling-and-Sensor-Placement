function A_W = ConstructMatrixForValve(EnergyMatrixValve,ElementCount,IndexInVar)
NumberofX = IndexInVar.NumberofX;
ValveCount = ElementCount.ValveCount;

% step 1 find the Index of Node at both end of that link
IndexofNode_Valve =  findIndexofNode_Link(EnergyMatrixValve);
% Since all these indexes in IndexofNode_pipe are either junction,
% reservoir, or tanks, so the corresponding Concerntration Index is exactly
% the same. Hence, IndexofNode_pipe is the Concerntration Index we are
% looking for.

A_Valve = [];
for i = 1:ValveCount
    A_Valve_i = zeros(1,NumberofX);
    A_Valve_i(IndexofNode_Valve(i,1)) = 1;
    %A_Pump_i(IndexofNode_Valve(i,2)) = 0.5;
    A_Valve = [A_Valve;A_Valve_i];
end
A_W = A_Valve;
end
