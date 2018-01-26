%% SETUP
clear

last2CID = 23;
Y = mod(last2CID, 10);
X = Y + (last2CID - Y)/10;

%% Array to store results - fill in given values
tInput = 1;
pInput = 2;
sInput = 3;
hInput = 4;

Tpsh = zeros(25,4); %Kelvins, Bar, J/Kg, kJ/Kg
mass_flowrate = zeros(24,1);%Kg/s
atm = 1.013; %enable conversion of atm into bar

% info given filled out first
Tpsh(24,tInput) = 321.15;
Tpsh(23,1:2) = [283.15 1*atm];
Tpsh(22,tInput) = 292.15;
Tpsh(21,pInput) = 2.33*atm;
Tpsh(19,tInput) = 565.5+273.15;
Tpsh(18,pInput) = 23.58*atm;
Tpsh(17,1:2) = [838.65 122*atm];
Tpsh(16,1:2) = [155+273.15 1.01*atm];
Tpsh(2,1:2) = [15+273.15 1*atm];
Tpsh(1,1:2) = [15+273.15 1*atm];
Tpsh(15,pInput) = 1.026*atm;

mass_flowrate(1) = 23.9;
mass_flowrate(2) = 598.7;
mass_flowrate(5) = 14.9 + Y;
mass_flowrate(13) = 249.7 + X;

%% Steam cycle
%ASSUMING all conencted pipes share intensive properties
condensorPLoss = 0.15;   %GBC (Given by coursework)
HRSGWaterPLoss = 0.05;   %GBC
effPoly = 0.89;          %GBC
reheatFactor = 1.07; % ASSUMING from internet sources and comparing

%Fill pressures based on pressure losses
Tpsh(22,pInput) = Tpsh(21,pInput)*(1-condensorPLoss);
Tpsh(24,pInput) = Tpsh(17,pInput)/(1-HRSGWaterPLoss);

%Analyse turbines
Tpsh(17,sInput) = XSteam('s_pT', Tpsh(17,pInput), Tpsh(17,tInput) - 273.1); %Function takes in celsius
Tpsh(17,hInput) = XSteam('h_pT', Tpsh(17,pInput), Tpsh(17,tInput) - 273.1);

effIsen = effPoly * reheatFactor;
isenH18 = XSteam('h_ps',Tpsh(18,pInput),Tpsh(17,sInput));
Tpsh(18,hInput) = Tpsh(17,hInput) - effIsen*(Tpsh(17,hInput) - isenH18);
Tpsh(18,tInput) = XSteam('T_ph',Tpsh(18,pInput),Tpsh(18,hInput)) + 273.1;
Tpsh(19,pInput) = Tpsh(18,pInput); %ASSUMING no pressure loss in short HRSG
Tpsh(20,:) = Tpsh(19,:);  %ASSUMING constant intensive for pipe
%ASSUMING same isenEff as temp is same
Tpsh(20,sInput) = XSteam('s_pT', Tpsh(20,pInput), Tpsh(20,tInput) - 273.1);
Tpsh(20,hInput) = XSteam('h_pT', Tpsh(20,pInput), Tpsh(20,tInput) - 273.1);
isenH21 = XSteam('h_ps', Tpsh(21,pInput), Tpsh(20,sInput));
Tpsh(21,hInput) = Tpsh(20,hInput) - effIsen*(Tpsh(20,hInput) - isenH21);
Tpsh(21,tInput) = XSteam('T_ph',Tpsh(21,pInput),Tpsh(21,hInput)) + 273.1;

