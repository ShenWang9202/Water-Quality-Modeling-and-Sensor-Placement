function [IndexInVar,aux] = updateStructures(IndexInVar,aux,ElementCount,NumberofSegment4Pipes)
 
JunctionCount = ElementCount.JunctionCount;
ReservoirCount = ElementCount.ReservoirCount;
TankCount = ElementCount.TankCount;
PipeCount = ElementCount.PipeCount;
PumpCount = ElementCount.PumpCount;
ValveCount = ElementCount.ValveCount;

% Pipes with different number of segments
NumberofX = double(JunctionCount + ReservoirCount + TankCount + ...
    sum(NumberofSegment4Pipes) + PumpCount + ValveCount);


%% Index of each element in x (concentration);

% Junction
Junction_CIndex = 1:JunctionCount;
BaseCount4Next = JunctionCount;
% Reservoir
Reservoir_CIndex = (BaseCount4Next+1):(BaseCount4Next + ReservoirCount);
BaseCount4Next = BaseCount4Next + ReservoirCount;
% Tank
Tank_CIndex = (BaseCount4Next+1):(BaseCount4Next + TankCount);
BaseCount4Next = BaseCount4Next + TankCount;
% Pipe Concentration index in x
Pipe_CIndex = (BaseCount4Next+1):(BaseCount4Next + sum(NumberofSegment4Pipes));
Pipe_CStartIndex = zeros(1,PipeCount);
Pipe_CStartIndex(1) = BaseCount4Next+1;

for i = 2:PipeCount
    Pipe_CStartIndex(i) = Pipe_CStartIndex(i-1) + NumberofSegment4Pipes(i-1);
end
BaseCount4Next = BaseCount4Next + sum(NumberofSegment4Pipes);

% Pump
Pump_CIndex = (BaseCount4Next+1):(BaseCount4Next + PumpCount);
BaseCount4Next = BaseCount4Next + PumpCount;
% Valve
Valve_CIndex = (BaseCount4Next+1):(BaseCount4Next + ValveCount);

%% update IndexInVar
IndexInVar.NumberofX = NumberofX;
IndexInVar.Junction_CIndex = Junction_CIndex;
IndexInVar.Reservoir_CIndex = Reservoir_CIndex;
IndexInVar.Tank_CIndex = Tank_CIndex;
IndexInVar.Pipe_CIndex = Pipe_CIndex;
IndexInVar.Pipe_CStartIndex = Pipe_CStartIndex;
IndexInVar.Pump_CIndex = Pump_CIndex;
IndexInVar.Valve_CIndex = Valve_CIndex;

% update aux
aux.NumberofSegment4Pipes = NumberofSegment4Pipes;
