function A_Pipe = ConstructMatrixForPipeNew_NoneFirstSeg_SpeedUpUp(delta_t,CurrentFlow,EnergyMatrixPipe,ElementCount,IndexInVar,aux,PipeReactionCoeff_perSec)
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

numberofNodes = min(Pipe_CStartIndex) - 1;
% step 3 construction matrix
 
% this is not considering the first segment of a pipe
% NoneZeroI = (sum(NumberofSegment4Pipes)-PipeCount);
% this is considering the first seg
NoneZeroI = (sum(NumberofSegment4Pipes));

% the umber of 
NoneZero = NoneZeroI * 3;

iVectorPrepare = zeros(1,NoneZeroI);
vVectorPrepare = zeros(PipeCount,3);
jVectorPrepare = zeros(3,NoneZeroI);


jVector = zeros(1,NoneZero);
tempI = 1;
tempJ = 1;
tempV = 1;


for i = 1:PipeCount
    alpha_i = alpha(i);
    alpha_neg1 =  0.5 * alpha_i *(1+alpha_i);
    alpha_zero =  (1-abs(alpha_i)^2) + PipeReactionCoeff_perSec(i)*delta_t ;
    alpha_pos1 =  -0.5 * alpha_i *(1-alpha_i);
    vVect = [alpha_neg1 alpha_zero alpha_pos1];
    % this is not considering the first segment of a pipe
%     secondSegment = Pipe_CStartIndex(i) + 1;
%     lastSegment = Pipe_CStartIndex(i) + NumberofSegment4Pipes(i) - 1;
%     iVectorPrepare(tempI:(tempI + NumberofSegment4Pipes(i)-2)) = secondSegment:lastSegment;
%     tempI = tempI + NumberofSegment4Pipes(i) - 1;
    % this is considering the first seg
    firstSegment = Pipe_CStartIndex(i);
    lastSegment = Pipe_CStartIndex(i) + NumberofSegment4Pipes(i) - 1;
    iVectorPrepare(tempI:(tempI + NumberofSegment4Pipes(i)-1)) = firstSegment:lastSegment;
    tempI = tempI + NumberofSegment4Pipes(i);

    vVectorPrepare(tempV,:) = vVect;
    tempV = tempV + 1;

end

% Generate iVector
iVector = repmat(iVectorPrepare,3,1);
iVector = reshape(iVector,1,[]) - numberofNodes;

% Generate jVector
jVectorPrepare(1,:) = iVectorPrepare - 1;
jVectorPrepare(2,:) = iVectorPrepare;
jVectorPrepare(3,:) = iVectorPrepare + 1;
 % this is not considering the first segment of a pipe
% tempJ = 1;
% for i = 1:PipeCount
%     jVectorPrepare(3,tempJ + NumberofSegment4Pipes(i)-2) = IndexofNode_pipe(i,2);
%     tempJ = tempJ + NumberofSegment4Pipes(i) - 1;
% end
% jVector = reshape(jVectorPrepare,1,[]);
% this is considering the first seg
tempJ = 1;
for i = 1:PipeCount
    jVectorPrepare(1,tempJ) = IndexofNode_pipe(i,1);
    jVectorPrepare(3,tempJ + NumberofSegment4Pipes(i)-1) = IndexofNode_pipe(i,2);
    tempJ = tempJ + NumberofSegment4Pipes(i);
end
jVector = reshape(jVectorPrepare,1,[]);

% Generate vVector
vVector = zeros(NoneZeroI,3);
for i = 1:3
    % this is not considering the first segment of a pipe
%     vVector(:,i) = repelem(vVectorPrepare(:,i),NumberofSegment4Pipes-1);
    % this is considering the first seg
    vVector(:,i) = repelem(vVectorPrepare(:,i),NumberofSegment4Pipes);
end
vVector = reshape(vVector',1,[]);

A_Pipe = sparse(iVector,jVector,vVector,sum(NumberofSegment4Pipes),NumberofX);
end