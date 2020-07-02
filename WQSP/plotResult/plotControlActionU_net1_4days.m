function plotControlActionU_net1_4days(ControlActionU,BoosterLocationIndex,Location_B,InterestedTime2)
figure1 = figure
h1 = subplot(1,2,1);
fontsize = 40;
y = ControlActionU(:,BoosterLocationIndex);
maxY = max(max(y));
plot(y,'LineWidth',2.5);
% xticks([0 1440 2880 4320 5740]);
% xticklabels({'0 (0D)','1440 (1D)', '2880 (2D)', '4320 (3D)', '5760 (4D)'})
%yticks([0 1 2 3])
xticks([0 720 1440 2160 2880 3600 4320 5040 5760]);
xticklabels({'0','(D1)','1440','(D2)', '2880','(D3)', '4320','(D4)', '5760'})

xlim([0,5761])
ylim([0,maxY+1000])

% set(gca, 'TickLabelInterpreter', 'latex','fontsize',fontsize,'YGrid','off','XGrid','on');
box on
lgd = legend(Location_B,'Location','Best','Interpreter','Latex','Orientation','horizontal');
lgd.FontSize = fontsize;
set(lgd,'box','off')
set(lgd,'Interpreter','Latex');
set(gca, 'TickLabelInterpreter', 'latex','fontsize',fontsize-4);
xlabel('Time (minute \& day)','FontSize',fontsize,'interpreter','latex')
ylabel({'Mass rate at boosters';'   (mg/minute)'},'FontSize',fontsize,'interpreter','latex')

annotation(figure1,'textarrow',[0.453571428571429 0.791071428571429],...
    [0.728732142857143 0.728732142857143],'LineWidth',2,'LineStyle','--','HeadLength',25,'HeadWidth',25);



%% Plot enlarged version
InterestedTime1 = 2997;
InterestedTime2;
x = InterestedTime1:InterestedTime2;

% start to plot
h2 = subplot(1,2,2)

plot(x,ControlActionU(x,BoosterLocationIndex),'LineWidth',3);

xticks([3000 InterestedTime2]);
xticklabels({'3000',num2str(InterestedTime2)})
xlim([InterestedTime1-3 InterestedTime2+3])
ylim([0,maxY+1000]);

%yticks([0 1 2 3])

h = gca; h.YAxis.Visible = 'off';
xlabel('  ','FontSize',fontsize,'interpreter','latex');
ylabel([]);
set(gca, 'TickLabelInterpreter', 'latex','fontsize',fontsize-4);


% set(h1, 'Position', [0.1, 0.1, 0.75, 0.8]);
% set(h2, 'Position', [0.9, 0.1, 0.1, 0.8])
FirstPosition = h1.Position;

SecondPosition = h2.Position;
FirstPosition(3) = 0.6;
SecondPosition(1) = FirstPosition(1) + FirstPosition(3) + 0.08;
SecondPosition(3) = 0.15;
FirstPosition(2) = 0.25
FirstPosition(4) = 0.6
SecondPosition(2)  = FirstPosition(2) ;
SecondPosition(4)  = FirstPosition(4);
set(h1, 'Position',FirstPosition)
set(h2, 'Position',SecondPosition)

h1
h2


set(gcf,'PaperUnits','inches','PaperPosition',[0 0 16 8])
print(figure1,'EnlargedControlActionU_net1','-depsc2','-r300');
end