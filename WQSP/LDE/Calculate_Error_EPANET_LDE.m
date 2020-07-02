function errorVetor = Calculate_Error_EPANET_LDE(EPANET_Result,LDE_Result,fileNameError)
% we use norm 2 relative error
% https://www.netlib.org/lapack/lug/node75.html
% LDE_Result = [EPANET_Result(:,1),LDE_Result];
EPANET_Result = EPANET_Result(:,2:end);
[~,TimeInMinutes] = size(EPANET_Result);
% LDE_Result(:,1:end-1);
LDE_Result = LDE_Result(:,1:TimeInMinutes);
% LDE_Result(:,1) = EPANET_Result(:,1);

Error = EPANET_Result(:,1:TimeInMinutes) - LDE_Result;

[~,TimeInMinutes] = size(Error);
errorVetor = zeros(1,TimeInMinutes);
for i = 1:TimeInMinutes
    errorVetor(i) = norm(Error(:,i))/ norm(EPANET_Result(:,i));
end

figure1 = figure;
fontsize = 36;
plot(errorVetor,'LineWidth',2);
xticks([0 360 720 1080 1440])
% yticks([0.005 0.015 0.025])
% yticklabels({'0.5\%','1.5\%','2.5\%'})
xlim([0,1440])
%ylim([200,900]);
set(gca, 'TickLabelInterpreter', 'latex','fontsize',fontsize);
% lgd = legend(LinkID4Legend,'Location','eastoutside','Interpreter','Latex');
% lgd.FontSize = fontsize-6;
% %title('$h^{M} = s^2 (h_0 - r (q/s)^{\nu})$','interpreter','latex','FontSize',fontsize+7)
% set(lgd,'box','off')
% set(lgd,'Interpreter','Latex');

xlabel('Time (minute)','FontSize',fontsize,'interpreter','latex')
ylabel({'Relative error between ';'   EPANET and LDE'},'FontSize',fontsize,'interpreter','latex')
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 16 8])
fileNameError = ['Error_LDE4',fileNameError]; 
print(figure1,fileNameError,'-depsc2','-r300');
print(figure1,fileNameError,'-dpng','-r300');

end