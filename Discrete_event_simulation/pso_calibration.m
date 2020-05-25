function [param] = pso_calibration(swarm_len, N, calibration_data, weights)
% a particle swarm optimisation algorithm for the corona discrete event
% simulation


rng(12345);

raw_data = readtable('Epikurve.dat', 'Delimiter', ',');

infected = cumsum(raw_data.daily_infected)';


% use this as benchmark
[a,b] = corona_DES(N, 12345, 2, 1, 14, 0.2);
simulated_infected = sum(b(2:end,:),1); % everyone that has/had the virus in simulation
err = timeseries_error(a, simulated_infected, 1:length(infected), infected);

% plot(1:length(infected), infected, a, simulated_infected)
% plot(a, simulated_infected)


% t_e = param(1); t_c = param(2); t_r = param(3); p_i = param(4);


%TODO think about other initial values. maybe this is far from the right
%scale
% initialize swarm
calibrated_param_len = 4; 

pos = rand(swarm_len, calibrated_param_len);
vel = rand(swarm_len, calibrated_param_len);

seed = 12345;
best_err_global = err; 
best_param_global = zeros(calibrated_param_len,1);

best_err_fish = inf(swarm_len,1); 
best_param_fish = zeros(swarm_len,calibrated_param_len);

iterations = 100;
counter = 0;
while err > 1000 && counter < iterations
    counter = counter +1;
    for fish = 1:swarm_len
        seed = seed + 123;
        fish_pos = pos(fish, :);
        fish_vel = vel(fish, :);
        
        t_e = fish_pos(1);
        t_c = fish_pos(2);
        t_r = fish_pos(3);
        p_i = fish_pos(4);

        [ts,xs] = corona_DES(N, seed, t_e, t_c, t_r, p_i);
        err = timeseries_error(ts, xs, 1:length(infected), infected);
        
        if err < best_err_global
            best_err_global = err;
            best_param_global = fish_pos;
        end
        if err < best_err_fish
            best_err_fish(fish) = err;
            best_param_fish(fish,:) = fish_pos;
        end
        
        
        u = rand();
        v = rand();
        
        vel(fish, 1:3) = weights(1)* fish_vel(1:3) + weights(2)*u*(best_param_fish(fish,1:3) - fish_pos(1:3)) + weights(3)*v*(best_param_global(1:3) -fish_pos(1:3));
        
        assert(p_i<=1 && p_i >=0)
        diff = abs([0,1] - p_i);
        p_i = p_i + (rand() - diff(1)) / 100;
        % this is very arbitrary, but makes real steps while still
        % remaining in [0,1]
        assert(p_i<=1 && p_i >=0);
        
        p_i = rand();


        
        %move
        pos(fish, :) = pos(fish, :) + vel(fish,:);
        pos(fish, 4) = p_i;
        pos(pos < 0) = 0;
        
        
        
%         vel(fish, 1:3) = fish_vel(1:3) + rand(1,calibrated_param_len-1); % THIS IS NOT CORRECT IF I STILL CALIBRATE p_i (prob)
%        
%         % the following makes sure that the new p_i is in [0,1]
%         assert(p_i<=1 && p_i >=0)
%         diff = abs([0,1] - p_i)
%         p_i = p_i + (rand() - diff(1)) / 100;
%         % this is very arbitrary, but makes real steps while still
%         % remaining in [0,1]
%         assert(p_i<=1 && p_i >=0);
% 
%         vel(fish, 4) = p_i;
%         
%         new_fish_vel = vel(fish,:);
%         pos(fish, :)
%         
% %         pos(fish, :) = weights(1)* fish_pos + weights(2)* new_fish_vel + weights(3)*(best_param_fish(:,fish)' - fish_pos) + weights(4)*(best_param_global -fish_pos);
        
        
    end
end
    
param = best_param_global;
end


