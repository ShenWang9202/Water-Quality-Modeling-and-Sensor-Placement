function plotMinMaxRange(y,InterestedID,IDLibrary,faceColor,tranparecy,fontSize,lineWidth)
% input y is the source data, each column is the junctions' data, and each
% row is the time in minutes

% Find interested data first
[~,n] = size(InterestedID);
InterestedJunctionIndices = [];
for i = 1:n
    % find index according to ID.
    InterestedJunctionIndices = [InterestedJunctionIndices findIndexByID(InterestedID{i},IDLibrary)];
end
InterestedYdata = y(:,InterestedJunctionIndices);

% Since the first junction is J10, however, it is uncontrollable, and the
% data is always 1, we don't display the concentration of J10
%IngoreID = {'J10'};
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
figure1 = figure;
% plot the range
px=[x,fliplr(x)];
py=[y(1,:), fliplr(y(2,:))];
patch(px,py,1,'FaceColor',faceColor,'EdgeColor','none','DisplayName','Range Zone');
alpha(tranparecy);
% plot mean or average value
hold on
plot(x,meanData',faceColor,'DisplayName','Average Value','LineWidth',3.5);

% plot intested y data
[~,n] = size(InterestedID);
for i = 1:n
hold on
plot(x,InterestedYdata(:,i)','DisplayName',InterestedID{i},'LineWidth',lineWidth);
end


% ylim([y_axis_min y_axis_max]);
ylim([y_axis_min 3.1]);
xticks([0 1440 2880 4320 5760]);
%yticks([0 1 2 3])
xlim([0,5761])


lgd = legend('Location','best','Interpreter','Latex');
% lgd = legend('Location','eastoutside','Interpreter','Latex');
lgd.FontSize = fontSize-10;

set(lgd,'box','off')
set(lgd,'Interpreter','Latex');

set(gca, 'TickLabelInterpreter', 'latex','fontsize',fontSize);
xlabel('Time (minute)','FontSize',fontSize,'interpreter','latex')
ylabel('Concentrations in links(mg/L)','FontSize',fontSize,'interpreter','latex')
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 14 8])
print(figure1,['Junction_Net1',InterestedID{1}],'-depsc2','-r300');

%% Plot enlarged version

x = 2997:3008;

% start to plot
figure2 = figure;
% plot the range
px=[x,fliplr(x)];
py=[y(1,x), fliplr(y(2,x))];
patch(px,py,1,'FaceColor',faceColor,'EdgeColor','none','DisplayName','Range Zone');
alpha(tranparecy);
% plot mean or average value
hold on
plot(x,meanData(x)',faceColor,'DisplayName','Average Value','LineWidth',3.5);

% plot intested y data
[~,n] = size(InterestedID);
for i = 1:n
hold on
plot(x,InterestedYdata(x,i)','DisplayName',InterestedID{i},'LineWidth',3.5);
end


% ylim([y_axis_min y_axis_max]);
ylim([y_axis_min 3.1]);
xticks([3000]);
%yticks([0 1 2 3])
xlim([2997 3008])
h = gca; h.YAxis.Visible = 'off';

set(gca, 'TickLabelInterpreter', 'latex','fontsize',fontSize);
xlabel('  ','FontSize',fontSize,'interpreter','latex');
ylabel([]);
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 2 8])
print(figure2,['EnlargedJunction_Net1',InterestedID{1}],'-depsc2','-r300');



end