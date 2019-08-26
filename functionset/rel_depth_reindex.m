function output = rel_depth_reindex(input)

% if input size 016x016x25 -> output size (016x016)x(008x008)
% if input size 032x032x25 -> output size (032x032)x(016x016)
% if input size 064x064x25 -> output size (064x064)x(032x032)
output = zeros(size(input,1)*size(input,2), size(input,1)/2, size(input,2)/2);

for index_col = 1 : size(input, 2)
    for index_row = 1 : size(input, 1)
        
        index_colrow = (index_col-1) * size(input, 1) + (index_row-1) + 1; 
        index_col_new = ceil(index_col/2);
        index_row_new = ceil(index_row/2);
        
        index_col_new_start = min(max(index_col_new-2, 1), size(input,2)/2-4);
        index_row_new_start = min(max(index_row_new-2, 1), size(input,1)/2-4);
        index_col_new_end = index_col_new_start+4;
        index_row_new_end = index_row_new_start+4;
        
        output(index_colrow, index_row_new_start:index_row_new_end, index_col_new_start:index_col_new_end) ...
            = reshape(input(index_row, index_col, :), [5,5]);
        
    end
end

output = reshape(output, [size(input,1)*size(input,2), size(input,1)/2*size(input,2)/2]);
