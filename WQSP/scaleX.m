function newXX = scaleX(tInMin,XX_estimated,IndexInVar,PreviousValue,NumberofSegment4PipesOld,ElementCount,NumberofSegment4PipesNew)
[~,time] = size(XX_estimated);
if(tInMin ~=0)
    IndexInVar = PreviousValue.IndexInVarOld;
    NumberofSegment4PipesOld = PreviousValue.PreviousNumberofSegment4Pipes;
end
newXX = [];
for i = 1:time
    x = XX_estimated(:,i);
    x_scaled = scalePipeSegment(x,IndexInVar,NumberofSegment4PipesOld,ElementCount,NumberofSegment4PipesNew);
    newXX = [newXX x_scaled];
end
end
