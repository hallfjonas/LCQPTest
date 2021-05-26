function [ x ] = BuildInitialGuessEuler( fun, init_value, h, N )

x = zeros(N,1);
x(1) = init_value;
for i = 2:N
    x(i) = x(i-1) + h*fun(x(i-1));
end

end