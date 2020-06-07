d = load('mnist.mat');

% training and test data
X_train = double(d.trainX)/255;
Y_train = d.trainY;
X_test = double(d.testX)/255;
Y_test = d.testY;

% weirdly, rescaling by 1/255 gives the network a 20% accuracy boost
% (255 is the max value and corresponds to pure black -> so now the
% X values are 0-1 greayscale values)

% this function initializes the network with random numbers
network = init_network([28*28,20, 10]);

% training via stochastic gradient descent method
network = train_ANN(network, X_train, Y_train, 3, 10);


% network is now trained, can be used on the test data to get an estimate
% on how well it performs. (Test data consists of 10000 samples)

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
ratio = counter/size(X_test,1)
    
    