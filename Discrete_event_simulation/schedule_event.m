function [updated_list] = schedule_event(list, event)
    % just adds to list and sorts afterwards
    
%     assert size(list,2)== length(event) % this doesn't work for some
%     matrix reason
    
%     nr_new_events = size(event,1); % it is possible to schedule 2 events simultaneously
% list

if isempty(list)
    updated_list = sortrows(event, 3);
    return
end

updated_list = list;

for i= 1:size(event,1)

    index = closest_value(list(:,3).',event(i,3));
    updated_list = [updated_list(1:index-1,:); event(i,:) ;updated_list(index:end,:)];
end

end



% updated_list = [list; event];
%     
% 
%     
%     updated_list = sortrows(updated_list, [3,1]);
%     % this sorts for 3rd value first, in case of equalities 1st column
%     % decides. This is because the 1st column is for event ID, where I can
%     % decide priorities between events.
    
   
    
    