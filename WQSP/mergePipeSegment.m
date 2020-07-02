function X_Min_Average = mergePipeSegment(XX_estimated,IndexInVar,aux,ElementCount)
% find average data;
MassEnergyMatrix = aux.MassEnergyMatrix;
NumberofSegment4Pipes = aux.NumberofSegment4Pipes;
X_Min = XX_estimated;
[m,n] = size(X_Min);

NumberofElement = IndexInVar.NumberofElement;
JunctionIndexInOrder = IndexInVar.JunctionIndexInOrder;
Junction_CIndex = IndexInVar.Junction_CIndex;

ReservoirIndexInOrder = IndexInVar.ReservoirIndexInOrder;
Reservoir_CIndex = IndexInVar.Reservoir_CIndex;

Tank_CIndex = IndexInVar.Tank_CIndex;
TankIndexInOrder = IndexInVar.TankIndexInOrder;

Pipe_CIndex = IndexInVar.Pipe_CIndex;
PipeIndexInOrder = IndexInVar.PipeIndexInOrder;
PipeIndex = IndexInVar.PipeIndex;

Pipe_CStartIndex = IndexInVar.Pipe_CStartIndex;

PumpIndexInOrder = IndexInVar.PumpIndexInOrder;
Pump_CIndex = IndexInVar.Pump_CIndex;
PumpIndex = IndexInVar.PumpIndex;


ValveIndexInOrder = IndexInVar.ValveIndexInOrder;
Valve_CIndex = IndexInVar.Valve_CIndex;
ValveIndex = IndexInVar.ValveIndex;

JunctionCount = ElementCount.JunctionCount;
PipeCount = ElementCount.PipeCount;

PumpCount = ElementCount.PumpCount;
ValveCount = ElementCount.ValveCount;


X_Min_Average = zeros(NumberofElement,n);
basePipeCIndex = min(Pipe_CIndex);
for i = 1:n
    X_Min_Average(JunctionIndexInOrder,i) = X_Min(Junction_CIndex,i);
    X_Min_Average(ReservoirIndexInOrder,i) = X_Min(Reservoir_CIndex,i);
    X_Min_Average(TankIndexInOrder,i) = X_Min(Tank_CIndex,i);
    for j = 1:PipeCount
    Indexrange = Pipe_CStartIndex(j):Pipe_CStartIndex(j) + NumberofSegment4Pipes(j)-1;
    X_Min_Average(PipeIndexInOrder(j),i) = mean(X_Min(Indexrange,i));
    end
    
    NodeIndex4EachLink = findIndexofNode_Link(MassEnergyMatrix);
    NodeIndex4EachPump = NodeIndex4EachLink(PumpIndex,:);
    NodeIndex4EachValve = NodeIndex4EachLink(ValveIndex,:);
    for ithPump = 1:PumpCount
        X_Min_Average(PumpIndexInOrder,i) = (X_Min(NodeIndex4EachPump(ithPump,1),i) +  X_Min(NodeIndex4EachPump(ithPump,2),i))*0.5;
    end
    for ithValve = 1:ValveCount
        X_Min_Average(ValveIndexInOrder,i) = (X_Min(NodeIndex4EachValve(ithValve,1),i) +  X_Min(NodeIndex4EachValve(ithValve,2),i))*0.5;
    end
    
end