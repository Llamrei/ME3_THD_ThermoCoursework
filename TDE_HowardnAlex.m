clear

%%Array to store results
tInput = 1;
pInput = 2;
sInput = 3;
hInput = 4;

Tpsh = zeros(24,4); %Kelvins, Bar

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

%%Steam cycle
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
