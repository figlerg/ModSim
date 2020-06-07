function C = plus(A,B)
% overloading the "-" operator to work with cells. calls the - operator on
% each of the corresponding cells.

% (Makes updating the weights and biases a lot easier)
  assert(isequal(size(A), size(B)));
  for i =1:prod(size(A))
      assert(isequal(size(A{i}), size(B{i})));
  end

  C = cellfun(@minus,A,B,'UniformOutput',false);  %# Apply minus cell-wise
end