function C = plus(A,B)

  assert(isequal(size(A), size(B)));
  for i =1:prod(size(A))
      assert(isequal(size(A{i}), size(B{i})));
  end

  C = cellfun(@minus,A,B,'UniformOutput',false);  %# Apply minus cell-wise
end