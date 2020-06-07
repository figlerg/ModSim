function accuracy = compute_accuracy(network, X_test, Y_test)

    counter = 0;
    for i = 1:size(X_test,1)
        X = X_test(i,:)';
        y = Y_test(i);

        % vectorized output of network for each input:
        ANN_guess_vector = feedforward_simple(network,X);

        % transform to corresponding digit
        [~,ANN_guess] = max(ANN_guess_vector);
        ANN_guess = ANN_guess-1;

        % count matches
        if y == ANN_guess
            counter = counter +1;
        end
    end
    accuracy = counter/size(X_test,1);