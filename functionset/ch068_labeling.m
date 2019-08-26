function depth_label = ch068_labeling(depth_map)

depth_label = zeros(size(depth_map,1), size(depth_map,2), 68);
depth_map = round(min(max((log(depth_map) + 0.36)*25 + 1, 0), 68));

for index = 1 : 68
    depth_label(:,:,index) = (depth_map >= index);
end

end