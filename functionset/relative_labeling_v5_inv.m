function relative_depth_map = relative_labeling_v5_inv(depth_label)

load('depth_ratio_128_128_quant.mat', 'depth_ratio_128_128_quant_inv')

% reshape depth_label from (axbx(5x5)ab) to (axbx(5x5)x40)
depth_label = reshape(depth_label, size(depth_label,1), size(depth_label,2), 5*5, 40);

relative_depth_map = depth_ratio_128_128_quant_inv(sum(depth_label,4)+1);

end