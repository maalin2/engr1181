% Calculates area of triangle and estimates difference in power output 
% between maximum efficiency and observed efficiency Haliade-X wind
% turbine.

clc
clear

%Problem 1: warmup
b=2; 
h=4; 
areaTriangle = 0.5 * (b * h); 
fprintf('The right-angled triangle has area = %.1f m^2\n\n',areaTriangle); 

%Problem 2 
density = 1.225; 

% wind velocities from 0 to 20
velWind = 0:20; 

% radius = given diameter/2
radius = 110;

%rotor swept area
area = pi * (radius ^ 2);

pIn = (0.5 * density * area) * (velWind .^ 3);

% observed efficiency components
effAero = 0.397; 
effMech = 0.96; 
effElec = 0.94; 

% observed efficiency
pCoeffObs = effAero * effMech * effElec;
pOutObs = pCoeffObs * pIn;

% maximum efficiency according to betz's law
pCoeffMax = 0.593;
pOutMax = pCoeffMax * pIn;

% difference
percentDiff = 100 * ((pOutMax - pOutObs) ./ pOutObs);

%several million watts of total power so units are in megawatts
pOutMaxMW = (1/ 1000000) * pOutMax;
pOutObsMW = (1/ 1000000) * pOutObs;

% formatted output
fprintf("At a wind velocity of %d m/s the results for the Haliade-X" + ...
    " turbine are as follows:\n",velWind(13));
fprintf("The output power generated is %.2f megawatts\n", pOutObsMW(13));
fprintf("The theoretical maximum output power that can be generated" + ...
    " according to Betz's law is %.2f megawatts\n", pOutMaxMW(13));
fprintf("The percentage difference between the output power generated" + ...
    " and the theoretical maximum output power is %.2f%%.\n", percentDiff(13));
 