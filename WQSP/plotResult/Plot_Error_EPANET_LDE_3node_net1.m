function Plot_Error_EPANET_LDE_3node_net1
% run 3-node with FLAG COMPARE = 1, 
% SAVE  LDEResult1 as LDEResult1_3node
% SAVE  epanetResult1 as epanetResult1_3node
clear
 filename = 'Three-node_1day.mat';
load(filename)
% calculate 3 node 
epanetResult1_3node = epanetResult1';
LDEResult1_3node = LDEResult1';
EPANET_Result = epanetResult1_3node(:,2:end);
LDE_Result = LDEResult1_3node(:,1:end-1);
LDE_Result(:,1) = EPANET_Result(:,1);
Error = EPANET_Result - LDE_Result;
[~,TimeInMinutes] = size(Error);
errorVetor_3node = zeros(1,TimeInMinutes);
for i = 1:TimeInMinutes
    errorVetor_3node(i) = norm(Error(:,i))/ norm(EPANET_Result(:,i));
end
% run Net1 with FLAG COMPARE = 1,
% SAVE  LDEResult1 as LDEResult1_3node
% SAVE  epanetResult1 as epanetResult1_3node

filename = 'Net1_1days.mat';
load(filename)
epanetResult1 = epanetResult1';
LDEResult1 = LDEResult1';
% calculate net1
EPANET_Result = epanetResult1(:,2:end);
LDE_Result = LDEResult1(:,1:end-1);
LDE_Result(:,1) = EPANET_Result(:,1);
Error = EPANET_Result - LDE_Result;
[~,TimeInMinutes] = size(Error);
errorVetor_net1 = zeros(1,TimeInMinutes);
for i = 1:TimeInMinutes
    errorVetor_net1(i) = norm(Error(:,i))/ norm(EPANET_Result(:,i));
end


figure1 = figure
fontsize = 40;
title('Relative error between EPANET and LDE','FontSize',fontsize,'interpreter','latex')

yyaxis left
plot(errorVetor_3node,'LineWidth',4.5);
ylim([0,0.07])
yticks([0.005 0.03  0.07])
yticklabels({'0.5\%','3.0\%','7\%'})
ylabel({'Three-node ';'   network'},'FontSize',fontsize,'interpreter','latex')
yyaxis right
plot(errorVetor_net1,'LineWidth',3);
xticks([0 360 720 1080 1440])
ylim([0,0.07])
yticks([0.005 0.03  0.07])
yticklabels({'0.5\%','3.0\%','7\%'})
xlim([0,1440])
%ylim([200,900]);
set(gca, 'TickLabelInterpreter', 'latex','fontsize',fontsize);
% lgd = legend(LinkID4Legend,'Location','eastoutside','Interpreter','Latex');
% lgd.FontSize = fontsize-6;
% %title('$h^{M} = s^2 (h_0 - r (q/s)^{\nu})$','interpreter','latex','FontSize',fontsize+7)
% set(lgd,'box','off')
% set(lgd,'Interpreter','Latex');

xlabel('Time (minute)','FontSize',fontsize,'interpreter','latex')
%ylabel({'Relative error between ';'   EPANET and LDE'},'FontSize',fontsize,'interpreter','latex')
ylabel('Net1','FontSize',fontsize,'interpreter','latex')
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 16 5])
print(figure1,'Error_EPANET_LDE','-depsc2','-r300');
