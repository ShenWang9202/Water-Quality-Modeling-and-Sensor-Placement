function newXX = scaleX2(XX_estimated,IndexInVarCell,NumberofSegment4Pipes_all,ElementCount,NumberofSegment4PipesNew)
time = length(XX_estimated);
newXX = [];
parfor i = 1:time
    x = XX_estimated{i};
    IndexInVar = IndexInVarCell{i};
    NumberofSegment4Pipes = NumberofSegment4Pipes_all(i,:);
    [~,count] = size(x);
    for j = 1:count
        x_scaled = scalePipeSegment(x(:,j),IndexInVar,NumberofSegment4Pipes,ElementCount,NumberofSegment4PipesNew);
        newXX = [newXX x_scaled];
    end
end
end