clear

last2CID = 23;
Y = mod(last2CID, 10);
X = Y + (last2CID - Y)/10;

%% Array to store results
tInput = 1;
pInput = 2;
sInput = 3;
hInput = 4;

Tpsh = zeros(25,4); %Kelvins, Bar
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

%% SOFC solutions
% Compressor
comp_Rp = 23;   %GBC
Tpsh(1,sInput) = 11027.23; %J/kg/K - from GASEQ
Tpsh(1,hInput) = -4352.96; %J/kg/K - from GASEQ, of formation
Tpsh(4,pInput) = comp_Rp * Tpsh(1,pInput); %GBC
Tpsh(4,tInput) = 536;  %From Adiabatic compression of natural gas in gaseq - almost Isentropic
Tpsh(4,hInput) = -3739.55;  %J/kg/K - from GASEQ, of formation
Tpsh(4,sInput) = 11027.59;  %J/kg/K - from GASEQ
Tpsh(5,:) = Tpsh(4,:);  %ASSUMING connected pipes share intensive properties
Tpsh(25,:) = Tpsh(4,:);
Cp_4 = 2881.11; %J/kg/K - from GASEQ
Cp_25 = Cp_4;
Cp_5 = Cp_4;
mass_flowrate(4) = mass_flowrate(1);

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
% GASEQ used to solve: see Reformer.eq
Tpsh(7,:) = [800+273.1 23*atm 14725.55 -7321.93];

% SOFC
%Get the mass of air - ASSUMING conservation of mass
mass_flowrate(3) = mass_flowrate(2);
mass_flowrate(9) = mass_flowrate(3) - mass_flowrate(13);
mass_flowrate(10) = mass_flowrate(9);
%Get properties of air from second compressor - using GASEQ
Tpsh(2,hInput) = -10.04;
Tpsh(2,sInput) = 6826.13;
Tpsh(3,:) = [692 23 6825.94 406.7]; %From GASEQ
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
H2_MoleFlow_7 = H2_MassFlow_7/MW_H2;    %in Kmol

Fuel_Util = 0.7;
H2_MoleReactFlow = Fuel_Util*H2_MoleFlow_7;
O2_MoleReactFlow = 0.5*H2_MoleReactFlow;
O2_MassFrac_10 = 0.23156;
O2_MoleFlow_10 = mass_flowrate(10)*O2_MassFrac_10/MW_O2;
O2_MoleFlow_8 = O2_MoleFlow_10 - O2_MoleReactFlow;
H2_MoleFlow_8 = H2_MoleFlow_7 - H2_MoleReactFlow;
O2_Relative_H2_8_8 = O2_MoleFlow_8/H2_MoleFlow_8;
O2_Relative_H2_10_8 = O2_MoleFlow_10/H2_MoleFlow_8;

Tpsh(8,:) = [900+273.1 23*atm 9113.37 -2249.13];    %GASEQ
Cp_8 = 1578.83;

Tpsh(11,:) = [1940.9 23*atm 9740.3 -2249.13];       %GASEQ
Tpsh(12,:) = [1693.6 23*atm 9505.82 -2674.7];       %GASEQ



