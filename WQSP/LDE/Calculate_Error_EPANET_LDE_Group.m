function errorVetor = Calculate_Error_EPANET_LDE_Group(InterestedID,IDcell,EPANETGroup,LDEGroup)
% we use norm 2 relative error
% https://www.netlib.org/lapack/lug/node75.html
IDcell = IDcell';
[~,n] = size(InterestedID);
InterestedPipeIndices = [];
for i = 1:n
    % find index according to ID.
    findIndexByID(InterestedID{i},IDcell);
    InterestedPipeIndices = [InterestedPipeIndices findIndexByID(InterestedID{i},IDcell)];
end

EPANET_Result = EPANETGroup(:,InterestedPipeIndices);
LDE_Result = LDEGroup(:,InterestedPipeIndices);

Error = EPANET_Result - LDE_Result;




figure1 = figure;
fontsize = 20;
plot(Error,'LineWidth',2);

legend(InterestedID);
set(gca, 'TickLabelInterpreter', 'latex','fontsize',fontsize);
% lgd = legend(LinkID4Legend,'Location','eastoutside','Interpreter','Latex');
% lgd.FontSize = fontsize-6;
% %title('$h^{M} = s^2 (h_0 - r (q/s)^{\nu})$','interpreter','latex','FontSize',fontsize+7)
% set(lgd,'box','off')
% set(lgd,'Interpreter','Latex');

xlabel('Time (minute)','FontSize',fontsize,'interpreter','latex')
ylabel({'Absolute error between ';'   EPANET and LDE'},'FontSize',fontsize,'interpreter','latex')
% set(gcf,'PaperUnits','inches','PaperPosition',[0 0 16 8])
% print(figure1,'Error_EPANET_LDE','-depsc2','-r300');

end