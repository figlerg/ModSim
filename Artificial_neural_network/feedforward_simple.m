function activations = feedforward_simple(network, input)
%this returns the output vector of a given network
%and an input vector by calculating weight matrix times vector between each layer

n= size(network,1); %number of steps
% activations= sigmf(input,[1,0]);
activations = input;
for i=1:n
    activations = sigmf(network{i,1}*activations+ network{i,2},[1,0]);
end
