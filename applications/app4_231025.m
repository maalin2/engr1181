%% problem 1
density = 1.225;
area = 38013;
vel = 0:20;

p_input = 0.5 * density * area * vel .^ 3;

figure(1)
x = vel;
y = p_input;
plot(x,y);
title("Power vs wind velocities");
xlabel("Wind velocity / m/s");
ylabel("Power / W");

%% problem 2
data = load("WindTurbineSampleData.mat");

% using data markers since we are plotting measured data, plotting the 
% wind turbine output vs number of blades
figure(2)
hold on;
x = [2,3,6];
y1 = PitchVBladesatTopPower(1,:);
y2 = PitchVBladesatTopPower(2,:);
plot(x,y1, "--ro")
plot(x,y2, "--bo")
title('Pitch angle and blade configuration''s effect on power output')
xlabel('Number of blades')
ylabel('Maximum power output / W')
legend(["30 degrees", "45 degrees"])
hold off;

% plotting wind turbine output (y) vs wind speeds for 2 3 and 6 blades
figure(3)
hold on;
x1 = WSvPowerWith2Blades(1,:);
x2 = WSvPowerWith3Blades(1,:);
x3 = WSvPowerWith6Blades(1,:);
y1 = WSvPowerWith2Blades(2,:);
y2 = WSvPowerWith3Blades(2,:);
y3 = WSvPowerWith6Blades(2,:);
plot(x1,y1,"--ro")
plot(x2,y2,"--bo")
plot(x3,y3,"--go")
title("Speed's effect on power output")
xlabel("Measured wind speed / m/s")
ylabel("Power output / W")
legend('2 blades', '3 blades', '6 blades')
hold off;

% using the subplot function to same information as figure 3 in seperated
% graphs within the same window
figure(4);
subplot(3,1,1);

plot(x1,y1, "--ro");
title("Speed's effect on power output for 2 blades")
xlabel("Measured wind speed / m/s")
ylabel("Power output / W")
subplot(3,1,2);

plot(x2,y2, "--bo");
title("Speed's effect on power output for 3 blades")
xlabel("Measured wind speed / m/s")
ylabel("Power output / W")
subplot(3,1,3);

plot(x3,y3, "--go");
title("Speed's effect on power output for 6 blades")
xlabel("Measured wind speed / m/s")
ylabel("Power output / W")