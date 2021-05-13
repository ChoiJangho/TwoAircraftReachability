clear all
close all

%% Creating grids.
grid_min = [-25; -25];
grid_max = [25; 25];
N = [81; 81];
g_mode13 = createGrid(grid_min, grid_max, N);

omega = 1;
grid_min = [-25; -25; 0];
grid_max = [25; 25; pi];
N = [81; 81; 31];
g_mode2 = createGrid(grid_min, grid_max, N);

R = 5;
data0_mode13 = shapeCylinder(g_mode13, [], [0; 0], R);
data0_mode2 = shapeCylinder(g_mode2, 3, [0; 0; 0], R);

dt = 0.05;
tMax = 10;
% tMax2 = pi/omega;
tMax2 = 30;
tau13 = 0:dt:tMax;
tau2 = 0:dt:tMax2;

uRange = [5; 5];
dRange = [5; 5];
omega = 0.5;
psir = 2*pi/3;

dynsys13 = TwoAirCraft([], 1, uRange, dRange, [], psir, 1:2);
dynsys2 = TwoAirCraft([], 2, uRange, dRange, [], psir, 1:3);

%% Initialization
data_mode1 = data0_mode13;
data_mode2 = data0_mode2;
data_mode3 = data0_mode13;
eval_convergence = false;

%% Main Algorithm
iter = 0;
while (~eval_convergence && iter < 5)
    %% Evaluating controllable predecessor
    data_avoid_mode1 = dynsys13.ctrlPredecessor(g_mode13, g_mode2, data_mode2);
    %% Evaluating uncontrollable predecessor
    [data_reach_mode1, data_reach_mode2, data_reach_mode3] = dynsys13.unctrlPredecessor( ...
        g_mode13, g_mode2, data_mode1, data_mode2, data_mode3);
    
    %% Calculating Reach-avoid set in mode 1
    schemeData.grid = g_mode13;
    schemeData.dynSys = dynsys13;
    schemeData.accuracy = 'high'; %set accuracy
    schemeData.uMode = 'min';
    schemeData.dMode = 'max';
    extraArgs_mode1.targetFunction = data_reach_mode1;
    extraArgs_mode1.obstacleFunction = -data_avoid_mode1;
    [data_mode1_new, ~, ~] = ...
      HJIPDE_solve(data_reach_mode1, tau13, schemeData, 'minVWithL', extraArgs_mode1);
    data_mode1_new = squeeze(data_mode1_new(:, :, end));
    
    %% Calculating Reach set in mode 2
    schemeData2.grid = g_mode2;
    schemeData2.dynSys = dynsys2;
    schemeData2.accuracy = 'high'; %set accuracy
    schemeData2.uMode = 'min';
    schemeData2.dMode = 'max';
    extraArgs_mode2.targetFunction = data_reach_mode2;
    extraArgs_mode2.keepLast = true;
    [data_mode2_new, ~, ~] = ...
      HJIPDE_solve(data_reach_mode2, tau2, schemeData2, 'minVWithL', extraArgs_mode2);    
%     data_mode2_new = squeeze(data_mode2_new(:, :, :, end));

    %% Calculating Reach set in mode 3
    extraArgs_mode3.targetFunction = data_reach_mode3;
    [data_mode3_new, ~, ~] = ...
      HJIPDE_solve(data_reach_mode3, tau13, schemeData, 'minVWithL', extraArgs_mode3);
    data_mode3_new = squeeze(data_mode3_new(:, :, end));
    
    %% visualization of the current iteration
    figure;
    subplot(1, 3, 1);
    visSetIm(g_mode13, data_reach_mode1, 'r', 0); hold on;
    visSetIm(g_mode13, data_avoid_mode1, 'b', 0); hold on;
    visSetIm(g_mode13, data_mode1_new, 'g', 0);
    subplot(1, 3, 2);
    visSetIm(g_mode2, -data_reach_mode2, 'r', 0); hold on;
    visSetIm(g_mode2, -data_mode2_new, 'g', 0);
    
    subplot(1, 3, 3);
    visSetIm(g_mode13, data_reach_mode3, 'r', 0); hold on;
    visSetIm(g_mode13, data_mode3_new, 'g', 0); 
    
    iter = iter + 1;
    fprintf("End of iteration %d\n", iter);
    %% Evaluation of the convergence
    if all(sign(data_mode1) == sign(data_mode1_new), 'all') && ...
            all(sign(data_mode2) == sign(data_mode2_new), 'all') && ...
            all(sign(data_mode3) == sign(data_mode3_new), 'all')
        eval_convergence = true;
        disp("The algorithm converged!");
    end
    
    data_mode1 = data_mode1_new;
    data_mode2 = data_mode2_new;
    data_mode3 = data_mode3_new;   
end
