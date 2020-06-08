clear all;

scale = 1/100;

% fixed values:
N = 9000000*scale;
t_r = 9;
t_e = 1.5;
initial_nr_infected = 10;

% p_i = 0.051490003012856;
% p_i = 0.07;
t_c = 0.3;
t_c_2 = 7;
p_i = 0.1;
p_i_2 = p_i/2;


rng(12345);

% raw_data = readtable('Epikurve.csv', 'Delimiter', ',');
raw_data = readtable('covdatenCONcsv.csv','Delimiter',',');
% real_curve = raw_data.daily_infected;
real_curve = raw_data.CON(1:100)'*scale;
% infected = cumsum(raw_data.daily_infected)';

% the following was used to find out at which probabilities the computation
% time reached unreasonable values (for given contact rate t_c = 0.2). The 
% calibration should not exceed p = 0.13!


% for p = 0.05:0.005:0.1
%     tic;
%     [ts, xs] = corona_DES(N, 202020, t_e, t_c, t_r, p,t_c_2, initial_nr_infected,p/3);
%     time = toc
%     if toc > 100
%         break
%     end
%     plot(ts,sum(xs(3,:),1),'b',1:length(real_curve),real_curve,'r')
%     timeseries_error(ts,sum(xs(3,:),1),(1:length(real_curve)),real_curve)
% end

weights = [];
fixed_param = [N,t_e,t_r,initial_nr_infected];
% fixed_param = [t_e,t_r,initial_nr_infected];

% three individuums in swarm, 
[opt_param, seed] = pso_calibration(3, N, real_curve, weights,fixed_param);


p_i = opt_param(1)
t_c = opt_param(2)
[ts, xs] = corona_DES(N, seed, t_e, t_c, t_r, p_i,t_c_2, initial_nr_infected,p_i_2);



timeseries_error(ts,sum(xs(3,:),1),(1:length(real_curve)),real_curve);

[ts,xs] = monte_carlo_covid(N,10, t_e, t_c, t_r, p_i,t_c_2, initial_nr_infected,p_i_2);

plot(ts,sum(xs(3,:),1),'r',(1:length(real_curve)),real_curve,'b')
