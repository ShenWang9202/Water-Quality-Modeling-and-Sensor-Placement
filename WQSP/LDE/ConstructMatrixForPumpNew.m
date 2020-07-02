function [A_M,B_M] = ConstructMatrixForPumpNew(EnergyMatrixPump,UpstreamNode_Amatrix,UpstreamNode_Bmatrix)

% NumberofX = IndexInVar.NumberofX;
% PumpCount = ElementCount.PumpCount;
EnergyMatrixPump = -EnergyMatrixPump;

% next, remove the downstream node index for pumps
% [m,~] = size(EnergyMatrixPump);
% for i = 1:m
%     downstreamNodeIndex = find(EnergyMatrixPump(:,i)<0);
%     EnergyMatrixPump(i,downstreamNodeIndex) = 0;
% end

EnergyMatrixPump(EnergyMatrixPump<0) = 0;

A_M = EnergyMatrixPump * UpstreamNode_Amatrix;
B_M = EnergyMatrixPump * UpstreamNode_Bmatrix;

A_M = sparse(A_M);
B_M = sparse(B_M);

% step 1 find the Index of Node at both end of that link

%IndexofNode_pump =  findIndexofNode_Link(EnergyMatrixPump);

% Since all these indexes in IndexofNode_pipe are either junction,
% reservoir, or tanks, so the corresponding Concerntration Index is exactly
% the same. Hence, IndexofNode_pipe is the Concerntration Index we are
% looking for.
% 
% A_Pump = [];
% for i = 1:PumpCount
%     A_Pump_i = zeros(1,NumberofX);
%     % pump's concentration equals its suction side
%     A_Pump_i(IndexofNode_pump(i,1)) = 1; 
%     
%     % % pump's concentration equals to 0.5*( downstream side + upstream
%     % side
% %     A_Pump_i(IndexofNode_pump(i,1)) = 0.5;
% %     A_Pump_i(IndexofNode_pump(i,2)) = 0.5;
%     A_Pump = [A_Pump;A_Pump_i];
% end
% A_M = A_Pump;
end