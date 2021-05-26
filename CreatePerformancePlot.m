%% Create Performance Plots
problem_files = dir('saved_variables/*.mat');

if (isempty(problem_files))
    return;
end    

% First fill solvers
load(['saved_variables/', problem_files(1).name]);
solvers = solution_map.keys;

ns = length(solvers);
np = length(problem_files);

t = zeros(np, ns);
best_time = zeros(np,1);
rel_time = zeros(np, ns);
solved = zeros(np, ns);
obj_val = zeros(np, ns);
compl_viol = zeros(np, ns);

% Obtain absolute times, objective values and compl_viol.
for i = 1:length(problem_files)
    load(['saved_variables/', problem_files(i).name]);
    for j = 1:length(solvers)       
        % Get solution struct
        solution_struct = solution_map(solvers{j});
        
        % Get absolute solution time
        t(i,j) = solution_struct.time_vals;        
        
        % Get objective and complementarity values
        obj_val(i,j) = solution_struct.obj_vals;
        compl_viol(i,j) = solution_struct.compl_vals;
        
        % Check if solved (zero exit flag and van. compl.)
        ex_flag = (solution_struct.exit_flag == 0);
        solved(i,j) = (ex_flag && compl_viol(i,j) < 1e-10);        
    end 
end

% Obtain failed time (is apparently independent of choice)
failed_time = max(max(t))+1;

% Obtain relative times to best
for i = 1:length(problem_files)
    best_time(i) = min(t(i,:));
    for j = 1:length(solvers)
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
legend(solvers);
  
    