
grid_min = [-20; -30];
grid_max = [20; 10];
% grid_min = [-20; -20];
% grid_max = [20; 20];
N = [201; 201];
g = createGrid(grid_min, grid_max, N);

R = 5;
data0 = shapeCylinder(g, [], [0; 0], R);

dt = 0.05;
tMax = 6;
tau = 0:dt:tMax;

uRange = [2; 4];
dRange = [1; 5];
% uRange = [5; 5];
% dRange = [5; 5];
% psir = 2*pi/3;
psir = pi/2;


dynsys = TwoAirCraft([], 1, uRange, dRange, [], psir);

uMode = 'max';
dMode = 'min';
schemeData.grid = g;
schemeData.dynSys = dynsys;
schemeData.accuracy = 'high'; %set accuracy
schemeData.uMode = uMode;
schemeData.dMode = dMode;
HJIextraArgs.targetFunction = data0;

[data, tau2, ~] = ...
  HJIPDE_solve(data0, tau, schemeData, 'minVWithL', HJIextraArgs);

figure;
visSetIm(g, squeeze(data(:, :, end)), 'g', 0);