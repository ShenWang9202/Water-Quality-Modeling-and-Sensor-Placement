function A_Pipe = ConstructMatrixForPipe1(delta_t,CurrentFlow,EnergyMatrixPipe,ElementCount,IndexInVar,aux,PipeReactionCoeff)
%NodeTankVolume = aux.NodeTankVolume;
NumberofSegment = aux.NumberofSegment;
LinkLengthPipe = aux.LinkLengthPipe;
LinkDiameterPipe = aux.LinkDiameterPipe;
NumberofX = IndexInVar.NumberofX;
PipeIndex = IndexInVar.PipeIndex;
PipeCount = ElementCount.PipeCount;
Pipe_CIndex = IndexInVar.Pipe_CIndex;

% step 1 find alpha for each pipe
delta_x = LinkLengthPipe./NumberofSegment;
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

minPipe_CIndex = min(Pipe_CIndex);
% step 3 construction matrix
A_Pipe = sparse(NumberofSegment*PipeCount,NumberofX);
for i = 1:PipeCount
    alpha_i = alpha(i);
    alpha_neg1 =  0.5 * alpha_i *(1+alpha_i);
    % need to consider the PipeBulkReactionCoeff (assuming first order)
    % be careful, always make sure alpha_zero is [0,1], if alpha_i is
    % negative, which means the flow direction is opposite as assumed, we
    % need to an absolute function
    alpha_zero =  (1-abs(alpha_i)^2) + PipeReactionCoeff(i) ;
    alpha_pos1 =  -0.5 * alpha_i *(1-alpha_i);
    A_Pipe_i = sparse(NumberofSegment,NumberofX);
    BasePipe_CIndex = minPipe_CIndex + (i-1)*NumberofSegment - 1;
    % first segement,  
    seg = 1;
    % here, need to use the index of node connecting the
    % first segement
    A_Pipe_i(seg,IndexofNode_pipe(i,1)) = alpha_neg1;
    A_Pipe_i(seg,BasePipe_CIndex + seg ) = alpha_zero;
    A_Pipe_i(seg,BasePipe_CIndex + seg + 1 ) = alpha_pos1;
    for seg =  2:(NumberofSegment-1)
        A_Pipe_i(seg,BasePipe_CIndex + seg - 1 ) = alpha_neg1;
        A_Pipe_i(seg,BasePipe_CIndex + seg ) = alpha_zero;
        A_Pipe_i(seg,BasePipe_CIndex + seg + 1 ) = alpha_pos1;
    end
    % last segment
    seg = NumberofSegment;
    A_Pipe_i(seg,BasePipe_CIndex + seg-1) = alpha_neg1;
    A_Pipe_i(seg,BasePipe_CIndex + seg) = alpha_zero;
    % here, need to use the index of node connecting the
    % last segement
    A_Pipe_i(seg,IndexofNode_pipe(i,2)) = alpha_pos1;
    A_Pipe(((i-1)*NumberofSegment + 1):(i*NumberofSegment),:) = A_Pipe_i;
end
end