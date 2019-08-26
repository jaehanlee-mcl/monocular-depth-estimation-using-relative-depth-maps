function depth_label = relative_labeling_v3(depth_map)

load('depth_ratio_032_032_quant.mat', 'depth_ratio_032_032_quant')
depth_map_resized = exp(imresize(log(depth_map), [016,016], 'box'));

% depth_map(axb matrix) -> relative_depth_map(axbx(5x5) tensor)
relative_depth_map = zeros(size(depth_map,1), size(depth_map,2), 5*5);
for index_row = 1 : size(depth_map,1)
    for index_col = 1 : size(depth_map,2)
        index_resized_row = ceil(index_row/2);
        index_resized_col = ceil(index_col/2);
        index_row_start = min(max(index_resized_row-2, 1), size(depth_map_resized,1)-4);
        index_row_end = index_row_start+4;
        index_col_start = min(max(index_resized_col-2, 1), size(depth_map_resized,2)-4);
        index_col_end = index_col_start+4;
        relative_depth_map(index_row, index_col, :) ...
            = reshape(depth_map_resized(index_row_start:index_row_end, index_col_start:index_col_end), 1, 1, 5*5) ...
            / depth_map(index_row, index_col);
    end
end

% relative_depth_map(axbxab tensor) -> depth_label(axbxabx40 tensor)
depth_label = zeros(size(depth_map,1), size(depth_map,2), 5*5, 40);
for index_chapter = 1 : 40
    depth_label(:,:,:,index_chapter) = (relative_depth_map >= depth_ratio_032_032_quant(index_chapter));
end
% reshape depth_label to (axbx40ab)
depth_label = reshape(depth_label, size(depth_map,1), size(depth_map,2), 40*5*5);

end