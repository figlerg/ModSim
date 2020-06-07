function C = plus(A,B)
% overloading the "+" operator to work with cells. calls the + operator on
% each of the corresponding cells.

% (Makes updating the weights and biases for my ANN a lot easier)
  assert(isequal(size(A), size(B)));
  for i =1:prod(size(A))
      assert(isequal(size(A{i}), size(B{i})));
      assert(all(isfinite(A{i}),'all'));
      assert(all(isfinite(B{i}),'all'));
  end
  C = cellfun(@plus,A,B,'UniformOutput',false);  %# Apply plus cell-wise
end