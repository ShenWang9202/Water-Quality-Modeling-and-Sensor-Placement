function plotFlow_net1(LinkID4Legend,Flow)
figure1 = figure
fontsize = 36;
plot(Flow,'LineWidth',3);
xticks([0 360 720 1080 1440])
%yticks([0 1 2 3])
xlim([0,1440])
%ylim([200,900]);
set(gca, 'TickLabelInterpreter', 'latex','fontsize',fontsize);
lgd = legend(LinkID4Legend,'Location','eastoutside','Interpreter','Latex');
lgd.FontSize = fontsize-7;
%title('$h^{M} = s^2 (h_0 - r (q/s)^{\nu})$','interpreter','latex','FontSize',fontsize+7)
set(lgd,'box','off')
set(lgd,'Interpreter','Latex');

xlabel('Time (minute)','FontSize',fontsize,'interpreter','latex')
ylabel('Flow rates in links (GPM)','FontSize',fontsize,'interpreter','latex')
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 16 8])
print(figure1,'FlowRates_net1','-depsc2','-r300');
end
