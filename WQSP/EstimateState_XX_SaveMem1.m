function XX = EstimateState_XX_SaveMem1(CurrentValue,aux,ElementCount,PreviousValue,Hq_min)

PreviousNumberofSegment4Pipes = PreviousValue.PreviousNumberofSegment4Pipes;
x_estimated = PreviousValue.X_estimated;
NumberofSegment4Pipes = aux.NumberofSegment4Pipes;
SystemDynamicMatrix = CurrentValue.SystemDynamicMatrix;
Np = CurrentValue.Np;
A = SystemDynamicMatrix.A;

lenA = length(A);
[lenX,~] = size(x_estimated);

if(lenA ~= lenX)
    IndexInVarOld = PreviousValue.IndexInVarOld;
    x_estimated = scalePipeSegment(x_estimated,IndexInVarOld,PreviousNumberofSegment4Pipes,ElementCount,NumberofSegment4Pipes);
end

% We need to know the states 5 mins ago, apply the system dynamic for
% the past 5 mins to obtain the estimation of current value.
% Hq_min = Constants4Concentration.Hq_min;
delta_t = CurrentValue.delta_t;
% how many steps in Hq_min min
% SetTimeParameter = Hq_min * Constants4Concentration.MinInSecond/delta_t;
% Np = round(SetTimeParameter);


XX = zeros(lenA,Hq_min);
IndexofApplyingU = [];
for i = 1:Hq_min
    IndexofApplyingU = [IndexofApplyingU round(i * Constants4Concentration.MinInSecond/delta_t)];
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