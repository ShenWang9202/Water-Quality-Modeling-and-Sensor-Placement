
NodeID4Legend = Variable_Symbol_Table2(NodeIndex,1);
LinkID4Legend = Variable_Symbol_Table2(LinkIndex,1);
% figure
% plot(JunctionActualDemand)


% %plot(QsN_Control)
% plot(X_node_control_result);
plotJunction

plotPipe

figure
%plot(QsL_Control)
plot(X_link_control_result);
legend(LinkID4Legend)
xlabel('Time (minute)')
ylabel('Concentrations in links (mg/L)')

figure
plot(JunctionActualDemand)
xlabel('Time (minute)')
ylabel('Demand at junctions (GPM)')

legend(NodeID4Legend)

figure
plot(ControlActionU(:,BoosterLocationIndex))
legend(Location_B)
xlabel('Time (minute)')
ylabel('Mass at boosters (mg/minute)')

figure
plot(Flow)
legend(LinkID4Legend)
xlabel('Time (minute)')
ylabel('Flow rates in links (GPM)')

disp('Summary:')
disp(['Demand uncertainty is: ',num2str(DEMAND_UNCERTAINTY)]);
disp(['Unknown uncertainty is: ',num2str(UNKNOW_UNCERTAINTY)]);
disp(['Parameter uncertainty is: ',num2str(PARAMETER_UNCERTAINTY)]);