function [A_Pipe_New,B_Pipe_New] = ConstructMatrixForPipeNew_FirstSeg(EnergyMatrixPipe,ElementCount,IndexInVar,A_P,UpstreamNode_Amatrix,UpstreamNode_Bmatrix,B_P)

Pipe_CStartIndex = IndexInVar.Pipe_CStartIndex;
%find the Index of Node at both end of that link
IndexofNode_pipe =  findIndexofNode_Link(EnergyMatrixPipe);
% Since all these indexes in IndexofNode_pipe are either junction,
% reservoir, or tanks, so the corresponding Concerntration Index is exactly
% the same. Hence, IndexofNode_pipe is the Concerntration Index we are
% looking for.

PipeCount = ElementCount.PipeCount;
minPipe_CIndex = min(Pipe_CStartIndex);
numberofNodes = minPipe_CIndex - 1;
for i = 1:PipeCount
    %here, need to use the index of node connecting the first segement
    UpStreamNodeIndexOfPipe = IndexofNode_pipe(i,1);
    FirstSegmentIndexofPipe = Pipe_CStartIndex(i) - numberofNodes;
    A_P(FirstSegmentIndexofPipe,:) = UpstreamNode_Amatrix(UpStreamNodeIndexOfPipe,:) ;
    B_P(FirstSegmentIndexofPipe,:) = UpstreamNode_Bmatrix(UpStreamNodeIndexOfPipe,:) ;
end
A_Pipe_New = A_P;
B_Pipe_New = B_P;