function x0 = InitialConcentration(x0,C0,MassEnergyMatrix,Head0,IndexInVar,ElementCount,NumberofSegmentsEachPipe)
NumberofSegment = Constants4Concentration.NumberofSegment;
JunctionIndexInOrder = IndexInVar.JunctionIndexInOrder; 
Junction_CIndex = IndexInVar.Junction_CIndex;
ReservoirIndexInOrder = IndexInVar.ReservoirIndexInOrder;
Reservoir_CIndex = IndexInVar.Reservoir_CIndex;
TankIndexInOrder = IndexInVar.TankIndexInOrder;
Tank_CIndex = IndexInVar.Tank_CIndex;

PipeIndex = IndexInVar.PipeIndex;
PumpIndex = IndexInVar.PumpIndex;
ValveIndex = IndexInVar.ValveIndex;

Pipe_CIndex = IndexInVar.Pipe_CIndex;
Pump_CIndex = IndexInVar.Pump_CIndex;
Valve_CIndex = IndexInVar.Valve_CIndex;

PipeCount = ElementCount.PipeCount;
PumpCount = ElementCount.PumpCount;
ValveCount = ElementCount.ValveCount;

% for nodes 
x0(Junction_CIndex) = C0(JunctionIndexInOrder);
x0(Reservoir_CIndex) = C0(ReservoirIndexInOrder);
x0(Tank_CIndex) = C0(TankIndexInOrder);

Pipe_CStartIndex = IndexInVar.Pipe_CStartIndex;


% for pipes, make it to the low head side
BasePipe_CIndex = min(Pipe_CIndex);
EnergyMatrixPipe = MassEnergyMatrix(PipeIndex,:);
for i = 1:PipeCount
    LowHeadNodeIndex = findLowHeadSide(EnergyMatrixPipe(i,:),Head0);
%    if(LowHeadNodeIndex in IndexInVar.TankIndexInOrder)

% Same number of segments
    %x0(BasePipe_CIndex + (i-1)*NumberofSegment:BasePipe_CIndex+i*NumberofSegment - 1) = C0(LowHeadNodeIndex);
    
% Different number of segments
    range = Pipe_CStartIndex(i):Pipe_CStartIndex(i) + NumberofSegmentsEachPipe(i)-1;
    x0(range) = C0(LowHeadNodeIndex);
end
EnergyMatrixPump = MassEnergyMatrix(PumpIndex,:);

for i = 1:PumpCount
    % find suction side
    indexofNode_Pump = find(EnergyMatrixPump~=0);
    x0(Pump_CIndex(i)) = 0.5*(C0(indexofNode_Pump(1))+C0(indexofNode_Pump(2)));
end


EnergyMatrixValve = MassEnergyMatrix(ValveIndex,:);
for i = 1:ValveCount
    % foind suction side
    indexofNode_Valve = find(EnergyMatrixValve~=0);
    x0(Valve_CIndex(i)) = 0.5*(C0(indexofNode_Valve(1))+C0(indexofNode_Valve(2)));
end

end