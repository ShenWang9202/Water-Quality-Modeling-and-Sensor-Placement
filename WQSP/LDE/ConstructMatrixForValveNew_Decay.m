function [A_W,B_W] = ConstructMatrixForValveNew_Decay(EnergyMatrixValve,UpstreamNode_Amatrix,UpstreamNode_Bmatrix,ValveReactionCoeff,Valve_CIndex)
EnergyMatrixValve = -EnergyMatrixValve;

% next, remove the downstream node index for valves
% [m,~] = size(EnergyMatrixValve);
% for i = 1:m
%     downstreamNodeIndex = find(EnergyMatrixValve(:,i)<0);
%     EnergyMatrixValve(i,downstreamNodeIndex) = 0;
% end

EnergyMatrixValve(EnergyMatrixValve<0) = 0;

A_W = EnergyMatrixValve * UpstreamNode_Amatrix;
B_W = EnergyMatrixValve * UpstreamNode_Bmatrix;

if(~isempty(Valve_CIndex))
    [row,~] = size(A_W);
    for i = 1:row
        A_W(i,Valve_CIndex(i)) = ValveReactionCoeff;
    end
end



A_W = sparse(A_W);
B_W = sparse(B_W);


end

