function [A_TK,B_TK,NodeTankVolume_Next] = ConstructMatrixForTank(delta_t,CurrentFlow,CurrentNodeTankVolume,TankMassMatrix,ElementCount,IndexInVar,aux,q_B,flipped)
% step 1: find the V(t+delta_t)
CurrentNodeNetFlowTank = TankMassMatrix*CurrentFlow;
CurrentNodeTankVolume = CurrentNodeTankVolume';
NodeTankVolume_Next = CurrentNodeTankVolume + delta_t.*CurrentNodeNetFlowTank./Constants4Concentration.GPMperCFS;
TankBulkReactionCoeff_perSec = aux.TankBulkReactionCoeff;
TankCount = ElementCount.TankCount;
NumberofX = IndexInVar.NumberofX;
Tank_CIndex = IndexInVar.Tank_CIndex;
NumberofSegment4Pipes = aux.NumberofSegment4Pipes;
TankIndexInOrder = IndexInVar.TankIndexInOrder;
% step 2: find the impact of inflow and outflow
A_TK = [];
q_B = q_B./Constants4Concentration.GPMperCFS; % concert q_B from GPM to CFS
[NodeCount,~] = size(q_B);
B_TK = zeros(TankCount,NodeCount);
for i = 1:TankCount
    A_TK_i = zeros(1,NumberofX);
    % Step a: consider contribution from tanks (outflow at first);
    
    % True flow rate of pipes connecting with _Tank_i after removing the consideration of
    % assumed direction of flow, and make sure the unit is correct
    CurrentTrueFlowPipe_Tank_i = TankMassMatrix(i,:).*CurrentFlow'./Constants4Concentration.GPMperCFS;
    
    IndexofOutFlow = find(CurrentTrueFlowPipe_Tank_i<0);
    % size of outflow pipes;
    [~,m] = size(IndexofOutFlow);
    sumOutFlow = 0;
    for j = 1:m
        sumOutFlow = sumOutFlow + CurrentTrueFlowPipe_Tank_i(IndexofOutFlow(j));
    end
    Atemp = (CurrentNodeTankVolume(i)+delta_t*sumOutFlow)/NodeTankVolume_Next(i);
    % consider the first order reaction in tanks
    Atemp = Atemp + TankBulkReactionCoeff_perSec(i)*delta_t;
    A_TK_i(1,Tank_CIndex(i)) = Atemp;
    
    % Step a: consider contribution from pipes (inflow);
    IndexofInFlow = find(CurrentTrueFlowPipe_Tank_i>0);
    % size of inflow pipes;
    [~,m] = size(IndexofInFlow);
    
    for j = 1:m
%         Index =  findIndexofLastSegment(IndexofInFlow(j),IndexInVar)
        Index = findIndexofLastorFirstSegment(IndexofInFlow(j),IndexInVar,flipped(j),NumberofSegment4Pipes);
        A_TK_i(1,Index) = delta_t*CurrentTrueFlowPipe_Tank_i(IndexofInFlow(j))/NodeTankVolume_Next(i);
    end
    A_TK = [A_TK;A_TK_i];
    B_TK(i,TankIndexInOrder(i)) = delta_t * q_B(TankIndexInOrder(i),1)/NodeTankVolume_Next(i);
end
A_TK = sparse(A_TK);
B_TK = sparse(B_TK);
end