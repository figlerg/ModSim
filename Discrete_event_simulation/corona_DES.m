function [ts, xs] = corona_DES(N, seed, t_e, t_c, t_r, p_i, t_c_2, initial_nr_infected,p_i_2)
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
    restrictions = 5;
    
    
    % -for individuals
    %   1 susceptible
    %   2 exposed
    %   3 infectious
    %   4 recovered
    
    % execution params
    max_iterations = max([N/2, 1000000]);
    xs = zeros(4,max_iterations); % saving populations is easier just by looking at the sums
    ts = zeros(1,max_iterations); % saving the time steps
    current_population = ones(N,1); % this is basically interchangeable with xs, but has information of all individuals. 
    % all ones means all are susceptible.
    % (i could have saved everything in xs but it would have been
    % cumbersome)


    % update times (might be exchanged with exprnd()mean parameters and
    % sampled in switch
%     t_e = 2;
%     t_c = 1;
%     t_r = 14;
    
%     p_i = 0.7; % infection probability at contact

    % run event

    event_list = [];
    xs(:,1) = [N,0,0,0];
    event = [infection,1,0]; % individual 1 gets infected at t = 0
%     event_list = schedule_event(event_list, event);
    event_list = repmat(event,initial_nr_infected,1);
    event_list(:,2) = 1:length(event_list(:,2));

    event_list = event;

    counter = 1;
    
    restrictions_scheduled = false;
    
    
    rng(seed);
    t = 0;
    while ~isempty(event_list) && counter < max_iterations && t < 100
        counter = counter + 1;
        event = event_list(1,:);
        event_list(1,:) = [];
        
        event_id = event(1);
        id = event(2);
        t = event(3);
        ts(counter) = t;
        
        if t > 35 && ~restrictions_scheduled
            event = [5,-1,t];
            if isempty(event_list)
                event_list(1,:) = event;
            else
                index = closest_value(event_list(:,3).',event(3));
                event_list = [event_list(1:index-1,:); event ;event_list(index:end,:)];
            end


        end
        
        switch event_id
            case infection
                update = [-1 1 0 0]';
                scheduled_events = [infect, id, t + exprnd(t_e)];
                current_population(id) = 2;
            case infect
                update = [0 -1 +1 0]';
                scheduled_events = [recover, id, t + exprnd(t_r);
                                    contact, id, t + exprnd(t_c)];
                current_population(id) = 3;

            case contact
                update = [0 0 0 0]';
                
                j = id;
                while j == id % this loop makes sure j != i 
                    j = randi(N); 
                end
                
                % first another contact for itself is scheduled
                if current_population(j) == 1
                    scheduled_events = [contact, id, t + exprnd(t_c)];
                else
                    % this is equivalent to canceling the contact event
                    % later on, but needs less computation time
                    scheduled_events = [];
                end
                U = rand();
                
                % then (with a certain probability) an infection event is
                % scheduled, IF j is still susceptible
                if current_population(j) == 1 && U < p_i
                    scheduled_events(end +1,:) = [infection, j, t]; % scheduling this is instantanious
                end
                
            case recover
                update = [0 0 -1 1]';
                scheduled_events = [];
%                 [~, index] = ismember(event_list(:,1:2),event(1:2),'rows');
%     
%                 index = find(index); % converts from logical to indices
%     
%                 event_list(index,:) = []; % delete event from list
                
%                 tmp =  cancel_event(event_list, [contact, id, t]);
%                 clear event_list;
%                 event_list = tmp;
                current_population(id) = 4;
            case restrictions
%                 t_c = 5*t_c;
%                 p_i = 0.5 * p_i;
                t_c = t_c_2;
                p_i = p_i_2;
                
                restrictions_scheduled = true;
                
        end
        
        for k = 1:size(scheduled_events,1)
            event = scheduled_events(k,:);
            if isempty(event_list)
                event_list(1,:) = event;
            else
                index = closest_value(event_list(:,3).',event(3));
                event_list = [event_list(1:index-1,:); event ;event_list(index:end,:)];
            end
        end
        
%         clear tmp;
%         % TODO this can't perform well but ius necessary right now, find workaround (possibly by
%         % preallocating matrix with number not used yet, which would be "dead" events)
%         tmp = schedule_event(event_list, scheduled_events);
%         clear event_list;
%         event_list = tmp;
%         clear tmp;
        
        xs(:,counter) = xs(:,counter-1) + update;
        ts(counter) = t;
        
    end
    
    % in case it runs out of events early
    ts(counter:end) = [];
    xs(:,counter:end) = [];
    
%     hold on;
%     h = [];
%     h(1) = plot(ts, xs(1,:), 'r');
%     h(2) = plot(ts, xs(2,:)), 'b';
%     h(3) = plot(ts, xs(3,:)),'g';
%     h(4) = plot(ts, xs(4,:)), 'k';
%     legend(h,'S','E','I','R'); % this doesn't work on my installation due to a bug but should work elsewhere
%     
    
end
    



