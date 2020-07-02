function [A,B,C] = ObtainDynamic(CurrentValue,IndexInVar,aux,ElementCount,q_B)
delta_t = CurrentValue.delta_t;
CurrentFlow = CurrentValue.CurrentFlow;
CurrentFlow = CurrentFlow';

CurrentNodeTankVolume = CurrentValue.CurrentNodeTankVolume;
PipeReactionCoeff = CurrentValue.PipeReactionCoeff;
Np = CurrentValue.Np;

JunctionMassMatrix = aux.JunctionMassMatrix;
TankMassMatrix = aux.TankMassMatrix;
MassEnergyMatrix = aux.MassEnergyMatrix;


PipeIndex = IndexInVar.PipeIndex;
PumpIndex = IndexInVar.PumpIndex;
ValveIndex = IndexInVar.ValveIndex;

JunctionCount= ElementCount.JunctionCount;
ReservoirCount = ElementCount.ReservoirCount;
TankCount = ElementCount.TankCount;
PipeCount = ElementCount.PipeCount;
PumpCount= ElementCount.PumpCount;
ValveCount = ElementCount.ValveCount;


JunctionCount = double(JunctionCount);
ReservoirCount = double(ReservoirCount);
TankCount = double(TankCount);
nodeCount = JunctionCount + ReservoirCount + TankCount;

NumberofSegment = Constants4Concentration.NumberofSegment;

% for junctions
[A_J, B_J] = ConstructMatrixForJunction(CurrentFlow,JunctionMassMatrix,ElementCount,IndexInVar,q_B);
% for reservoirs
A_R = ConstructMatrixForReservoir(ElementCount,IndexInVar);
% for tanks
[A_TK,B_TK,~] = ConstructMatrixForTank(delta_t,CurrentFlow,CurrentNodeTankVolume,TankMassMatrix,ElementCount,IndexInVar,aux,q_B);
% for Pipes
EnergyMatrixPipe= MassEnergyMatrix(PipeIndex,:);
A_P = ConstructMatrixForPipe1(delta_t,CurrentFlow,EnergyMatrixPipe,ElementCount,IndexInVar,aux,PipeReactionCoeff);
% for Pumps
EnergyMatrixPump= MassEnergyMatrix(PumpIndex,:);
A_M = ConstructMatrixForPump(EnergyMatrixPump,ElementCount,IndexInVar);
% for Valves
EnergyMatrixValve= MassEnergyMatrix(ValveIndex,:);
A_W = ConstructMatrixForValve(EnergyMatrixValve,ElementCount,IndexInVar);
% construct A;
A = [A_J;A_R;A_TK;A_P;A_M;A_W];
% construct B;
B_R = sparse(ReservoirCount,nodeCount);
B_P = sparse(NumberofSegment*PipeCount,nodeCount);
B_M = sparse(PumpCount,nodeCount);
B_W = sparse(ValveCount,nodeCount);
B = [B_J;B_R;B_TK;B_P;B_M;B_W];

NumberofX = double(JunctionCount + ReservoirCount + TankCount + ...
    PipeCount * NumberofSegment + PumpCount + ValveCount);
nx = NumberofX; % Number of states

C = generateC(nx);
end