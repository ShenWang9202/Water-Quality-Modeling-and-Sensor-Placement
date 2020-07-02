function occupationEachNode_All_r =  occupationTimeAnalysis(sensorPosition_Time_Number)

occupationEachNode_All_r = [];
[T_total,~,r] = size(sensorPosition_Time_Number);
for i = 1:r
    sensorPosition_Time = sensorPosition_Time_Number(:,:,i);
    occupationEachNode = sum(sensorPosition_Time)/T_total;
    occupationEachNode_All_r = [occupationEachNode_All_r; occupationEachNode];
end
occupationEachNode_All_r = occupationEachNode_All_r';
end