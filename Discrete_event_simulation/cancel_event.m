function [updated_list] = cancel_event(list, event)
    updated_list = list
    
    % need to find event, but i don't care about the time (that's why 1:2):
    [tf, index] = ismember(list(:,1:2),event(1:2),'rows');
    
    index = find(index); % converts from logical to indices
    index = index(1); % in another DES there could be more than one
    
    updated_list(index,:) = []; % delete event from list
end