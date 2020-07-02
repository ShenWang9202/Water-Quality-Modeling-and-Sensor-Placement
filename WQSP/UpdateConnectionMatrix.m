function MatrixStruct =  UpdateConnectionMatrix(IndexInVar,aux,NegativePipeIndex)

NodeJunctionIndex = IndexInVar.JunctionIndexInOrder;
NodeTankIndex = IndexInVar.TankIndexInOrder;

NodeNameID = aux.NodeNameID; % the Name of each node   head of each node
LinkNameID = aux.LinkNameID; % the Name of each pipe   flow of each pipe

NodesConnectingLinksID = aux.NodesConnectingLinksID; %

[m,n] = size(NodesConnectingLinksID);
NodesConnectingLinksIndex = zeros(m,n);

% if the flow is negative, we need swap the order in
% NodesConnectingLinksID due to the wrong assumption of flow direction.
[m_Neg,~] = size(NegativePipeIndex);

for i = 1:m_Neg
    temp = NodesConnectingLinksID{NegativePipeIndex(i),1};
    NodesConnectingLinksID{NegativePipeIndex(i),1} = NodesConnectingLinksID{NegativePipeIndex(i),2};
    NodesConnectingLinksID{NegativePipeIndex(i),2} = temp;
end

% Find the NodesConnectingLinksIndex according to the new NodesConnectingLinksID

for i = 1:m
    for j = 1:n
        NodesConnectingLinksIndex(i,j) = find(strcmp(NodeNameID,NodesConnectingLinksID{i,j}));
    end
end
%NodesConnectingLinksIndex
% Generate MassEnergyMatrix
[m1,n1] = size(NodeNameID);
[m2,n2] = size(LinkNameID);
MassEnergyMatrix = zeros(n2,n1);

for i = 1:m
    MassEnergyMatrix(i,NodesConnectingLinksIndex(i,1)) = -1;
    MassEnergyMatrix(i,NodesConnectingLinksIndex(i,2))= 1;
end

%% Generate Mass Matrix
% For nodes like source or tanks shouldn't have mass equations.
 
JunctionMassMatrix = MassEnergyMatrix(:,NodeJunctionIndex)';
% [RowNeg,ColNeg] = find(JunctionMassMatrix == -1);
% [~,m] = size(RowNeg);
% for i = 1:m
%     JunctionMassMatrix(RowNeg(i),ColNeg(i)) = 0;
% end

% set all -1 to 0 in JunctionMassMatrix (only keep the links flowing in junctions)
JunctionMassMatrix(JunctionMassMatrix<0) = 0;

TankMassMatrix = MassEnergyMatrix(:,NodeTankIndex)';

MatrixStruct = struct('MassEnergyMatrix',{MassEnergyMatrix},...
    'JunctionMassMatrix',JunctionMassMatrix,...
    'TankMassMatrix',TankMassMatrix);

end