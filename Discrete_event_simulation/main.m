clear all;

% fixed values:
N = 9000000;
t_r = 9;
t_e = 1.5;
t_c = 0.2;
t_c_2 = 7;
initial_nr_infected = 10;

% p_i = 0.051490003012856;
% p_i = 0.07;
p_i = 0.1;
p_i_2 = p_i/2;


rng(12345);

% raw_data = readtable('Epikurve.csv', 'Delimiter', ',');
raw_data = readtable('covdatenCONcsv.csv','Delimiter',',');
% real_curve = raw_data.daily_infected;
real_curve = raw_data.CON/100;
% infected = cumsum(raw_data.daily_infected)';

% the following was used to find out at which probabilities the computation
% time reached unreasonable values (for given contact rate t_c = 0.2). The 
% calibration should not exceed p = 0.13!

% for p = 0.1:0.05:0.2
%     tic;
%     [ts, xs] = corona_DES(N, 202020, t_e, t_c, t_r, p,t_c_2, initial_nr_infected,p/2);
%     p
%     time = toc
%     if toc > 100
%         break
%     end
%     plot(ts,sum(xs(3,:),1),1:length(real_curve),real_curve)
% end

[ts, xs] = corona_DES(N, 202020, t_e, t_c, t_r, p_i,t_c_2, initial_nr_infected,p_i_2);

plot(ts,sum(xs(3,:),1),(1:length(real_curve)) + t_e,real_curve)











% 1.4075    0.4049    1.6894    0.1428 from calibration
% param = [1.4075    0.4049    1.6894    0.1428]
% t_e = param(1);
% t_c = param(2);
% t_r = param(3);
% p_i = param(4);


% [t_mean, x_mean] = monte_carlo_covid(N,iterations,t_e, t_c, t_r, p_i);

% plot(t_mean, x_mean(3,:))

% [ts1,xs1] = corona_DES(N,1234,t_e,t_c,t_r,p_i);
% [ts2,xs2] = corona_DES(N,5432,t_e,t_c,t_r,p_i);
% 
% timeseries_error(ts1,xs1,ts2,xs2)


