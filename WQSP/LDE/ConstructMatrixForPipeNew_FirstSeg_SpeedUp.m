function [A_Pipe_New,B_Pipe_New] = ConstructMatrixForPipeNew_FirstSeg_SpeedUp(EnergyMatrixPipe,ElementCount,IndexInVar,A_P,UpstreamNode_Amatrix,UpstreamNode_Bmatrix,B_P)

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
iVector = 1:PipeCount;
jVector = zeros(1,PipeCount);
vVector = ones(1,PipeCount);

iVectorFirstSeg =  zeros(PipeCount,1);
for i = 1:PipeCount
    %here, need to use the index of node connecting the first segement
    jVector(i) = IndexofNode_pipe(i,1);
    iVectorFirstSeg(i) = Pipe_CStartIndex(i) - numberofNodes;
end

selectMatrix = sparse(iVector,jVector,vVector,PipeCount,numberofNodes);

firstSegMatrix = selectMatrix * UpstreamNode_Amatrix;
firstSegMatrix = firstSegMatrix';
[jVectorFirstSeg,iVectorFirstSeg1,vVectorFirstSeg] = find(firstSegMatrix);
[~,~,ic] = unique(iVectorFirstSeg1);
counts = accumarray(ic,1);
iVectorFirstSegRep = repelem(iVectorFirstSeg,counts);

[m,n] = size(A_P);
A_Pipe_New = sparse(iVectorFirstSegRep,jVectorFirstSeg,vVectorFirstSeg,m,n);
A_Pipe_New = A_Pipe_New + A_P;

%%
firstSegMatrix = selectMatrix * UpstreamNode_Bmatrix;
firstSegMatrix = firstSegMatrix';
[jVectorFirstSeg,iVectorFirstSeg1,vVectorFirstSeg] = find(firstSegMatrix);

iVectorFirstSegReduced = iVectorFirstSeg(iVectorFirstSeg1);

% [~,~,ic] = unique(iVectorFirstSeg1);
% counts = accumarray(ic,1);
% iVectorFirstSegRep = repelem(iVectorFirstSeg,counts);

[m,n] = size(B_P);
B_Pipe_New = sparse(iVectorFirstSegReduced,jVectorFirstSeg,vVectorFirstSeg,m,n);
B_Pipe_New = B_Pipe_New + B_P;


