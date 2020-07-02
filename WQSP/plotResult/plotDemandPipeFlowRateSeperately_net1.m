figure1 = figure
fontsize = 45;
% get predicted demand
PredictedDemand = HydraulicInfoWithoutUncertainty.Demand_all;
PredictedDemand = PredictedDemand(:,NodeJunctionIndex);

%% plot actual demand and predicted demand
JunctionActualDemandSum = sum(JunctionActualDemand,2);
PredictedDemandSum = sum(PredictedDemand,2);
plot(JunctionActualDemandSum,'LineWidth',3.5);
hold on
plot(PredictedDemandSum,'LineWidth',3.5);

%xlabel('Time (minute \& day)','FontSize',fontsize,'interpreter','latex')
ylabel({'Demand';' (GPM)'},'FontSize',fontsize - 10,'interpreter','latex')

box on

xticks([0 720 1440 2160 2880 3600 4320 5040 5760]);
xticklabels({'0','(D1)','1440','(D2)', '2880','(D3)', '4320','(D4)', '5760'})

%yticks([0 1 2 3])
xlim([0,5761])
ylim([0,3100])

box on
lgd = legend({'Predicted','Actual'},'Location','Best','Interpreter','Latex','Orientation','horizontal');
lgd.FontSize = fontsize-8;
set(lgd,'box','off')
set(lgd,'Interpreter','Latex');

set(gca, 'TickLabelInterpreter', 'latex','fontsize',fontsize - 2);

set(gcf,'PaperUnits','inches','PaperPosition',[0 0 16 4])
print(figure1,['Demand4days'],'-depsc2','-r300');


%% plot interested flow rate

figure2 = figure;
InterestedID = {'Pu9','P11','P110'};
            
[~,n] = size(InterestedID);
InterestedPipeIndices = [];
for i = 1:n
    % find index according to ID.
    InterestedPipeIndices = [InterestedPipeIndices findIndexByID(InterestedID{i},LinkID4Legend)];
end
InterestedYdata = Flow(:,InterestedPipeIndices);

plot(InterestedYdata,'LineWidth',3.5)

% xticks([0 1440 2880 4320 5760]);
% xticklabels({'0 (0D)','1440 (1D)', '2880 (2D)', '4320 (3D)', '5760 (4D)'})
xticks([0 720 1440 2160 2880 3600 4320 5040 5760]);
xticklabels({'0','(D1)','1440','(D2)', '2880','(D3)', '4320','(D4)', '5760'})
yticks([-1000 0 1000 2000])
xlim([0,5761])
ylim([-1000,3000])

xlabel('Time (minute \& day)','FontSize',fontsize - 10 ,'interpreter','latex')
ylabel({'Flow rates';' (GPM)'},'FontSize',fontsize - 10 ,'interpreter','latex')

set(gca, 'TickLabelInterpreter', 'latex','fontsize',fontsize -2)


box on
lgd = legend(LinkID4Legend(InterestedPipeIndices),'Location','northeast','Interpreter','Latex','Orientation','horizontal');
lgd.FontSize = fontsize-8;
set(lgd,'box','off')
set(lgd,'Interpreter','Latex');

set(gcf,'PaperUnits','inches','PaperPosition',[0 0 16 5])
print(figure2,['InterestedPipeFlowRate'],'-depsc2','-r300');

