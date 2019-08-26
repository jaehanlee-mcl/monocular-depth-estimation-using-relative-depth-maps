function depth_label = relative_labeling_v1(depth_map)

load('depth_ratio_008_008_quant.mat', 'depth_ratio_008_008_quant')

% depth_map(axb matrix) -> relative_depth_map(axbxab tensor)
relative_depth_map = zeros(size(depth_map,1), size(depth_map,2), size(depth_map,1)*size(depth_map,2));
depth_map_reshape = reshape(depth_map, 1, 1, size(depth_map,1)*size(depth_map,2));
for index_row = 1 : size(depth_map,1)
    for index_col = 1 : size(depth_map,2)
        relative_depth_map(index_row, index_col, :) = depth_map_reshape / depth_map(index_row, index_col);
    end
end

% relative_depth_map(axbxab tensor) -> depth_label(axbxabx40 tensor)
depth_label = zeros(size(depth_map,1), size(depth_map,2), size(depth_map,1)*size(depth_map,2), 40);
for index_chapter = 1 : 40
    depth_label(:,:,:,index_chapter) = (relative_depth_map >= depth_ratio_008_008_quant(index_chapter));
end
% reshape depth_label to (axbx40ab)
depth_label = reshape(depth_label, size(depth_map,1), size(depth_map,2), 40*size(depth_map,1)*size(depth_map,2));

end