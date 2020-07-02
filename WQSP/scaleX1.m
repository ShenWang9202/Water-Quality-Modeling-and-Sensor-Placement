function newXX = scaleX1(XX_estimated,IndexInVar,NumberofSegment4PipesOld,ElementCount,NumberofSegment4PipesNew)
[~,time] = size(XX_estimated);
newXX = [];
for i = 1:time
    x = XX_estimated(:,i);
    x_scaled = scalePipeSegment(x,IndexInVar,NumberofSegment4PipesOld,ElementCount,NumberofSegment4PipesNew);
    newXX = [newXX x_scaled];
end
end