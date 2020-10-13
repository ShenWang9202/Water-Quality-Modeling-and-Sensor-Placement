Water-Quality-Modeling-and-Sensor-Placement

This is the source code for our paper "Revisiting the Water Quality Sensor Placement Problem: Optimizing Network Observability and State Estimation Metrics"

Abstract: Real-time water quality (WQ) sensors in water distribution networks (WDN) have the potential to enable network-wide observability of water quality indicators, contamination event detection, and closed-loop feedback control of WQ dynamics. To that end, prior research has investigated a wide range of methods that guide the geographic placement of WQ sensors. These methods assign a metric for fixed sensor placement (SP) followed by metric-optimization to obtain optimal SP. These metrics include minimizing intrusion detection time, minimizing the expected population and amount of contaminated water affected by an intrusion event.  In contrast to the literature, the objective of this paper is to provide a  computational method that considers the overlooked metric of state estimation and network-wide observability of the WQ dynamics. This metric finds the optimal WQ sensor placement that minimizes the state estimation error via the Kalman filter for noisy WQ dynamics---a metric that quantifies WDN observability. To that end, the state-space dynamics of WQ states for an entire WDN are given and the observability-driven sensor placement algorithm is presented. The algorithm  takes into account the time-varying nature of WQ dynamics due to changes in the hydraulic profile.  Thorough case studies are given, highlighting key findings, observations, and recommendations for WDN operators. Github codes are included for reproducibility. 

This model is based on EPANET-Matlab-Toolkit (Version 2.1.8.1) which is a Matlab class for EPANET water distribution simulation libraries, please play with this toolkit before running this simulation, see https://github.com/OpenWaterAnalytics/EPANET-Matlab-Toolkit#How-to-use-the-Toolkit for details.

The functions are in WQSP folder, and click "run" in Matlab after loading Main.m. We now only give four examples (3-node, 8-node, Net1,Net3), but our code is general for all kinds of networks. The readers are welcome to extend their own examples.

The readers are suggested to test 3-node example first to ensure that all environments are set up, and the running time for 3-node is about 1 mins.

To help readers understand intuitively about the water quality modeling in state-space form and the observability (Gramian), a simple and clean Matlab file that shows step by step the observability (gramian) calculation, and the readers can execute the Matlab file step by step and check the results. The link is \url{https://github.com/ShenWang9202/Water-Quality-Modeling-and-Sensor-Placement/blob/master/WQSP/three_node_example.m}

The networks in case studies are located in network/ folder.
