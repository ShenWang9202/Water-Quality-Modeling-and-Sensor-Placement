function plotNodeConcentrations(NodeID4Legend,QsN_Control)
figure1 = figure
fontsize = 43;
plot(QsN_Control,'LineWidth',3.5);
xticks([0 360 720 1080 1440])
yticks([0 0.8 2 3])
xlim([0,1440])
%ylim([200,900]);
set(gca, 'TickLabelInterpreter', 'latex','fontsize',fontsize);
lgd = legend(NodeID4Legend,'Location','Best','Interpreter','Latex','Orientation','horizontal');
lgd.FontSize = fontsize;
%title('$h^{M} = s^2 (h_0 - r (q/s)^{\nu})$','interpreter','latex','FontSize',fontsize+7)
set(lgd,'box','off')
set(lgd,'Interpreter','Latex');

xlabel('Time (minute)','FontSize',fontsize,'interpreter','latex')
ylabel('Concentrations at nodes (mg/L)','FontSize',fontsize,'interpreter','latex')
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 16 5])
print(figure1,'NodeConcentrations','-depsc2','-r300');
end

