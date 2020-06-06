x= [1,2,3,4]
x'
length(3*x)
x'*[1,2,3,4]

x(1,1)

%d = load('mnist.mat');

% X = trainX;
% i = reshape(X(5,:), 28, 28)';
% image(i);
% 
% max(double(X(5,:)))

%randn(5,2)

testnetwork = init_network([7,9,4,10]) %dimensions should fit
testnetwork{2,1}*(testnetwork{1,1}*zeros(7,1))
% testnetwork{2,1}
% testnetwork{1,2} %gets 1st bias vector


a= feedforward(testnetwork,zeros(7,1)) %works apparently, gives back right kind of vector
a{4} - feedforward_simple(testnetwork,zeros(7,1)) %two different feedforwards give 
%same output, so they should work like intended
% X = trainX;
% i = reshape(X(5,:), 28, 28)';
% image(i);

sigmoid_deriv([1,2,3]) %TODO test if right values
size(testnetwork,1)

d=[1,2,3,4]*[1,2;3,4;5,6;7,8]

backdrop(testnetwork, zeros(7,1),0)