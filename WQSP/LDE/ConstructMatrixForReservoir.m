function A_R = ConstructMatrixForReservoir(ElementCount,IndexInVar)
ReservoirCount = ElementCount.ReservoirCount;
NumberofX = IndexInVar.NumberofX;
Reservoir_CIndex = IndexInVar.Reservoir_CIndex;

A_Rervoir = [];
for i = 1:ReservoirCount
    A_Reservoir_i = zeros(1,NumberofX);
    A_Reservoir_i(1,Reservoir_CIndex(i)) = 1;
    A_Rervoir = [A_Rervoir;A_Reservoir_i];
end
A_R = sparse(A_Rervoir);
end