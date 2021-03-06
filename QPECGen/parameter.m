function [...
    qpec_type, ...
    n, ...
    m, ...
    l, ...
    p, ...
    cond_P, ...
    scale_P, ...
    convex_f, ...
    symm_M, ...
    mono_M, ...
    cond_M, ...
    scale_M, ...
    second_deg, ...
    first_deg, ...
    mix_deg, ...
    tol_deg, ...
    constraint, ...
    random ...
] = parameter

qpec_type = 100;
n = 200;
m = 200;
l = 70;
p = 50;
cond_P = 2;
scale_P = 2;
convex_f = 1;
symm_M = 0;
mono_M = 0;
cond_M = 1;
scale_M = 1;
second_deg = 1;
first_deg = 0;
mix_deg = 0;
tol_deg = 10e-10;
constraint = 1;
random = round(rand()*5000);

disp("HELLo");
disp(n);

end