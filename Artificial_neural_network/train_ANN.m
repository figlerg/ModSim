function network_out = train_ANN(network, X_train, y_train, eta, mini_batch_sz,digit_mode)
    % this function implements stochastic gradient descent. I could further
    % improve the results by reshuffling into several epochs and training
    % more, as well as several other techniques.

    network_out = network;
    batch_starts = 1:mini_batch_sz:size(X_train, 1);
    


    for i = 1:length(batch_starts)
        batch_start = batch_starts(i);
        if i == length(batch_starts)
            if mod(batch_starts(i),mini_batch_sz) == 1
                batch_end = size(X_train,1);
            end
        else
            batch_end = batch_starts(i+1);
        end
        
        batch_X = X_train(batch_start:batch_end,:);
        batch_y = y_train(batch_start:batch_end);
        
        batch_width = batch_end - batch_start;
        
        mean_changes = network_out;
        % extremely hacky... i just want it to be the right shape
        mean_changes = mean_changes - mean_changes;
        
        for j = batch_start:batch_end
            X = X_train(j,:)';
            y = y_train(j);
            [nabla_C_w, nabla_C_b] = backdrop(network_out,X,y,digit_mode);
            
            changes = [nabla_C_w, nabla_C_b];
            
            mean_changes = mean_changes + changes;
        end
        
        % need todivide by number and rescale with learning rate
        % needed to write a function for that
        update = cell_scaling(mean_changes, eta/batch_width);
        
        network_out = network_out - update;
        if ~all(isfinite(update{1}))
            'cant be'
        end
%         network_out{end};
        
%         if i*mini_batch_sz>size(X_train)-10*mini_batch_sz
%             network{1}
%         end
        

    end
% network{1}
end