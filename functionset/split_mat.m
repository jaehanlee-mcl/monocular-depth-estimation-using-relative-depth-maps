function [split_rel_depth, split_valid_range] = split_mat(rel_depth, valid_range, input_size, output_size)

io_ratio = input_size ./ output_size;
split_rel_depth = zeros(output_size(1)^2, output_size(2)^2, io_ratio(1), io_ratio(2));
split_valid_range = zeros(output_size(1)^2, output_size(2)^2, io_ratio(1), io_ratio(2));

for index_row_split = 1 : io_ratio(1)
    for index_col_split = 1 : io_ratio(2)
        
        input_size_1_mat = zeros(input_size(1), input_size(1));
        input_size_1_mat( ...
            (index_row_split-1)*output_size(1)+1 : index_row_split*output_size(1), ...
            (index_col_split-1)*output_size(1)+1 : index_col_split*output_size(1) ...
            ) = 1;
        input_size_1_mat = input_size_1_mat(:);
        
        input_size_2_mat = zeros(input_size(2), input_size(2));
        input_size_2_mat( ...
            (index_row_split-1)*output_size(2)+1 : index_row_split*output_size(2), ...
            (index_col_split-1)*output_size(2)+1 : index_col_split*output_size(2) ...
            ) = 1;
        input_size_2_mat = input_size_2_mat(:);
        
        split_rel_depth(:, :, index_row_split, index_col_split) = rel_depth(input_size_1_mat==1, input_size_2_mat==1);
        split_valid_range(:, :, index_row_split, index_col_split) = valid_range(input_size_1_mat==1, input_size_2_mat==1);
    end
end

split_rel_depth = reshape(split_rel_depth, [output_size(1)^2, output_size(2)^2, io_ratio(1)*io_ratio(2)]);
split_valid_range = reshape(split_valid_range, [output_size(1)^2, output_size(2)^2, io_ratio(1)*io_ratio(2)]);