function x_estimated = EstimateState_x(CurrentValue,IndexInVar,aux,ElementCount,q_B,tInMin,C0,PreviousValue)
NumberofX = IndexInVar.NumberofX;
MassEnergyMatrix = aux.MassEnergyMatrix;

if(tInMin==0)
    x0 = zeros(NumberofX,1);
    CurrentHead = CurrentValue.CurrentHead;
    %Head0 = Head(1,:);
    % Something wrong with this intial function with 8-node network
    x0 = InitialConcentration(x0,C0,MassEnergyMatrix,CurrentHead,IndexInVar,ElementCount);
    x_estimated = x0;
else
    PreviousDelta_t = PreviousValue.PreviousDelta_t;
    PreviousSystemDynamicMatrix = PreviousValue.PreviousSystemDynamicMatrix;
    X_estimated = PreviousValue.X_estimated;
    U_C_B_eachMin = PreviousValue.U_C_B_eachMin;
    [nodeCount,~] = size(U_C_B_eachMin);
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
    SetTimeParameter = Hq_min*Constants4Concentration.MinInSecond/Previous_delta_t;
    Np = round(SetTimeParameter);
    %Np = floor(SetTimeParameter) + 1;
    
    IndexofApplyingU = [];
    Hq_min = Constants4Concentration.Hq_min;
    for i = 1:(Hq_min)
        IndexofApplyingU = [IndexofApplyingU round(i * Constants4Concentration.MinInSecond/Previous_delta_t)];
    end
    XX = [];
    x_estimated = Previous_x;
    j = 1;
    
    % The four line codes are very important, when tInMin = 5 mins, we need
    % to estimate the state x from 0 - 5, and the control action from 0 to 1
    % min is 0. When tInMin = 10 mins, we need to estimate the state x from
    % 5 - 10, and the control action from 5 to 6 is the control action at 5
    % mins instead of 0.
    
    % Besides that, the accuracy of estimation of x has significant
    % influence to the control effect. It is easy to verify this, just
    % add some noise to x_estimated
    if(tInMin == Hq_min)
        U = zeros(nodeCount,1);
    else
        U = U_C_B_eachMin(:,end);
    end
    
    for i = 1:Np
        % each minute
        if(i == IndexofApplyingU(j))
            U = U_C_B_eachMin(:,j);
            j = j + 1;
        end
        x_estimated = A * x_estimated + B * U;
        XX = [XX x_estimated];
    end
    XX = XX(:,IndexofApplyingU);
end
end