function out = cell_scaling(cell, scalar)
    out = cell;
    for i = 1:prod(size(out))
        out{i} = out{i}*scalar;
    
end