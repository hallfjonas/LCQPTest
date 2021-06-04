%% Clear
close all; clear all; clc;

%% Create Performance Plots
data_file = 'saved_variables/OOUC.mat';

% Load solvers
load(data_file);

% Number of active solvers and problems
ns = 0;
np = 0;

% Get active solvers
active_solvers = containers.Map;
fn = fieldnames(solvers);
for k=1:numel(fn)
    if( solvers.(fn{k}).use )
        ns = ns + 1;
        np = length(solvers.(fn{k}).time_vals);
        
        active_solvers(fn{k}) = solvers.(fn{k});
    end
end

% Allocate 
t = zeros(np, ns);
best_time = zeros(np,1);
rel_time = zeros(np, ns);
solved = zeros(np, ns);
obj_val = zeros(np, ns);
compl_viol = zeros(np, ns);

% Obtain absolute times, objective values and compl_viol.
active_solver_names = active_solvers.keys;
for j = 1:ns       
    % Get solution struct
    solution_struct = active_solvers(active_solver_names{j});

    % Get absolute solution time
    t(:,j) = solution_struct.time_vals;

    % Get objective and complementarity values
    obj_val(:,j) = solution_struct.obj_vals;
    compl_viol(:,j) = solution_struct.compl_vals;

    % Check if solved (zero exit flag and van. compl.)
    ex_flag = (solution_struct.exit_flag == 0);
    solved(:,j) = ex_flag & (compl_viol(:,j) < 1e-5); 
end

% Obtain failed time (is apparently independent of choice)
failed_time = max(max(t))+1;

% Obtain relative times to best
for i = 1:np
    best_time(i) = min(t(i,:));
    for j = 1:ns
        if (~solved(i,j))
            rel_time(i,j) = failed_time;
        else
            rel_time(i,j) = t(i,j)/best_time(i);
        end
    end 
end

% Obtain rho
tau = linspace(1, failed_time, 200);
rho = zeros(length(tau), ns);
for j = 1:ns
    for k = 1:length(tau)
        rho(k,j) = sum(rel_time(:,j) <= tau(k))/np;
    end
end

%% Plot Section
% Set to latex
set(groot,'defaultAxesTickLabelInterpreter','latex');
set(groot,'defaulttextinterpreter','latex');
set(groot,'defaultLegendInterpreter','latex');

%% Figure 1: Relative performance plot
figure(1); box on; grid on;
for j = 1:ns
    stairs(tau, rho(:,j)); hold on;
end
xlim([1, failed_time]);
xlabel("$\tau$");
ylabel("$P(r(p,s) \leq \tau)$");
legend(active_solver_names);
  
    