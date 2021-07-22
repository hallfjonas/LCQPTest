function [] = PlotTimings(problems)

% Number of problems
np = length(problems);

% Number of solvers (assume each problem has same set of solvers)
ns = length(problems{1}.solutions);

% Store solver timings per problem
t = zeros(np, ns);
f = zeros(np, ns);

% Failed solutions
exit_flag = zeros(np, ns);

% Performance ratios (assume all problems solved with same solvers)
rt = zeros(np, ns);
rf = zeros(np, ns);

% Store minimum time per problem
min_t_per_problem = inf(np,1);
max_t_per_problem = -inf(np,1);
min_f_per_problem = inf(np,1);
max_f_per_problem = -inf(np,1);

% First get the minimum solution time for each problem
for p = 1:np
    problem = problems{p};
    for s = 1:ns
        solution = problem.solutions{s};
        
        t(p,s) = solution.stats.elapsed_time;
        f(p,s) = solution.stats.obj;
        exit_flag(p,s) = solution.stats.exit_flag;
        
        % Update mins and max if solved
        if (exit_flag(p,s) == 0)
            % Update minimum time
            if (t(p,s) < min_t_per_problem(p))
                min_t_per_problem(p) = t(p,s);
            end
        
            % Update minimum objective
            if (f(p,s) < min_f_per_problem(p))
                min_f_per_problem(p) = f(p,s);
            end     

            % Update maximum time        
            if (t(p,s) > max_t_per_problem(p))
                max_t_per_problem(p) = t(p,s);
            end
            
            % Update max obj
            if (f(p,s) > max_f_per_problem(p))
                max_f_per_problem(p) = f(p,s);
            end       
        end
    end
end

%% TODO: WHAT IF ALL FAIL??
%% TODO: CURRENTLY LOOKS LIKE SNOPT IS WINNING BUT WE WIN MOST OF THE TIME ...

% Then get the performance ratio
for p = 1:np
    for s = 1:ns        
        % Failed solutions are set to max val
        if (exit_flag(p,s) ~= 0)
            t(p,s) = max(max_t_per_problem) + 1;
            f(p,s) = max(max_f_per_problem) + 1;
        end
        
        % Bring objective value >= 1
        f(p,s) = 1 - min_f_per_problem(p);
                
        % Compute ratio
        rt(p,s) = t(p,s)/min_t_per_problem(p);
        rf(p,s) = f(p,s)/min_f_per_problem(p);         
    end
end

% Then get the performance profile (of time)
taut = unique(sort(reshape(rt, np*ns, 1)));
rhot = zeros(ns, length(taut));
for t = 1:length(taut)
    for s = 1:ns
        rhot(s,t) = 1/np*length(find(rt(:,s) <= taut(t)));
    end
end

% Then get the performance profile (of objective)
tauf = unique(sort(reshape(rf, np*ns, 1)));
rhof = zeros(ns, length(tauf));
for t = 1:length(tauf)
    for s = 1:ns
        rhof(s,t) = 1/np*length(find(rf(:,s) <= tauf(t)));
    end
end        

%% Create the plot
% Set to latex
set(groot,'defaultAxesTickLabelInterpreter','latex');
set(groot,'defaulttextinterpreter','latex');
set(groot,'defaultLegendInterpreter','latex');

figure; hold on; box on; grid on;
for s=1:ns
    solver = problems{1}.solutions{s}.solver;
    
    plot( ...
        taut, rhot(s,:),  ...
        'DisplayName', solver.name, ...
        'LineStyle', solver.lineStyle, ...
        'Color', solver.color ...
    ); hold on;
end
xlabel('$\tau$');
ylabel('$\rho$');
legend();

figure; hold on; box on; grid on;
for s=1:ns
    solver = problems{1}.solutions{s}.solver;
    
    plot( ...
        tauf, rhof(s,:), ...
        'DisplayName', solver.name, ...
        'LineStyle', solver.lineStyle, ...
        'Color', solver.color ...
    );
        hold on;
end
xlabel('$\tau$');
ylabel('$\rho$');
set(gca,'yscale','log');
legend();

end