%Completed cycle, now just fill in all enthalpy and entropy for
%completeness
Tpsh(18,sInput) = XSteam('s_pT', Tpsh(18,pInput), Tpsh(18,tInput) - 273.1);
Tpsh(18,hInput) = XSteam('h_pT', Tpsh(18,pInput), Tpsh(18,tInput) - 273.1);
Tpsh(19,sInput) = XSteam('s_pT', Tpsh(19,pInput), Tpsh(19,tInput) - 273.1);
Tpsh(19,hInput) = XSteam('h_pT', Tpsh(19,pInput), Tpsh(19,tInput) - 273.1);
Tpsh(21,sInput) = XSteam('s_pT', Tpsh(21,pInput), Tpsh(21,tInput) - 273.1);
Tpsh(21,hInput) = XSteam('h_pT', Tpsh(21,pInput), Tpsh(21,tInput) - 273.1);
Tpsh(22,sInput) = XSteam('s_pT', Tpsh(22,pInput), Tpsh(22,tInput) - 273.1);
Tpsh(22,hInput) = XSteam('h_pT', Tpsh(22,pInput), Tpsh(22,tInput) - 273.1);
Tpsh(23,sInput) = XSteam('s_pT', Tpsh(23,pInput), Tpsh(23,tInput) - 273.1);
Tpsh(23,hInput) = XSteam('h_pT', Tpsh(23,pInput), Tpsh(23,tInput) - 273.1);
Tpsh(24,sInput) = XSteam('s_pT', Tpsh(24,pInput), Tpsh(24,tInput) - 273.1);
Tpsh(24,hInput) = XSteam('h_pT', Tpsh(24,pInput), Tpsh(24,tInput) - 273.1);
Tpsh(6,:) = Tpsh(19,:);  %ASSUMING constant intensive for pipe

%% NG/SOFC solutions
% Compressor - NG_Compressor.eq
comp_Rp = 23;   %GBC
Tpsh(1,sInput) = 11027.23; %J/kg/K - from GASEQ
Tpsh(4,sInput) = 11027.59;  %J/kg/K - from GASEQ
Tpsh(1,hInput) = -4352.96; %kJ/kg/K - from GASEQ, of formation
Tpsh(4,hInput) = -3739.55;  %kJ/kg/K - from GASEQ, of formation
Tpsh(4,pInput) = comp_Rp * Tpsh(1,pInput); %GBC
Tpsh(4,tInput) = 536;  %From Adiabatic compression of natural gas in GASEQ - almost Isentropic
Tpsh(5,:) = Tpsh(4,:);  %ASSUMING connected pipes share intensive properties
Tpsh(25,:) = Tpsh(4,:); %K
Cp_4 = 2881.11; %J/kg/K
Cp_25 = Cp_4;   %J/kg/K
Cp_5 = Cp_4;    %J/kg/K
mass_flowrate(4) = mass_flowrate(1);    %kg/s

% Split to reformer, conserve mass
mass_flowrate(25) = mass_flowrate(4) - mass_flowrate(5);    %stream 25 represents split before reformer

% Reformer - Assuming partial pressures are both ~23atm which means total
% pressure also 23atm
% Firstly, deduce mass flowrate of steam from 6
MW_H2O = 18;
MW_NG_4 = 17.27;
steam2Carb = 3;
mass_flowrate(6) = mass_flowrate(5)*(MW_H2O/MW_NG_4)*steam2Carb;
mass_flowrate(7) = mass_flowrate(5) + mass_flowrate(6);
% Then get property variation through the reformer
Tpsh(7,:) = [800+273.1 23*atm 14725.55 -7321.93];       %Reformer.eq

% SOFC
%Get the mass of air - ASSUMING conservation of mass
mass_flowrate(3) = mass_flowrate(2);
mass_flowrate(9) = mass_flowrate(3) - mass_flowrate(13);
mass_flowrate(10) = mass_flowrate(9);
%Get properties of air from second compressor - using GASEQ
Tpsh(2,hInput) = -10.04;
Tpsh(2,sInput) = 6826.13;
Tpsh(3,:) = [692 23*atm 6825.94 406.7]; %From GASEQ
%ASSUMING connected pipes share intensive properties
Tpsh(13,:) = Tpsh(3,:);
Tpsh(9,:) = Tpsh(3,:);
%Analyse change through heat exchanger
%ASSUMING no pressure loss across heat exchanger
HXpLoss = 0;
Tpsh(10,:) = [1073.15 Tpsh(9,pInput)*(1-HXpLoss) 7314.41 832.25];

% Calculate no. of moles of H2 flowing into Anode
MW_H2 = 2;
MW_O2 = 32;
H2_MassFrac_7 = 0.06843;
H2_MassFlow_7 = mass_flowrate(7)*H2_MassFrac_7;
H2_MoleFlow_7 = H2_MassFlow_7/MW_H2;    %Kmol

