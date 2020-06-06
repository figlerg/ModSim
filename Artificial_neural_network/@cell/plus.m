function C = plus(A,B)
  assert(isequal(size(A), size(B)));
  for i =1:prod(size(A))
      assert(isequal(size(A{i}), size(B{i})));
  end
  C = cellfun(@plus,A,B,'UniformOutput',false);  %# Apply plus cell-wise
end