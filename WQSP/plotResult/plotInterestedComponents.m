function plotInterestedComponents(InterestedID,IDcell,SourceData,titleName)
IDcell = IDcell';
[~,n] = size(InterestedID);
InterestedPipeIndices = [];
for i = 1:n
    % find index according to ID.
    findIndexByID(InterestedID{i},IDcell)
    InterestedPipeIndices = [InterestedPipeIndices findIndexByID(InterestedID{i},IDcell)];
end

InterestedData = SourceData(:,InterestedPipeIndices);

figure
plot(InterestedData);
legend(InterestedID);
title(titleName);
xlabel('Time (minute)')
ylabel('Concentrations (mg/L)')