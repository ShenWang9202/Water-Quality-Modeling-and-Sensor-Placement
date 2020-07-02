function index = findLowHeadSide(EnergyMatrixPipe,Head0)
Head1 = EnergyMatrixPipe.*Head0;
Head1 = abs(Head1);
IndexofNode = find(Head1~=0);
if(Head1(IndexofNode(1)) > Head1(IndexofNode(2)))
    index = IndexofNode(2);
else
    index = IndexofNode(1);
end
end