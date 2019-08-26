function relative_depth_map = relative_soft_labeling_v3_inv(depth_label)

load('depth_ratio_032_032_quant.mat', 'depth_ratio_032_032_quant_inv')
log_depth_ratio_032_032_quant_inv = log(depth_ratio_032_032_quant_inv);

% reshape depth_label from (axbx(5x5)ab) to (axbx(5x5)x40)
depth_label = sum(reshape(depth_label, size(depth_label,1), size(depth_label,2), 5*5, 40), 4) + 1;
depth_label_high = ceil(depth_label);
depth_label_low = floor(depth_label);
depth_label_high_gap = (depth_label_high - depth_label + (1e-10)) ./ (depth_label_high - depth_label_low + (1e-10));
depth_label_low_gap = (depth_label - depth_label_low + (1e-10)) ./ (depth_label_high - depth_label_low + (1e-10));

log_relative_depth_map ...
    = log_depth_ratio_032_032_quant_inv(depth_label_high) .* depth_label_low_gap ...
    + log_depth_ratio_032_032_quant_inv(depth_label_low) .* depth_label_high_gap;

relative_depth_map = exp(log_relative_depth_map);

end