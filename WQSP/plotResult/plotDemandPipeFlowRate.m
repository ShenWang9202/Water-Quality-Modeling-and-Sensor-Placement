figure1 = figure
fontsize = 40;
% get predicted demand
PredictedDemand = HydraulicInfoWithoutUncertainty.Demand_all;
PredictedDemand = PredictedDemand(:,NodeJunctionIndex);

%% plot actual demand and predicted demand
subplot(2,1,1)
JunctionActualDemandSum = sum(JunctionActualDemand,2);
PredictedDemandSum = sum(PredictedDemand,2);
plot(JunctionActualDemandSum,'LineWidth',2.5);
hold on
plot(PredictedDemandSum,'LineWidth',2.5);

%xlabel('Time (minute \& day)','FontSize',fontsize,'interpreter','latex')
ylabel('Demand (GPM)','FontSize',fontsize,'interpreter','latex')



% xticks([0 1440 2880 4320 5760]);

xticks([]);
% xticklabels({'0 (0D)','1440 (1D)', '2880 (2D)', '4320 (3D)', '5760 (4D)'})

%yticks([0 1 2 3])
xlim([0,5761])
ylim([0,3100])

box on
lgd = legend({'Predicted','Actual'},'Location','Best','Interpreter','Latex','Orientation','horizontal');
lgd.FontSize = fontsize-8;
set(lgd,'box','off')
set(lgd,'Interpreter','Latex');

set(gca, 'TickLabelInterpreter', 'latex','fontsize',fontsize -10,'YGrid','off','XGrid','on');


%% plot interested flow rate

InterestedID = {'P11','P31','P110'};

[~,n] = size(InterestedID);
InterestedPipeIndices = [];
for i = 1:n
    % find index according to ID.
    InterestedPipeIndices = [InterestedPipeIndices findIndexByID(InterestedID{i},PipeID)];
end
InterestedYdata = Flow(:,InterestedPipeIndices);

pos = get(gca, 'Position')
%     pos = [x y width height]
%     pos(1) = 0.055;
pos(4) = 0.4; % change the height as 40%
set(gca, 'Position', pos)



subplot(2,1,2)


plot(InterestedYdata,'LineWidth',2.5)

xticks([0 1440 2880 4320 5760]);
xticklabels({'0 (0D)','1440 (1D)', '2880 (2D)', '4320 (3D)', '5760 (4D)'})
%yticks([0 1 2 3])
xlim([0,5761])
% ylim([0,maxY+1000])

xlabel('Time (minute \& day)','FontSize',fontsize,'interpreter','latex')
ylabel('Flow rates (GPM)','FontSize',fontsize,'interpreter','latex')

set(gca, 'TickLabelInterpreter', 'latex','fontsize',fontsize -10,'YGrid','off','XGrid','on')


box on
lgd = legend(LinkID4Legend(InterestedPipeIndices),'Location','Best','Interpreter','Latex','Orientation','horizontal');
lgd.FontSize = fontsize-8;
set(lgd,'box','off')
set(lgd,'Interpreter','Latex');

pos = get(gca, 'Position')
%     pos = [x y width height]
%     pos(1) = 0.055;
pos(4) = 0.34; % change the height as 40%
set(gca, 'Position', pos)

set(gcf,'PaperUnits','inches','PaperPosition',[0 0 16 8])
print(figure1,['DemandandInterestedPipeFlowrate'],'-depsc2','-r300');

