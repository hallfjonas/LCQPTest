function [y0] = GetDualGuess(LCQP, x0)

y0 = zeros(length(x0) + size(LCQP.A, 1) + 2*size(LCQP.L, 1), 1);    

for i = 1:length(x0)
    if (LCQP.ub(i) - x0(i) < eps)
        y0(i) = -1;
    elseif (x0(i) - LCQP.lb(i) < eps)
        y0(i) = 1;
    end
end

for i = 1:size(LCQP.A, 1)
    if (LCQP.ubA(i) - LCQP.A(i,:)*x0 < eps)
        y0(length(x0) + i) = -1;
    elseif (LCQP.A(i,:)*x0 - LCQP.lbA(i) < eps)
        y0(length(x0) + i) = 1;
    end
end

% For now initialize all compl. constr. 
% for i = 1:size(LCQP.L, 1)
%     if (LCQP.L(i,:)*x0 < eps)
%         y0(length(x0) + size(LCQP.A, 1) + i) = -1;
%     end
%     
%     if (LCQP.R(i,:)*x0 < eps)
%         y0(length(x0) + size(LCQP.A, 1) + size(LCQP.L, 1) + i) = -1;
%     end
% end

end