function relative_depth_map = relative_labeling_v1_part(depth_map)

% depth_map(axb matrix) -> relative_depth_map(axbxab tensor)
relative_depth_map = zeros(size(depth_map,1), size(depth_map,2), size(depth_map,1)*size(depth_map,2));
depth_map_reshape = reshape(depth_map, 1, 1, size(depth_map,1)*size(depth_map,2));
for index_row = 1 : size(depth_map,1)
    for index_col = 1 : size(depth_map,2)
        relative_depth_map(index_row, index_col, :) = depth_map_reshape / depth_map(index_row, index_col);
    end
end

end