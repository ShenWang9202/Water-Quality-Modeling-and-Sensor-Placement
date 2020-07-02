function XX = EstimateState_XX_SaveMem(CurrentValue,IndexInVar,aux,ElementCount,C0,PreviousValue)
NumberofX = IndexInVar.NumberofX;
MassEnergyMatrix = aux.MassEnergyMatrix;
tInMin = CurrentValue.tInMin;
XX = [];

if(tInMin==0)
    x0 = zeros(NumberofX,1);
    CurrentHead = CurrentValue.CurrentHead;
    NumberofSegmentsEachPipe = aux.NumberofSegment4Pipes;
    x0 = InitialConcentration(x0,C0,MassEnergyMatrix,CurrentHead,IndexInVar,ElementCount,NumberofSegmentsEachPipe);
    x_estimated = x0;
    XX = x_estimated;
else
    Previous_delta_t = PreviousValue.PreviousDelta_t;
    PreviousSystemDynamicMatrix = PreviousValue.PreviousSystemDynamicMatrix;
    x_estimated = PreviousValue.X_estimated;
    PreviousNumberofSegment4Pipes = PreviousValue.PreviousNumberofSegment4Pipes;
    NumberofSegment4Pipes = aux.NumberofSegment4Pipes;
    A = PreviousSystemDynamicMatrix.A;
    
    lenA = length(A);
    [lenX,~] = size(x_estimated);
    
    if(lenA ~= lenX)
        IndexInVarOld = PreviousValue.IndexInVarOld;
        x_estimated = scalePipeSegment(x_estimated,IndexInVarOld,PreviousNumberofSegment4Pipes,ElementCount,NumberofSegment4Pipes);
    end

    % We need to know the states 5 mins ago, apply the system dynamic for
    % the past 5 mins to obtain the estimation of current value.
    Hq_min = Constants4Concentration.Hq_min;
    
    % how many steps in Hq_min min
    SetTimeParameter = Hq_min * Constants4Concentration.MinInSecond/Previous_delta_t;
    Np = round(SetTimeParameter);
    
    XX = zeros(lenX,Hq_min);
    
    IndexofApplyingU = [];
    for i = 1:Hq_min
        IndexofApplyingU = [IndexofApplyingU round(i * Constants4Concentration.MinInSecond/Previous_delta_t)];
    end
    
    indexEachMin  = 1;
    for i = 1:Np
        x_estimated = A * x_estimated; % don't consider control
        if( i == IndexofApplyingU(indexEachMin))
            XX(:,indexEachMin) = x_estimated;
            indexEachMin = indexEachMin + 1;
        end
    end
end
end