Fuel_Util = 0.7;
H2_MoleReactFlow = Fuel_Util*H2_MoleFlow_7; %Kmol
O2_MoleReactFlow = 0.5*H2_MoleReactFlow;    %Kmol
O2_MassFrac_10 = 0.23156;                   %Kg
O2_MoleFlow_10 = mass_flowrate(10)*O2_MassFrac_10/MW_O2; %Kmol
O2_MoleFlow_8 = O2_MoleFlow_10 - O2_MoleReactFlow;       %Kmol
H2_MoleFlow_8 = H2_MoleFlow_7 - H2_MoleReactFlow;        %Kmol
O2_Relative_H2_8_8 = O2_MoleFlow_8/H2_MoleFlow_8;        % -
O2_Relative_H2_10_8 = O2_MoleFlow_10/H2_MoleFlow_8;      % - 

Tpsh(8,:) = [900+273.1 23*atm 9113.37 -2249.13];    %GASEQ - composition 8.eq
mass_flowrate(8) = mass_flowrate(7) + mass_flowrate(10); %Assuming negligible electron mass loss
Cp_8 = 1578.83;

%Afterburner
Tpsh(11,:) = [1940.9 23*atm 9740.3 -2249.13];       %GASEQ - Adiabatic - Afterburner.eq

%Heat Exchanger
% Remember to account for total enthalpy not specific
Tpsh(12,:) = [1737 23*atm 9505.82 -2600.7];       %GASEQ - Iteration to find right enthalpy for pressure
mass_flowrate(11) = mass_flowrate(8);
mass_flowrate(12) = mass_flowrate(11);

%% Gas Cycle
%Figure out combustor incoming mole ratios of streams for GASEQ flows -
%Mixtures.eq
MW_13 = 28.96;
MW_25 = 17.27;
MW_12 = 24.67;
MW_8 = 24.11;
%For putting into GASEQ
mole_flowrate_13 = mass_flowrate(13)/MW_13;
mole_flowrate_25 = mass_flowrate(25)/MW_25;
mole_flowrate_12 = mass_flowrate(12)/MW_12;
mass_flowrate(14) = mass_flowrate(13) + mass_flowrate(25) + mass_flowrate(12); 
%Modelling as constant pressure combustion and then pressure loss in
%piping or whatever for GASEQ const. P analysis, so both combustor and
%combuster_pressureloss are relevant
Tpsh(14,:) = [1852.9 23*atm*0.92 9079.58 -1481.82];   %GASEQ - Combuster.eq
mass_flowrate(15) = mass_flowrate(14); 
%Treating 14->15 as ideal gas (worst assumption as is ~15% drop in Cp)
Gamma_14 = 1.250;   %GASEQ
Tpsh(15,tInput) = Tpsh(14,tInput)*exp((Gamma_14 - 1)/(Gamma_14)*log(Tpsh(15,pInput)/Tpsh(14,pInput)));
Tpsh(15,sInput:hInput) = [9133.20 -2742.21];    %GASEQ - Composition 15.eq
Tpsh(16,sInput:hInput) = [8038.24 -3497.64];    %GASEQ - Composition 16.eq
mass_flowrate(16) = mass_flowrate(15);

% Using knowledge of mass flowrate and enthalpies of air can determine mass
% flowrate of water side
mass_flowrate(24) = -1*mass_flowrate(15)*(Tpsh(16,hInput)-Tpsh(15,hInput))...
    /((Tpsh(17,hInput)-Tpsh(24,hInput)) + (Tpsh(19,hInput)-Tpsh(18,hInput)));
mass_flowrate(17) = mass_flowrate(24);
mass_flowrate(18) = mass_flowrate(17);
mass_flowrate(19) = mass_flowrate(18);
mass_flowrate(20) = mass_flowrate(19) - mass_flowrate(6);
mass_flowrate(21) = mass_flowrate(20);
mass_flowrate(22) = mass_flowrate(21);
%Make up the difference in feed
mass_flowrate(23) = mass_flowrate(24) - mass_flowrate(22);
if(mass_flowrate(23) == mass_flowrate(6))
   disp('Masses check out'); 
end 

