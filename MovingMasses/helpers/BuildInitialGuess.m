function [w0] = BuildInitialGuess(ode, init_value, u_fixed, nz, h, N, nMasses, condensed)

import casadi.*;

xk = init_value;
zk = zeros(nz,1);

w0 = xk;

for i=2:N+1    
    
    % Do integration step
    xk = xk + h*full(ode(xk, u_fixed, zk));

    % "Solve" algebraic equations
    for i=1:nMasses
        if (xk(nMasses + i) > 0) 
            zk(nMasses + i) = xk(nMasses + i);
            zk(i) = 1;
        else
            zk(2*nMasses + i) = -xk(nMasses + i);
            zk(i) = 0;
        end
        zk(3*nMasses + i) = 1 - zk(i);
    end
    
    if (~condensed)
        w0 = [w0; u_fixed; xk; zk];
    else
        w0 = [w0; u_fixed; zk];
    end    
end