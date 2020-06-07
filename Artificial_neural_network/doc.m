X_pattern = [1 0 1; 1 1 0; 0 1 1; 0 0 1];
y_pattern = [1 1 0 0];

rep = 10000;
X_train_1 = repmat(X_pattern,rep,1);
y_train_1 = repmat(y_pattern,1,rep);


network_1 = init_network([3,1]);
network_1 = train_ANN(network_1,X_train_1, y_train_1, 100, 4, false)