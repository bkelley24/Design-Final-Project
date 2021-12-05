%% CHEN 4520 Final Project - Pyrolysis Design - 11DEC2021

%%
clear
clc
clear figure

%% INITIAL CONDITIONS
flow_in = 1018; %kgmol/hr
C2H4Cl2_in = 0.9976 * flow_in; %kgmol/hr
C2H3Cl_in = 0; %kgmol/hr
HCl_in = 0.0008 * flow_in; %kgmol/hr
C2H2_in = 0; %kgmol/hr
C2H4_in = 0.0008 * flow_in; %kgmol/hr
H2_in = 0; %kgmol/hr
C4H6_in = 0; %kgmol/hr
C2H2Cl2_in = 0; %kgmol/hr
Cl2_in = 0; %kgmol/hr
C2H3Cl3_in = 0.0008 * flow_in; %kgmol/hr
T_in = 650 +273.15; %K
P_in = 2010; %kPa
IC = [C2H4Cl2_in C2H3Cl_in HCl_in C2H2_in C2H4_in H2_in C4H6_in C2H2Cl2_in Cl2_in C2H3Cl3_in T_in P_in];

volume_domain = linspace(0,10);


[Xsol, Ysol] = ode15s('Pyrolysis_Solver', volume_domain, IC);
%% Data Handling

C2H4Cl2_sol = Ysol(:,1); %kgmol/hr
C2H3Cl_sol = Ysol(:,2); %kgmol/hr
HCl_sol = Ysol(:,3); %kgmol/hr
C2H2_sol = Ysol(:,4); %kgmol/hr
C2H4_sol = Ysol(:,5); %kgmol/hr
H2_sol = Ysol(:,6); %kgmol/hr
C4H6_sol = Ysol(:,7); %kgmol/hr
C2H2Cl2_sol = Ysol(:,8); %kgmol/hr
Cl2_sol = Ysol(:,9); %kgmol/hr
C2H3Cl3_sol = Ysol(:,10); %kgmol/hr
T_sol = Ysol(:,11); % K
P_sol = Ysol(:,12); % kPa

conv = 0;
i = 1;
conv_C2H4Cl2 = (C2H4Cl2_in - C2H4Cl2_sol)/(C2H4Cl2_sol);
    
%% Plotting

figure(5);
plot(Xsol, C2H4Cl2_sol, 'Color', 'red');
hold on
plot(Xsol, C2H3Cl_sol, 'Color', 'green');
hold on
plot(Xsol, HCl_sol, 'Color', 'blue');
hold on
plot(Xsol, C2H2_sol, 'Color', 'magenta');
hold on
plot(Xsol, C2H4_sol, 'Color', 'cyan');
hold on
plot(Xsol, H2_sol, 'Color', 'yellow');
hold on
plot(Xsol, C4H6_sol, 'Color', 'black');
hold on
plot(Xsol, C2H2Cl2_sol, 'Color', 'black', 'LineStyle', '--');
hold on
plot(Xsol, Cl2_sol, 'Color', 'black', 'LineStyle', '--');
hold on
plot(Xsol, C2H3Cl3_sol, 'Color', 'black', 'LineStyle', '--');
hold on

xlabel('Reactor Volume (m^3)');
ylabel('Flow Rates (kgmol/hr)');
xlim([0 10]);
title('Species Flow Rate vs Reactor Volume');
legend('C2H4Cl2','C2H3Cl','HCl','C2H2','C2H4','H2','C4H6','C2H2Cl2', 'Cl2', 'C2H3Cl3');

figure(2);
plot(Xsol, P_sol, 'Color', 'red');
hold on
xlabel('Reactor Volume (m^3)');
ylabel('Pressure (kPa)');
title('Pressure vs Reactor Volume');

figure(3);
plot(Xsol, T_sol, 'Color', 'red');
hold on
xlabel('Reactor Volume (m^3)');
ylabel('Temperature (K)');
xlim([0 10])
title('Temperature of Process Stream vs Reactor Volume')

