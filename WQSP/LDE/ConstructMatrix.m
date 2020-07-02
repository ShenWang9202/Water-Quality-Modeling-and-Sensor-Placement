function [A,NodeTankVolume_Next] = ConstructMatrix(delta_t,CurrentVelocityPipe,CurrentNodeTankVolume,CurrentNodeNetFlowTank,aux,IndexInVar,ElementCount)
%CurrentNodeNetFlowTank = aux.NodeNetFlowTank;
JunctionActualDemand = aux.JunctionActualDemand;
%NodeTankVolume = aux.NodeTankVolume;
NumberofSegment = aux.NumberofSegment;
LinkLengthPipe = aux.LinkLengthPipe;
TankBulkReactionCoeff = aux.TankBulkReactionCoeff;
PipeReactionCoeff = aux.PipeReactionCoeff;
%
Junction_CIndex = IndexInVar.Junction_CIndex;
Reservoir_CIndex = IndexInVar.Reservoir_CIndex;
Tank_CIndex = IndexInVar.Tank_CIndex;
Pipe_CIndex = IndexInVar.Pipe_CIndex;
Pump_CIndex = IndexInVar.Pump_CIndex;
Valve_CIndex = IndexInVar.Valve_CIndex;


PipeIndexInOrder = IndexInVar.PipeIndexInOrder;

%
JunctionCount = ElementCount.JunctionCount;
ReservoirCount = ElementCount.ReservoirCount;
TankCount = ElementCount.TankCount;
PipeCount = ElementCount.PipeCount;
PumpCount = ElementCount.PumpCount;
ValveCount = ElementCount.ValveCount;

NodeTankVolume_Next = CurrentNodeTankVolume + delta_t.*CurrentNodeNetFlowTank./Constants4Concentration.GPMperCFS;
NumberofX = IndexInVar.NumberofX;
%A = zeros(NumberofX,NumberofX);

% dont consider topology at first, only for 3 nodes.

% concentration at junction update
A_J = zeros(JunctionCount,NumberofX);
A_J(Pump_CIndex) = 1;
% concentration at reservoir update
A_R = zeros(ReservoirCount,NumberofX);
A_R(Reservoir_CIndex) = 1;

% concentration at tanks update
A_TK = zeros(TankCount,NumberofX);
A_TK(Tank_CIndex) = (CurrentNodeTankVolume + delta_t.*TankBulkReactionCoeff)./NodeTankVolume_Next;
% last pipe segment connected to tanks
A_TK(max(Pipe_CIndex)) = (delta_t.*CurrentNodeNetFlowTank)./NodeTankVolume_Next;



% concentration through pipes update

% step 1 find alpha for each pipe
delta_x = LinkLengthPipe./NumberofSegment;
alpha = CurrentVelocityPipe.*delta_t./delta_x;

minPipe_CIndex = min(Pipe_CIndex);
% A_Pipe = zeros(PipeCount*NumberofSegment,NumberofX);
A_Pipe = [];
for i = 1:PipeCount
    alpha_i = alpha(i);
    alpha_neg1 =  0.5 * alpha_i *(1+alpha_i);
    % need to consider the PipeBulkReactionCoeff (assuming first order)
    alpha_zero =  (1-alpha_i)^2 + PipeReactionCoeff(i) ;
    alpha_pos1 =  -0.5 * alpha_i *(1-alpha_i);
    A_Pipe_i = zeros(NumberofSegment,NumberofX);
    BasePipe_CIndex = minPipe_CIndex + (i-1)*NumberofSegment - 1;
    seg = 1;
    % first special
    A_Pipe_i(seg,Junction_CIndex) = alpha_neg1;
    A_Pipe_i(seg,BasePipe_CIndex + seg) = alpha_zero;
    A_Pipe_i(seg,BasePipe_CIndex + seg + 1) = alpha_pos1;
    for seg =  2:(NumberofSegment-1)
        A_Pipe_i(seg,BasePipe_CIndex + seg - 1) = alpha_neg1;
        A_Pipe_i(seg,BasePipe_CIndex + seg) = alpha_zero;
        A_Pipe_i(seg,BasePipe_CIndex + seg + 1) = alpha_pos1;
    end
    % last special
    seg = NumberofSegment;
    A_Pipe_i(seg,BasePipe_CIndex + seg-1) = alpha_neg1;
    A_Pipe_i(seg,BasePipe_CIndex + seg) = alpha_zero;
    A_Pipe_i(seg,Tank_CIndex) = alpha_pos1;
    
    A_Pipe = [A_Pipe;A_Pipe_i];
end

% concentration at reservoir update
A_Pump = zeros(PumpCount,NumberofX);
A_Pump(Reservoir_CIndex) = 0.5;
A_Pump(Junction_CIndex) = 0.5;

A = [A_J;A_R;A_TK;A_Pipe;A_Pump];

end