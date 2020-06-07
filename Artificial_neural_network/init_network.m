function network = init_network(sizes)
%initializes a network with number of layers, number of neurons like in
%sizes vector. this means a cell array of matrices (weights) and
%corresponding bias vectors, set randomly

%example: sizes=[20,10,5] would mean a network with 20 input neurons, a
%hidden layer of 10 neurons and five output neurons

rng(34959);

n=length(sizes);
output = cell(n-1,2); %2nd column for bias vectors
% cell is necessary to allow differently sized matrices and vectors in one
% variable


for i=1:n-1
    % TODO could I initialize this as GPU arrays and offload some of the
    % processing to the GPU in feedforward?
    output{i,1} = randn(sizes(i+1),sizes(i)); %weight matrices
    output{i,2} = randn(1,sizes(i+1))'; %bias vectors, column! 
    %we only need biases for each layer of output neurons, so we begin
    %counting at 2
    
end




network=output;
end

