function plotMinMaxRange4Pipe(y,InterestedID,IDLibrary,faceColor,tranparecy,fontSize,BlueLineWidth,lineWidth,InterestedTime2)
% input y is the source data, each column is the junctions' data, and each
% row is the time in minutes

% Find interested data first
[~,n] = size(InterestedID);
InterestedPipeIndices = [];
for i = 1:n
    % find index according to ID.
    InterestedPipeIndices = [InterestedPipeIndices findIndexByID(InterestedID{i},IDLibrary)];
end
InterestedYdata = y(:,InterestedPipeIndices);

% Since the first junction is J10, however, it is uncontrollable, and the
% data is always 1, we don't display the concentration of P10
%IngoreID = {'P10'};

y = y(:,2:end);

% Find the mena or average value
meanData = mean(y,2);

[m,~] = size(y);

% Find the min and max of y data
y_max = max(y,[],2);
y_min = min(y,[],2); % 
y = [y_min y_max]';
x = 1:m;

% Find the axis limit
y_axis_max = max(y_max) + 0.05;
y_axis_min = max(0,min(y_min)-0.05);

% start to plot

% start to plot
figure1 = figure
h1 = subplot(1,2,1);

% plot the range
px=[x,fliplr(x)];
py=[y(1,:), fliplr(y(2,:))];
patch(px,py,1,'FaceColor',faceColor,'EdgeColor','none','DisplayName','Range Zone');
alpha(tranparecy);
% plot mean or average value
hold on
plot(x,meanData',faceColor,'DisplayName','Average Value','LineWidth',BlueLineWidth);

% plot intested y data
[~,n] = size(InterestedID);
for i = 1:n
hold on
plot(x,InterestedYdata(:,i)','DisplayName',InterestedID{i},'LineWidth',lineWidth);
end


ylim([y_axis_min y_axis_max]);
% ylim([y_axis_min 3.1]);
% xticks([0 1440 2880 4320 5760]);
% xticklabels({'0 (0d)','1440 (1d)', '2880 (2d)', '4320 (3d)', '5760 (4d)'})
%yticks([0 1 2 3])
xticks([0 720 1440 2160 2880 3600 4320 5040 5760]);
xticklabels({'0','(D1)','1440','(D2)', '2880','(D3)', '4320','(D4)', '5760'})
xlim([0,5761]);


lgd = legend('Location','northwest','Interpreter','Latex','Orientation','horizontal');
% lgd = legend('Location','eastoutside','Interpreter','Latex');
lgd.FontSize = fontSize-8;

set(lgd,'box','off');
set(lgd,'Interpreter','Latex');

set(gca, 'TickLabelInterpreter', 'latex','fontsize',fontSize -2,'YGrid','off','XGrid','on');
xlabel('Time (minute \& day)','FontSize',fontSize,'interpreter','latex')
ylabel('Concentration (mg/L)','FontSize',fontSize,'interpreter','latex')

box on

hold on 
% ta = annotation(figure1,'textarrow',[0.35356037151703 0.43888544891641],...
%     [0.319690010298661 0.38002059732],...
%     'String',{'Magnified data', 'in the right'});
% ta.FontSize = fontSize-7;
% ta.Interpreter = 'latex';

annotation(figure1,'textarrow',[0.447142857142857 0.805357142857143],...
    [0.387392857142857 0.387392857142857],'LineWidth',2,'LineStyle','--','HeadLength',25,'HeadWidth',25);

% set(gcf,'PaperUnits','inches','PaperPosition',[0 0 14 8])
% print(figure1,['Pipe_Net1',InterestedID{1}],'-depsc2','-r300');

%% Plot enlarged version
InterestedTime1 = 2997;
InterestedTime2;
x = InterestedTime1:InterestedTime2;

% start to plot
h2 = subplot(1,2,2)
% plot the range
px=[x,fliplr(x)];
py=[y(1,x), fliplr(y(2,x))];
patch(px,py,1,'FaceColor',faceColor,'EdgeColor','none','DisplayName','Range Zone');
alpha(tranparecy);
% plot mean or average value
hold on
plot(x,meanData(x)',faceColor,'DisplayName','Average Value','LineWidth',BlueLineWidth);

% plot intested y data
[~,n] = size(InterestedID);
for i = 1:n
hold on
plot(x,InterestedYdata(x,i)','DisplayName',InterestedID{i},'LineWidth',lineWidth);
end


% ylim([y_axis_min y_axis_max]);
ylim([y_axis_min y_axis_max]);

xticks([3000 InterestedTime2]);
xticklabels({'3000',num2str(InterestedTime2)})
xlim([InterestedTime1 InterestedTime2+3])

%yticks([0 1 2 3])

h = gca; h.YAxis.Visible = 'off';


h = gca; h.YAxis.Visible = 'off';

xlabel('  ','FontSize',fontSize,'interpreter','latex');
ylabel([]);

set(gca, 'TickLabelInterpreter', 'latex','fontsize',fontSize-5);


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

% set(gca, 'TickLabelInterpreter', 'latex','fontsize',fontSize-6);
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 16 7])
print(figure1,['EnlargedPipe_Net1',InterestedID{1}],'-depsc2','-r300');

end