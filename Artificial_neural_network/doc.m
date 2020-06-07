X_pattern = [1 0 1; 1 1 0; 0 1 1; 0 0 1];
y_pattern = [1 1 0 0]';

X_train_1 = repmat(X_pattern,1000,1);
y_train_1 = repmat(y_pattern,1000,1);


network_1 = init_network([3,1]);
train_ANN(network_1,X_train_1, y_train_1, 1, 4)