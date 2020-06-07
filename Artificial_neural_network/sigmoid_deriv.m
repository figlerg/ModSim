function deriv_value = sigmoid_deriv(x)

% deriv_value = (sigmf(x,[1,0]) .* (1-exp(-x)))'; % wrong?

% tested and compared with Michael Nielsen's python code
deriv_value = sigmf(x, [1,0]) .* (1 - sigmf(x, [1,0])); 