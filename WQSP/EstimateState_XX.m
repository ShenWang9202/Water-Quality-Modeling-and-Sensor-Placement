function [x_estimated,XX] = EstimateState_XX(CurrentValue,IndexInVar,aux,ElementCount,q_B,tInMin,C0,PreviousValue)
NumberofX = IndexInVar.NumberofX;
MassEnergyMatrix = aux.MassEnergyMatrix;
XX = [];
if(tInMin==0)
    x0 = zeros(NumberofX,1);
    CurrentHead = CurrentValue.CurrentHead;
    %Head0 = Head(1,:);
    % Something wrong with this intial function with 8-node network
    x0 = InitialConcentration(x0,C0,MassEnergyMatrix,CurrentHead,IndexInVar,ElementCount);
    x_estimated = x0;
    XX = x_estimated;
else
    PreviousDelta_t = PreviousValue.PreviousDelta_t;
    PreviousSystemDynamicMatrix = PreviousValue.PreviousSystemDynamicMatrix;
    X_estimated = PreviousValue.X_estimated;
    U_C_B_eachStep = PreviousValue.U_C_B_eachStep;
    [nodeCount,~] = size(U_C_B_eachStep);
    % We need to know the states 5 mins ago, apply the system dynamic for
    % the past 5 mins to obtain the estimation of current value.
    A = PreviousSystemDynamicMatrix.A;
    B = PreviousSystemDynamicMatrix.B;
    C = PreviousSystemDynamicMatrix.C;
    
    Hq_min = Constants4Concentration.Hq_min;
    
    PreviousIndex = tInMin/Hq_min;
    Previous_x = X_estimated(:,PreviousIndex);
    Previous_delta_t = PreviousDelta_t(PreviousIndex);
    
    % how many steps in 5 mins
    SetTimeParameter = Hq_min * Constants4Concentration.MinInSecond/Previous_delta_t;
    Np = round(SetTimeParameter);
    %Np = floor(SetTimeParameter) + 1;
    x_estimated = Previous_x;
    
    U = U_C_B_eachStep;
    XX = [];
    for i = 1:Np
        if(aux.COMPARE == 1)
            x_estimated = A * x_estimated;
        else
            x_estimated = A * x_estimated + B * U(:,i);
        end
        XX = [XX x_estimated];
    end
    IndexofApplyingU = [];
    Hq_min = Constants4Concentration.Hq_min;
    for i = 1:(Hq_min)
        IndexofApplyingU = [IndexofApplyingU round(i * Constants4Concentration.MinInSecond/Previous_delta_t)];
    end
    % Save the value at each minute 
    XX = XX(:,IndexofApplyingU);
end
end