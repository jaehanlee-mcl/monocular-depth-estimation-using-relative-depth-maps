function relative_depth_map = relative_labeling_v1_inv(depth_label)

load('depth_ratio_008_008_quant.mat', 'depth_ratio_008_008_quant_inv')

% reshape depth_label from (axbx40ab) to (axbxabx40)
depth_label = reshape(depth_label, size(depth_label,1), size(depth_label,2), size(depth_label,3)/40, 40);

relative_depth_map = depth_ratio_008_008_quant_inv(sum(depth_label,4)+1);

end