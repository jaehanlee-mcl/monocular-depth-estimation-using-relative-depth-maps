function depth_map = ch068_labeling_inv(depth_label)


depth_label = sum(depth_label, 3);
depth_map = exp((depth_label-0.5)/25-0.36);


end