function plotImaginesc4InterestedComponents(X_Min,Pipe_CStartIndex,NumberofSegment4Pipes,InterestedID,LinkID4Legend)

[~,n] = size(InterestedID);
% basePipeCIndex = min(Pipe_CIndex);
% First = basePipeCIndex:basePipeCIndex+NumberofSegment-1;
InterestedPipeIndices = [];
for i = 1:n
    % find index according to ID.
    InterestedPipeIndices = [InterestedPipeIndices findIndexByID(InterestedID{i},LinkID4Legend)];
end
[~,IntestedSize] = size(InterestedPipeIndices);

for j = 1:IntestedSize
%     Indexrange = (InterestedPipeIndices(j)-1)*NumberofSegment + First;
    ind = InterestedPipeIndices(j);
    Indexrange = Pipe_CStartIndex(ind):Pipe_CStartIndex(ind) + NumberofSegment4Pipes(ind)-1;
    figure
    imagesc(X_Min(Indexrange,:));
    pipeIDTtile = LinkID4Legend{InterestedPipeIndices(j)};
    title(pipeIDTtile)
    colorbar;
end