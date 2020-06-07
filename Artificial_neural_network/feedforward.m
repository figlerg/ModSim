function [zs,activations] = feedforward(network, x)
%this returns the activations for every layer of neurons of a given network
%and an input vector by calculating weight matrix times vector between each layer
% meaning: activations{1} is the input vector, activations{n} is the
% network's guess for which number is depicted

n= size(network,1); %number of steps
% activations{1}= sigmf(x,[1,0]);
activations{1} = x;
zs{1} = x; % this doesn't need to be here, but is hopefully less confusing 
% than having it shifted by one from the indices of activations
for i=1:n
    z = network{i,1}*activations{i}+ network{i,2};
    activations{i+1} = sigmf(z,[1,0]);
    zs{i +1} = z;
end
