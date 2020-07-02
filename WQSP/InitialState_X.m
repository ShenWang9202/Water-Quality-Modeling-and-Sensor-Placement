function x0 = InitialState_X(CurrentValue,IndexInVar,aux,ElementCount,C0)
MassEnergyMatrix = aux.MassEnergyMatrix;
CurrentHead = CurrentValue.CurrentHead;
NumberofSegmentsEachPipe = aux.NumberofSegment4Pipes;
x0 = zeros(IndexInVar.NumberofX,1);
x0 = InitialConcentration(x0,C0,MassEnergyMatrix,CurrentHead,IndexInVar,ElementCount,NumberofSegmentsEachPipe);
end