function plotImage4Net1

clear
load('Network6_1_1_Net1_1days_demand-pattern1_Expected5_1min.mat')
fileLongName = 'Net1_t5_1min_SSPaper';
plotSensorSelectionResult_specific(sensorSelectionResult,NodeID4Legend,fileLongName,sensorNumberArray,Hq_min,SimutionTimeInMinute);

clear
load('Network6_1_1_Net1_1days_demand-pattern1_Expected5_5min.mat')
fileLongName = 'Net1_t5_5min_SSPaper';
plotSensorSelectionResult_specific(sensorSelectionResult,NodeID4Legend,fileLongName,sensorNumberArray,Hq_min,SimutionTimeInMinute);

clear
load('Network6_1_1_Net1_1days_demand-pattern1_Expected10_5min.mat')
fileLongName = 'Net1_t10_5min_SSPaper';
plotSensorSelectionResult_specific(sensorSelectionResult,NodeID4Legend,fileLongName,sensorNumberArray,Hq_min,SimutionTimeInMinute);


clear
load('Network6_1_1_Net1_1days_demand-pattern3_Expected5_5min.mat')
fileLongName = 'Net1_t5_5min_P2_SSPaper';
plotSensorSelectionResult_specific(sensorSelectionResult,NodeID4Legend,fileLongName,sensorNumberArray,Hq_min,SimutionTimeInMinute);
clear
load('Network6_1_1_Net1_1days_demand-pattern4_Expected5_5min.mat')
fileLongName = 'Net1_t5_5min_P3_SSPaper';
plotSensorSelectionResult_specific(sensorSelectionResult,NodeID4Legend,fileLongName,sensorNumberArray,Hq_min,SimutionTimeInMinute);



clear
load('Network6_1_1_Net1_1days_demand-pattern1-basedemand1_Expected5_5min.mat')
fileLongName = 'Net1_t5_5min_P1_b1_SSPaper';
plotSensorSelectionResult_specific(sensorSelectionResult,NodeID4Legend,fileLongName,sensorNumberArray,Hq_min,SimutionTimeInMinute);
clear
load('Network6_1_1_Net1_1days_demand-pattern1-basedemand2_Expected5_5min.mat')
fileLongName = 'Net1_t5_5min_P1_b2_SSPaper';
plotSensorSelectionResult_specific(sensorSelectionResult,NodeID4Legend,fileLongName,sensorNumberArray,Hq_min,SimutionTimeInMinute);


end
