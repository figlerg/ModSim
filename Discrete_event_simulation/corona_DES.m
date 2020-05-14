function [ts, xs] = corona_DES(N)
    % code:
    % -event ids
    %   1 infection
    %   2 infect
    %   3 recover
    %   4 contact
    % right now i can't think of any necessary priorities
    % TODO actually, recover should be > contact?
    
    % but in case i want to set priorities later, this makes it easier:
    infection = 1;
    infect = 2;
    recover = 3;
    contact = 4;
    
    
    % -for individuals
    %   1 susceptible
    %   2 exposed
    %   3 infectious
    %   4 recovered
    
    % execution params
    max_iterations = 1000;
    %     xs = ones(N,max_iterations); % for saving the population values
    xs = zeros(4,max_iterations); % saving populations is easier just by looking at the sums
    ts = zeros(max_iterations); % saving the time steps
    current_population = ones(N,1); % this is basically interchangeable with xs, but has information of all individuals. 
    % all ones means all are susceptible.
    % (i could have saved everything in xs but it would have been
    % cumbersome)

    % update times (might be exchanged with exprnd()mean parameters and
    % sampled in switch
    t_e = 2;
    t_c = 1;
    t_r = 14;
    
    p_i = 0.7; % infection probability at contact

    % run event

    event_list = [];
    xs(:,1) = [N,0,0,0];
    event = [infection,1,0]; % individual 1 gets infected at t = 0
    event_list = schedule_event(event_list, event);
    
    counter = 1;
    event_list;
    
    while ~isempty(event_list) && counter < max_iterations
        counter = counter + 1;
        event = event_list(1,:);
        event_list(1,:) = [];
        
        event_id = event(1);
        id = event(2);
        t = event(3);
        ts(counter) = t;
        

        
        switch event_id
            case infection
                update = [-1 1 0 0]';
                scheduled_events = [infect, id, t + t_e];
                current_population(id) = 2;
            case infect
                update = [0 -1 +1 0]';
                scheduled_events = [recover, id, t + t_r;
                                    contact, id, t + t_c];
                current_population(id) = 3;

            case contact
                update = [0 0 0 0]';
                
                j = id;
                while j == id % this loop makes sure j != i 
                    j = randi(N); 
                end
                
                U = rand();
                
                % first another contact for itself is scheduled
                scheduled_events = [contact, id, t + t_c];
                
                % then (with a certain probability) an infection event is
                % scheduled, IF j is still susceptible
                if current_population(j) == 1 && U < p_i
                    scheduled_events(end +1,:) = [infection, j, t]; % scheduling this is instantanious
                end
                
            case recover
                update = [0 0 -1 1]';
                scheduled_events = [];
                
                tmp =  cancel_event(event_list, [contact, id, t]);
                clear event_list;
                event_list = tmp;
                current_population(id) = 4;
        end
        
        clear tmp;
        % TODO this can't perform well, find workaround (possibly by
        % preallocating matrix with fives, which would be "dead" events)
        tmp = schedule_event(event_list, scheduled_events);
        clear event_list;
        event_list = tmp;
        clear tmp;
        
        xs(:,counter) = xs(:,counter-1) + update;
        ts(counter) = t;
        
    end
    
    % in case it runs out of events early
    ts(counter:end) = [];
    xs(:,counter:end) = [];
    
    hold on;
    h = [];
    h(1) = plot(ts, xs(1,:));
    h(2) = plot(ts, xs(2,:));
    h(3) = plot(ts, xs(3,:));
    h(4) = plot(ts, xs(4,:));
    legend(h,'S','E','I','R'); % this just won't match
    
end
    



