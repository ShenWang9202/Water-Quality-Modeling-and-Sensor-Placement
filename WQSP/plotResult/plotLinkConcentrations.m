function plotLinkConcentrations(LinkID4Legend,QsL_Control)
figure1 = figure
fontsize = 36;
plot(QsL_Control,'LineWidth',3);
xticks([0 360 720 1080 1440])
yticks([0 1.4 2 3])
xlim([0,1440])
%ylim([200,900]);
set(gca, 'TickLabelInterpreter', 'latex','fontsize',fontsize);
lgd = legend(LinkID4Legend,'Location','Best','Interpreter','Latex','Orientation','horizontal');
lgd.FontSize = fontsize;
%title('$h^{M} = s^2 (h_0 - r (q/s)^{\nu})$','interpreter','latex','FontSize',fontsize+7)
set(lgd,'box','off')
set(lgd,'Interpreter','Latex');

xlabel('Time (minute)','FontSize',fontsize,'interpreter','latex')
ylabel('Concentrations in links(mg/L)','FontSize',fontsize,'interpreter','latex')
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 16 8])
print(figure1,'LinkConcentrations','-depsc2','-r300');
end