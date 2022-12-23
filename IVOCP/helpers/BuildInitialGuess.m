function [w0] = BuildInitialGuess(ode, init_value, nz, h, N)

import casadi.*;

xk = init_value;
zk = zeros(nz,1);

w0 = xk;

for j=2:N+1    

    % "Solve" algebraic equations
    if (xk > 0) 
        zk(1) = 1;
        zk(2) = xk;
    else
        zk(1) = 0;
        zk(2) = -xk;
    end
    
    % Do integration step
    xk = xk + h*full(ode(xk, zk));
    
    w0 = [w0; xk; zk];
end