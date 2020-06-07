d = load('mnist.mat');

network = init_network([28*28,42,21, 10]);



X_train = double(d.trainX)/255;
Y_train = d.trainY;
X_test = double(d.testX)/255;
Y_test = d.testY;

% X_train = double(d.trainX);
% Y_train = d.trainY;
% X_test = double(d.testX);
% Y_test = d.testY;

% i = double(reshape(X(5,:), 28, 28)');
% image(i);
some_x = double(X_train(5,:))';
% image(reshape(some_x,28,28)');
some_y = Y_train(6);
% 
% [zs, activations] = feedforward(network, some_x);
% 
% [nabla_C_w , nabla_C_b] = backdrop(network, some_x, some_y);
% 
% % nabla_C_w + network(:,1)
% 

% network{1,1} = table2array(weights1init);
% network{2,1} = table2array(weights2init);
% 
% 
% network{1,2} = table2array(biases1init);
% network{2,2} = table2array(biases2init);

network = train_ANN(network, X_train, Y_train, 3, 100);

feedforward_simple(network, some_x) % lol
some_y


% just testing (and comparing to nielsen) to find out why it doesn't work well
% X_train = double(d.trainX)/255;
% Y_train = d.trainY;
% X_test = double(d.testX)/255;
% Y_test = d.testY;
% 



counter = 0;
for i = 1:size(X_test,1)
    X = X_test(i,:)';
    y = Y_test(i);
    
    ANN_guess_vector = feedforward_simple(network,X);
%     [~,test] = feedforward(network,X);
    
%     test{end};
    
    [~,ANN_guess] = max(ANN_guess_vector);
    ANN_guess = ANN_guess-1;
%     image(reshape(X, 28, 28)')
%     y
    if y == ANN_guess
        counter = counter +1;
    end
end
counter/size(X_test,1)
    
    