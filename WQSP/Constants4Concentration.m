classdef Constants4Concentration
    properties( Constant = true )
        SensorSelction = 0;
        COMPARE = 1;
        Network = 7; % Don't use case 2 
        ExpectedTimeStep = 5.2;
        SimutionTimeInMinute = 24*60; %Simulate three-node for 1 day
        Hq_min = 5;

        %QualityTimeStep = 300; % 5 mins

        %SimutionTimeInMinute = 4*24*60; % Simulate Net1 for 4 day
        SimutionTimeInMinute4RBC = 24*60;  %Simulate three-node (rule based control) for 1 day
        Price_Weight = 0.001;
        reference = 2;% any value between 0.4~4mg/L;
        
        DayInSecond = 86400;
        MinInSecond = 60;
        NumberofSegment = 250;
        
        Gallon2Liter = 3.78541;
        FT2Inch = 12;
        pi = 3.141592654;
        GPMperCFS= 448.831;
        AFDperCFS= 1.9837;
        MGDperCFS= 0.64632;
        IMGDperCFS=0.5382;
        LPSperCFS= 28.317;
        M2FT = 3.28084;
        LPS2GMP = 15.850372483753;
        LPMperCFS= 1699.0;
        CMHperCFS= 101.94;
        CMDperCFS= 2446.6;
        MLDperCFS= 2.4466;
        M3perFT3=  0.028317;
        LperFT3=   28.317;
        MperFT=    0.3048;
        PSIperFT=  0.4333;
        KPAperPSI= 6.895;
        KWperHP=   0.7457;
        SECperDAY= 86400;
        SpecificGravity = 1;
    end
end
