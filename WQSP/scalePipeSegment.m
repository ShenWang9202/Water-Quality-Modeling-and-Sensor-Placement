function x_scaled = scalePipeSegment(x,IndexInVar,NumberofSegment4PipesOld,ElementCount,NumberofSegment4PipesNew)

Junction_CIndex = IndexInVar.Junction_CIndex;
Reservoir_CIndex = IndexInVar.Reservoir_CIndex;
Tank_CIndex = IndexInVar.Tank_CIndex;
Pipe_CStartIndex = IndexInVar.Pipe_CStartIndex;
Pump_CIndex = IndexInVar.Pump_CIndex;
Valve_CIndex = IndexInVar.Valve_CIndex;
PipeCount = ElementCount.PipeCount;

x_scaled = [];

x_scaled = [x_scaled; x(Junction_CIndex,1); x(Reservoir_CIndex,1);  x(Tank_CIndex,1)];
for j = 1:PipeCount
    Indexrange = Pipe_CStartIndex(j):Pipe_CStartIndex(j) + NumberofSegment4PipesOld(j)-1;
    X_pipe = x(Indexrange,1);
%     newPipeSegNumber = length(Indexrange)/1.5;
    newPipeSegNumber = NumberofSegment4PipesNew(j);
    X_pipe_scaled = scaleUpDown(X_pipe,newPipeSegNumber);
    x_scaled = [x_scaled; X_pipe_scaled];
end
x_scaled = [x_scaled; x(Pump_CIndex,1);  x(Valve_CIndex,1)];

end