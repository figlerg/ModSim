function [t_mean, x_mean] = monte_carlo_covid(N,iterations, t_e, t_c, t_r, p_i)
    
    
    ref_time = 0:100;
    t_mean = ref_time;
    
    x_sync_saved = zeros(4,length(ref_time),iterations);
    
    x_mean = zeros(4, length(ref_time)); % SEIR
    
    parfor i = 1:iterations
        % this means it's reproducible but a different seed in each
        % iteration
        seed = i+10000;
        [ts,xs] = corona_DES(N,seed, t_e, t_c, t_r, p_i);
        
        [~,~,bin] = histcounts(ref_time,ts);
        
        problem_points = find(bin == 0)
        for idx = problem_points
            bin(idx) = bin(idx -1)% fills up the zeros with the number before (these should be constant, not zeros)
        end
        
%         bin(bin == 0) = max(bin); % necessary when the process stops before end of reference time (these bins are empty and 0 is returned)
        % TODO print a warning or something
        x_sync = [xs(1:4,bin)];
        
%         x_mean = x_mean*(i-1)/i + x_sync/i;
        x_sync_saved(:,:,i) = x_sync; % necessary for parallel computing
        
    end
    
    x_mean = mean(x_sync_saved,3);
end