%% Question 2
% Volts per cell
s0_H2O = 188;    %J/(mol K)
h0_H2O = -241.8e3;  %J/mol
s0_H2 = 130.7;    %J/(mol K)
h0_H2 = 0;
s0_O2 = 205.2;
h0_O2 = 0;
Ohmic_Loss = 0.11;  %From graph
Activation_Loss = 0.37; %From Graph
FARADAY = 96485.3329;   %C/mol
electrons_released = 2;
MoR_H2 = 0.05664;    % Mole Ratio to flow
mol_H2 = 1;          % N
mol_O2 = 0.5;
mol_H2O = 1;
R_uni = 8.3144598;   % J/?(K?*mol)
AC_DC_eff = 0.93;
current_density = 0.5;  %A/cm^2
deltaH = h0_H2O - (0.5*h0_O2 + h0_H2);  %J/mol
deltaS = s0_H2O - (0.5*s0_O2 + s0_H2);  %J/mol
deltaG = deltaH - Tpsh(8,tInput)*deltaS; %J/mol
actual_deltaH = h0_H2O*H2_MoleReactFlow ...
    - (0.5*h0_O2*H2_MoleReactFlow+ h0_H2*H2_MoleReactFlow);    %kJ - as flow is kmol and h0 J/mol
actual_deltaS = H2_MoleReactFlow*(s0_H2O - (0.5*s0_O2 + s0_H2));    %kJ
actual_deltaG = actual_deltaH - Tpsh(8,tInput)*actual_deltaS;       %kJ
E0= -(deltaG/(electrons_released*FARADAY));     %V
Emax = -deltaH/(electrons_released*FARADAY);    %V
preLn = R_uni*Tpsh(8,tInput)/(electrons_released*FARADAY);  %V
%Not quite right
Cell_Voltage_Ideal = E0 - preLn*log((MoR_H2*0.7)^mol_H2O/((0.7*MoR_H2)^mol_H2*(MoR_H2*0.35)^mol_O2)) ...
    - preLn*log(23)^(mol_H2O-mol_H2-mol_O2);
Cell_Voltage_Real = Cell_Voltage_Ideal - (Ohmic_Loss + Activation_Loss);
charge_flowrate = 2*H2_MoleReactFlow*FARADAY*1000;  %A

% Get powers
DC_power = charge_flowrate*Cell_Voltage_Real;   %W
AC_power = AC_DC_eff * DC_power;                %W        
Thermal_power = -actual_deltaG*1000;            %W

% Get efficiencies
Cell_V_Eff = Fuel_Util*Cell_Voltage_Real/Emax;  % -
Cell_T_Eff = deltaG/deltaH;                     % - 
Active_area = charge_flowrate/current_density;  %cm^2
%Get GASEQ enthalpies and entropies for flow 6 to be able to evaluate
%change
Tpsh(6,sInput:hInput) = [11073.55 -12341.49];

%Get heat losses
Heat_Reformer = Tpsh(7,hInput)*mass_flowrate(7) ...
    - (Tpsh(6,hInput)*mass_flowrate(6) + Tpsh(5, hInput)*mass_flowrate(5)); %kJ - expect +ve
Heat_Cell = actual_deltaH - actual_deltaG;    %kJ - expect -ve
Heat_Ohms = -1*(Ohmic_Loss * charge_flowrate);
Net_Heat = Heat_Cell + Heat_Reformer + Heat_Ohms;        %kJ - expect -ve, watch out

%% Question 3
W_out_steam = -1*10^3*(mass_flowrate(18)*(Tpsh(18,hInput)-Tpsh(17,hInput))...
    + mass_flowrate(21)*(Tpsh(21,hInput)-Tpsh(20,hInput)))
W_out_air = -1*10^3*(mass_flowrate(15)*(Tpsh(15,hInput)-Tpsh(14,hInput)));
W_out_gross = AC_power + W_out_steam + W_out_air;
W_needed = -1*10^3*(mass_flowrate(4)*(Tpsh(4,hInput)-Tpsh(1,hInput))...
    + mass_flowrate(3)*(Tpsh(3,hInput)-Tpsh(2,hInput))...
    + mass_flowrate(24)*(Tpsh(24,hInput)-Tpsh(22,hInput))...
    + mass_flowrate(23)*(Tpsh(22,hInput)-Tpsh(23,hInput)));
W_out = W_out_gross + W_needed;

LHV = 49304e3;
Overall_eff = W_out/(mass_flowrate(1)*LHV);

%Emissions
MassR_CO2_16 = 0.11295;
MassR_NOx_16 = 6.67e-12 + 2.44e-9;
MassR_NOx_14 = 1.99e-3 + 1.17e-5;
kWh = 3.6*10^6;
emit_CO2 = mass_flowrate(16)*MassR_CO2_16/(W_out/kWh)*1000; %g/kWh
emit_NOx = mass_flowrate(16)*MassR_NOx_16/(W_out/kWh)*1000; %g/kWh


