%% CHEN 4520 Final Project - Pyrolysis Design SOLVER - 11DEC2021
function [Pyrolysis_ode] = Pyrolysis_Solver(X, Y)
%% Output Variables
C2H4Cl2 = Y(1);
C2H3Cl = Y(2);
HCl = Y(3);
C2H2 = Y(4);
C2H4 = Y(5);
H2 = Y(6);
C4H6 = Y(7);
C2H2Cl2 = Y(8);
Cl2 = Y(9);
C2H3Cl3 = Y(10);
T = Y(11);
P = Y(12);

%%Internal Variables
Tr = 773.15; %K
u_pyrolysis = 500; %w/m^2K
D = 1; %m
%% Energy Vars
%delta T over reactor is not large enough to make these non constant
H1f = 74.601; %kJ/mol
H1r = -H1f; %kJ/mol
H2f = 107.044; %kJ/mol
H2r = -H2f; %kJ/mol
H3 = 189.946; %kJ/mol
H4f = 179.592; %kJ/mol
H4r = -H4f; %kJ/mol
H5f = -185.566; %kJ/mol
H5r = -H5f; %kJ/mol
H6f = -74.083; %kJ/mol
H6r = -H6f; %kJ/mol

cP_C2H4Cl2 = 0.1378*1000; %kJ/molK
cP_C2H3Cl = 0.0990*1000; %kJ/molK
cP_HCl = 0.0328*1000; %kJ/molK
cP_C2H2 = 0.0697*1000; %kJ/molK
cP_C2H4 = 0.1018*1000; %kJ/molK
cP_H2 = 0.0310*1000; %kJ/molK
cP_C4H6 = 0.1551*1000; %kJ/molK
cP_C2H2Cl2 = .0651*1000; %kJ/molK
cP_Cl2 = 0.00376*1000; %kJ/molK
cP_C2H3Cl3 = 0.1480*1000; %kJ/molK

%% Rxn Vars
% Arrhenius values from Lakshamann
k1f = 10^(13.6)*exp(-58000/(1.987*T)); %s^-1
k1r = 0.3*10^(9)*exp(-44000/(1.987*T));%m^3/kmol-s
k2f = 0.5*10^(14)*exp(-69000/(1.987*T)); %s^-1
k2r = 0.37*10^(9)*exp(-40000/(1.987*T));%m^3/kmol-s
k3 = 10^(13)*exp(-72000/(1.987*T)); %s^-1
k4f = 0.1*10^(15)*exp(82000/(1.987*T)); %m^3/kmol-s
k4r = 0.8*10^(9)*exp(-38000/(1.987*T));%m^3/kmol-s
k5f = 0.15*10^(9)*exp(-32000/(1.987*T)); %m^3/kmol-s
k5r = 0.5*10^(13)*exp(-73000/(1.987*T));%s^-1
k6f = 0.2*10^(14)*exp(-58000/(1.987*T)); %s^-1
k6r = 0.3*10^(9)*exp(-44000/(1.987*T)); %m^3/kmol-s

% Concentrations
total_flow = C2H4Cl2 + C2H3Cl + HCl + C2H2 + C2H4 + H2 + C4H6 + C2H2Cl2 + Cl2 + C2H3Cl3; 
Rgas = 8.314; %m^3kPa/kmol-k
c_C2H4Cl2 = C2H4Cl2/total_flow*P/Rgas/T; %kgmol/hr
c_C2H3Cl = C2H3Cl/total_flow*P/Rgas/T; %kgmol/hr
c_HCl = HCl/total_flow*P/Rgas/T;
c_C2H2 = C2H2/total_flow*P/Rgas/T;
c_C2H4 = C2H4/total_flow*P/Rgas/T;
c_H2 = H2/total_flow*P/Rgas/T;
c_C4H6 = C4H6/total_flow*P/Rgas/T;
c_C2H2Cl2 = C2H2Cl2/total_flow*P/Rgas/T;
%c_Cl2 = Cl2; Don't need?
c_C2H3Cl3 = C2H3Cl3/total_flow*P/Rgas/T;

%Rate equations

r1f = k1f * c_C2H4Cl2*3600;
r1r = k1r * c_C2H3Cl * c_HCl*3600;
r2f = k2f * c_C2H3Cl*3600;
r2r = k2r * c_C2H2 * c_HCl*3600;
r3 = k3 * c_C2H4Cl2*3600;
r4f = k4f * c_C2H4*3600;
r4r = k4r * c_C2H2 * c_H2*3600;
r5f = k5f * c_C2H2 * c_C2H4*3600;
r5r = k5r * c_C4H6*3600;
r6f = k6f * c_C2H3Cl3*3600;
r6r = k6r * c_C2H2Cl2 * c_HCl*3600;

%Differentials for Solver
dC2H4Cl2 = -r1f + r1r -r3;
dC2H3Cl = r1f -r1r - r2f + r2r;
dHCl = r1f - r1r + r2f - r2r + r6f - r6r;
dC2H2 = r2f - r2r + r3 + r4f - r4r - r5r + r5f;
dC2H4 = -r4f + r4r - r5f + r5r; 
dH2 = r4f - r4r;
dC4H6 = r5f - r5r;
dC2H2Cl2 = r6f - r6r;
dCl2 = r3;
dC2H3Cl3 = -r6f + r6r;

%4/d in fogler

%Inner thermal balance
a_HT = 4/D; % will change
sumrH = (r1f*H1f + r1r*H1r + r2f*H2f + r2r*H2r + r3*H3 + r4f*H4f + r4r*H4r + r5f*H5f + r5r*H5r + r6f*H6f + r6r*H6r); 
sumFcp = (C2H4Cl2*cP_C2H4Cl2 + C2H3Cl*cP_C2H3Cl + HCl*cP_HCl + C2H2*cP_C2H2 + C2H4*cP_C2H4 + H2*cP_H2 + C4H6*cP_C4H6 + C2H2Cl2*cP_C2H2Cl2 + Cl2*cP_Cl2 + C2H3Cl3*cP_C2H3Cl3);
dT = -(sumrH - (u_pyrolysis*a_HT*(Tr-T)))/sumFcp;
%% Final ODE Matrix
L=10;
dP = -20/L;
Pyrolysis_ode = [dC2H4Cl2; dC2H3Cl; dHCl; dC2H2;
    dC2H4; dH2; dC4H6; dC2H2Cl2; dCl2; dC2H3Cl3; dT; dP];

end
