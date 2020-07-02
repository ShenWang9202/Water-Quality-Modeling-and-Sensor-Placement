function A_M = ConstructMatrixForPump(EnergyMatrixPump,ElementCount,IndexInVar)

NumberofX = IndexInVar.NumberofX;
PumpCount = ElementCount.PumpCount;

% step 1 find the Index of Node at both end of that link
IndexofNode_pump =  findIndexofNode_Link(EnergyMatrixPump);
% Since all these indexes in IndexofNode_pipe are either junction,
% reservoir, or tanks, so the corresponding Concerntration Index is exactly
% the same. Hence, IndexofNode_pipe is the Concerntration Index we are
% looking for.

A_Pump = [];
for i = 1:PumpCount
    A_Pump_i = zeros(1,NumberofX);
    % pump's concentration equals its suction side
    A_Pump_i(IndexofNode_pump(i,1)) = 1; 
    
    % % pump's concentration equals to 0.5*( downstream side + upstream
    % side
%     A_Pump_i(IndexofNode_pump(i,1)) = 0.5;
%     A_Pump_i(IndexofNode_pump(i,2)) = 0.5;
    A_Pump = [A_Pump;A_Pump_i];
end
A_M = A_Pump;
end