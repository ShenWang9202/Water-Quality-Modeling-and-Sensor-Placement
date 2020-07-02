
function Plot_Error_Kalman_3node_net1
% run 3-node with FLAG COMPARE = 1, 
% SAVE  LDEResult1 as LDEResult1_3node
% SAVE  epanetResult1 as epanetResult1_3node
clear
filename = 'Three-node_1day_Kalman.mat';
load(filename)
% calculate 3 node 
estimated_3node = xp_Record;
% LDEResult1_3node = LDEResult1';
real_3node = x_Record;
EPANET_Result = estimated_3node(:,2:end);
LDE_Result = real_3node(:,2:end);
Error = EPANET_Result - LDE_Result;
[~,TimeInMinutes] = size(Error);
errorVetor_3node = zeros(1,TimeInMinutes);
for i = 1:TimeInMinutes
    errorVetor_3node(i) = norm(Error(:,i))/ norm(EPANET_Result(:,i));
end
% run Net1 with FLAG COMPARE = 1,
% SAVE  LDEResult1 as LDEResult1_3node
% SAVE  epanetResult1 as epanetResult1_3node

%  filename = 'Net1_1days_Kalman.mat';
  filename = 'Three-node_1day_Kalman.mat';
load(filename)
% calculate 3 node 
estimated_net1 = xp_Record;
% LDEResult1_3node = LDEResult1';
real_net1 = x_Record;
EPANET_Result = estimated_net1(:,2:end);
LDE_Result = real_net1(:,2:end);

Error = EPANET_Result - LDE_Result;
[~,TimeInMinutes] = size(Error);
errorVetor_net1 = zeros(1,TimeInMinutes);
for i = 1:TimeInMinutes
    errorVetor_net1(i) = norm(Error(:,i))/ norm(EPANET_Result(:,i));
end


figure1 = figure
fontsize = 40;
title('Kalman filter performance','FontSize',fontsize,'interpreter','latex')

yyaxis left
plot(errorVetor_3node,'LineWidth',1);
ylim([0,0.07])
yticks([0.005 0.03  0.07])
yticklabels({'0.5\%','3.0\%','7\%'})
ylabel({'Three-node ';'   network'},'FontSize',fontsize,'interpreter','latex')
yyaxis right
plot(errorVetor_net1,'LineWidth',3);
xticks([0 360 720 1080 1440])
% ylim([0,0.07])
% yticks([0.005 0.03  0.07])
% yticklabels({'0.5\%','3.0\%','7\%'})
xlim([0,1440])
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
print(figure1,'Error_Kalman','-depsc2','-r300');
