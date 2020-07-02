function A_Pipe = ConstructMatrixForPipeNew_NoneFirstSeg(delta_t,CurrentFlow,EnergyMatrixPipe,ElementCount,IndexInVar,aux,PipeReactionCoeff_perSec)
%NodeTankVolume = aux.NodeTankVolume;
% NumberofSegment = aux.NumberofSegment;
NumberofSegment4Pipes = aux.NumberofSegment4Pipes;
LinkLengthPipe = aux.LinkLengthPipe;
LinkDiameterPipe = aux.LinkDiameterPipe;
NumberofX = IndexInVar.NumberofX;
PipeIndex = IndexInVar.PipeIndex;
PipeCount = ElementCount.PipeCount;
Pipe_CIndex = IndexInVar.Pipe_CIndex;
Pipe_CStartIndex = IndexInVar.Pipe_CStartIndex;

% step 1 find alpha for each pipe
% delta_x = LinkLengthPipe./NumberofSegment;
delta_x = LinkLengthPipe./NumberofSegment4Pipes;

CurrentFlowPipe = CurrentFlow(PipeIndex,:);
CurrentFlowPipe = CurrentFlowPipe/Constants4Concentration.GPMperCFS;
LinkDiameterPipe = LinkDiameterPipe'/Constants4Concentration.FT2Inch;
% don't use the one provided by EPANET, we need the direction of Velocity in pipes
CurrentVelocityPipe = CurrentFlowPipe./(Constants4Concentration.pi*(0.5.*LinkDiameterPipe).^2);
alpha = CurrentVelocityPipe.*delta_t./delta_x';

% step 2 find the Index of Node at both end of that link
IndexofNode_pipe =  findIndexofNode_Link(EnergyMatrixPipe);
% Since all these indexes in IndexofNode_pipe are either junction,
% reservoir, or tanks, so the corresponding Concerntration Index is exactly
% the same. Hence, IndexofNode_pipe is the Concerntration Index we are
% looking for.

minPipe_CIndex = min(Pipe_CStartIndex);
numberofNodes = minPipe_CIndex - 1;
% step 3 construction matrix
% A_Pipe = sparse(NumberofSegment*PipeCount,NumberofX);
A_Pipe = sparse(sum(NumberofSegment4Pipes),NumberofX);
for i = 1:PipeCount
    alpha_i = alpha(i);
    alpha_neg1 =  0.5 * alpha_i *(1+alpha_i);
    % need to consider the PipeBulkReactionCoeff (assuming first order)
    % be careful, always make sure alpha_zero is [0,1], if alpha_i is
    % negative, which means the flow direction is opposite as assumed, we
    % need to an absolute function
    alpha_zero =  (1-abs(alpha_i)^2) + PipeReactionCoeff_perSec(i)*delta_t ;
    alpha_pos1 =  -0.5 * alpha_i *(1-alpha_i);
    A_Pipe_i = sparse(NumberofSegment4Pipes(i),NumberofX);
    %     BasePipe_CIndex = minPipe_CIndex + (i-1)*NumberofSegment - 1;
    BasePipe_CIndex = Pipe_CStartIndex(i)- 1;
    %From second segment
    for seg =  2:(NumberofSegment4Pipes(i)-1)
        A_Pipe_i(seg,BasePipe_CIndex + seg - 1 ) = alpha_neg1;
        A_Pipe_i(seg,BasePipe_CIndex + seg ) = alpha_zero;
        A_Pipe_i(seg,BasePipe_CIndex + seg + 1 ) = alpha_pos1;
    end
    % last segment
    seg = NumberofSegment4Pipes(i);
    A_Pipe_i(seg,BasePipe_CIndex + seg-1) = alpha_neg1;
    A_Pipe_i(seg,BasePipe_CIndex + seg) = alpha_zero;
    % here, need to use the index of node connecting the
    % last segement
    A_Pipe_i(seg,IndexofNode_pipe(i,2)) = alpha_pos1;
    %A_Pipe(((i-1)*NumberofSegment + 1):(i*NumberofSegment),:) = A_Pipe_i;
    
    range = Pipe_CStartIndex(i):Pipe_CStartIndex(i) + NumberofSegment4Pipes(i)-1;
    range = range - numberofNodes;
    A_Pipe(range,:) = A_Pipe_i;
end
end