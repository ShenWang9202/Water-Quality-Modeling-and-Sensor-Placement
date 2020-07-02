function IndexofNode_Link =  findIndexofNode_Link(EnergyMatrixLink)

% This EnergyMatrixLink has to be the one (with real flow direction) after updating flow direction;

[m,~] = size(EnergyMatrixLink);
IndexofNode_Link = zeros(m,2);
for i = 1:m
    Link_iConnectMatrix = EnergyMatrixLink(i,:);
    IndexofNode_i = find(Link_iConnectMatrix == -1);
    IndexofNode_j = find(Link_iConnectMatrix == 1);
    IndexofNode_Link(i,1) = IndexofNode_i;
    IndexofNode_Link(i,2) = IndexofNode_j;
end

