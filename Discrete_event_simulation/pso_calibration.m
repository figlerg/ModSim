function [param,seed] = pso_calibration(swarm_len, N, calibration_data, weights ,fixed_param)
% a particle swarm optimisation algorithm for the corona discrete event
% simulation

rng(12345);
 
% t_e = 3-1.5; 
% https://www.lungenaerzte-im-netz.de/krankheiten/covid-19/ansteckungsgefahr-inkubationszeit/
% Im Schnitt betrage der Zeitraum zwischen Ansteckung und ersten Symptomen wohl drei Tage und damit weniger als die bisher angenommenen gut fünf Tage
% https://www.rki.de/DE/Content/InfAZ/N/Neuartiges_Coronavirus/Steckbrief.html#doc13776792bodyText8
% Schon 1-2 Tage vorher infektiös
% selbe quelle: 
% t_r = 6

% N, seed, t_e, t_c, t_r, p_i, t_c_2, initial_nr_infected,p_i_2

N = fixed_param(1); t_e = fixed_param(2); t_r = fixed_param(3);
initial_nr_infected = fixed_param(4);




infected = calibration_data;

p_i = 0.05;
t_c = 0.3;


% % use this as benchmark
[a,b] = corona_DES(N,202020,t_e,t_c,t_r,0.1,7,initial_nr_infected,p_i);
simulated_infected = sum(b(2:end,:),1); % everyone that has/had the virus in simulation
err = timeseries_error(a, simulated_infected, 1:length(infected), infected);

% plot(1:length(infected), infected, a, simulated_infected)
% plot(a, simulated_infected)


% t_e = param(1); t_c = param(2); t_r = param(3); p_i = param(4);


%TODO think about other initial values. maybe this is far from the right
%scale
% initialize swarm
calibrated_param_len = 2; 

% experimental intervals in which computation time does not explode
interval_p_i = [0.04,0.1];
interval_t_c = [0.15,0.5];

pos = zeros(swarm_len, calibrated_param_len);
pos(:,1) = rand(swarm_len,1)*(interval_p_i(2)-interval_p_i(1)) + interval_p_i(1);
pos(:,2) = rand(swarm_len,1)*(interval_t_c(2)-interval_t_c(1)) + interval_t_c(1);

vel = zeros(swarm_len, calibrated_param_len);
dist_1 = interval_p_i - pos(:,1);
dist_2 = interval_t_c - pos(:,2);
update_1 = rand(swarm_len,1).*(dist_1(:,2)-dist_1(:,1)) + dist_1(:,1);
update_2 = rand(swarm_len,1).*(dist_2(:,2)-dist_2(:,1)) + dist_2(:,1);
vel = vel+[update_1,update_2]/100;

best_seed = 12345;
seed = 12345;
best_err_global = err; 
best_param_global = [p_i,t_c];

best_err_fish = inf(swarm_len,1); 
best_param_fish = zeros(swarm_len,calibrated_param_len);

iterations = 10;
counter = 0;
while err > 10000 && counter < iterations
    counter = counter +1;
    
    % this should be a parallel loop, but there is some problem with
    % variables
    for fish = 1:swarm_len
        seed = seed + 123;
        fish_pos = pos(fish, :);
        fish_vel = vel(fish, :);
        

        t_c = fish_pos(1);
        p_i = fish_pos(2);

        [ts,xs] = corona_DES(N, seed, t_e, t_c, t_r, p_i,t_c*20, initial_nr_infected,p_i/3);
        
        err = timeseries_error(ts, xs, 1:length(infected), infected);
        
        if err < best_err_global
            best_err_global = err;
            best_param_global = fish_pos;
            best_seed = seed;
        end
        if err < best_err_fish
            best_err_fish(fish) = err;
            best_param_fish(fish,:) = fish_pos;
        end
        
        
        u = rand();
        v = rand();
        
%         vel = zeros(swarm_len, calibrated_param_len);
%         dist_1 = interval_p_i - pos(fish,1);
%         dist_2 = interval_t_c - pos(fish,2);
%         update_1 = rand()*(dist_1(1,2)-dist_1(1,1)) + dist_1(1,1);
%         update_2 = rand()*(dist_2(1,2)-dist_2(1,1)) + dist_2(1,1);
        weights = [0.3,0.5];
        
        update = normr(fish_vel + weights(1)*u*(best_param_global - fish_pos) + weights(2)*v*(best_param_fish(fish,:) - fish_pos));
        min_distance = min(abs([fish_pos(1)-interval_p_i',fish_pos(2)-interval_t_c']),[],'all');
        
        fish_vel = update *1/2* min_distance;
        % this is rather creative, but it should make it impossible to
        % leave the parameter box...
        
        vel(fish,:) = fish_vel
    end
    
    pos = pos + vel
    err
end
param = best_param_global
end
        
        

        
