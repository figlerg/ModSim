function [nabla_C_w, nabla_C_b] = backdrop(network,x,y)
%this function should compute the changes that need to be made to the
%weights and biases after one sample
% x ... input values (so 1st layer activation)
% y ... desired output digit
% network ... Cell array containing weights and biases

n = size(network,1)+1; %number of layers

% this is needed for both nabla vectors:
delta = cell(n-1,1);


nabla_C_w = cell(n-1,1);
nabla_C_b = cell(n-1,1);

y_vector = zeros(10,1);
y_vector(y+1) = 1;
% now we have a vectorized label for int label y

% using same notation as michael nielsen in his free ebook:
% http://neuralnetworksanddeeplearning.com/
[zs, activations] = feedforward(network, x);

ANN_output = activations{end};
nabla_a_C = ANN_output - y_vector; % derivative of C with respect to activations a

delta_L = nabla_a_C .* sigmoid_deriv(zs{end}); % error in last layer
delta{end} = delta_L;



for i = n-2:-1:1
    weights_iplus1 = network{i+1, 1};
    delta_iplus1 = delta{i+1};
    delta{i} = (weights_iplus1' * delta_iplus1) .* sigmoid_deriv(zs{i+1});
%     delta{i} = weights_iplus1' * (delta_iplus1 .* sigmoid_deriv(zs{i+2}));

end

% default matlab's font's 1 (one) looks the same as l (the letter)! 

% now I have errors for each layer
% dC/db_j^l (cost deriv. with respect to biases in l'th layer, j'th neuron)
% is delta_j^l now

% dC/dw_jk^l (cost deriv. with respect to weight of connection from kth
% neuron (in (l-1)th layer) to jth neuron (in lth layer)) is a_k^(l-1)
% delta_j^l


nabla_C_b = delta;

for i = 1:n-1
%     a = diag(delta{i});
%     b = repmat(activations{i},[1,length(delta{i})])';
%     
%     nabla_C_w{i} = a * b;

    nabla_C_w{i} = delta{i} * activations{i}';
    
end



end




% input = x
% n=size(network,1)+1 %number of layers
% 
% nabla_w = network(:,1);
% nabla_b = network(:,2); %i actually just need the right shape, 
% %but all values will get overritten anyways...
% 
% 
% 
% 
% 
% desired_output = zeros(10,1);
% desired_output(y+1)=1;  
% %converts int value of trainY to a vector corresponding to the desired neuron output
% 
% %the following lines implement the gradient descent method
% cost_derivative = feedforward_simple(network,x)-desired_output
% 
% zs = feedforward(network,input)%all layer activations
% 
% delta = cost_derivative .* sigmoid_deriv(zs{n})' %kettenregel? wie testen?
% delta = delta'
% nabla_b{n-1}=delta
% 
% delta
% network{n-1,1}
% nabla_w{n-1}= delta * network{n-2,1};
% 
% gradient_vector = [nabla_w,nabla_b];