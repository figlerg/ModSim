function number_needed = train_ANN_2(network, X_train, y_train, X_test, y_test, eta, mini_batch_sz,digit_mode)
    % this function implements stochastic gradient descent. I could further
    % improve the results by reshuffling into several epochs and training
    % more, as well as several other techniques.

    network_out = network;
    batch_starts = 1:mini_batch_sz:size(X_train, 1);
    accuracy = 1000;
    


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
        

        if mod(batch_start, accuracy)>accuracy-batch_width-1
            
%             counter = 0;
%             for i = 1:size(X_test,1)
%                 X = X_test(i,:)';
%                 y = y_test(i);
% 
%                 % vectorized output of network for each input:
%                 ANN_guess_vector = feedforward_simple(network_out,X);
% 
%                 % transform to corresponding digit
%                 [~,ANN_guess] = max(ANN_guess_vector);
%                 ANN_guess = ANN_guess-1;
% 
%                 % count matches
%                 if y == ANN_guess
%                     counter = counter +1;
%                 end
%             end
%             ratio = counter/size(X_test,1);
            ratio = compute_accuracy(network_out,X_test, y_test);
            if ratio >= 0.80
%                 "The needed number of training examples are:"
                number_needed = batch_end;
%                 "(This can only be as accurate as the batch size indicates and depends on the other specs of the neural network as well.)"
                return
            end
        end
    end
% network{1}
end