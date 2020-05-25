clear all;

N = 800;
iterations = 20;
t_e = 2;
t_c = 1;
t_r = 10;
p_i = 0.5;

% 1.4075    0.4049    1.6894    0.1428 from calibration
param = [1.4075    0.4049    1.6894    0.1428]
t_e = param(1);
t_c = param(2);
t_r = param(3);
p_i = param(4);


[t_mean, x_mean] = monte_carlo_covid(N,iterations,t_e, t_c, t_r, p_i);

plot(t_mean, x_mean(3,:))

% [ts1,xs1] = corona_DES(N,1234,t_e,t_c,t_r,p_i);
% [ts2,xs2] = corona_DES(N,5432,t_e,t_c,t_r,p_i);
% 
% timeseries_error(ts1,xs1,ts2,xs2)


