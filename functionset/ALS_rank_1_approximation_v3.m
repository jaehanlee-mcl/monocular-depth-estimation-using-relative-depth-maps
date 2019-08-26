function [output_mat, output_component, rmse_record] = ALS_rank_1_approximation_v3(input_mat, valid_range)

num_iter = 100;
rmse_record = zeros(2*num_iter+1, 2);
rmse_record(:,1) = 0:0.5:num_iter;

%% Initialization  
component_row = ones(size(input_mat,1), 1, size(input_mat,3));
component_col = ones(size(input_mat,2), 1, size(input_mat,3));
intermediate_mat = zeros(size(input_mat));

for index_page = 1 : size(input_mat,3)
    intermediate_mat(:,:,index_page) = component_row(:,:,index_page) * component_col(:,:,index_page)';
end
rmse_record(1,2) = mean(((intermediate_mat(:) - input_mat(:)) .* valid_range(:)).^2)^0.5;

%% Repetitive ALS
index_iter = 0;
while index_iter < num_iter
    index_iter = index_iter + 1;
    
    % row estimation
%     component_row = ...
%         sum((component_col .* valid_range') .* (input_mat' .* valid_range'), 1)'...
%         ./ sum((component_col .* valid_range') .* (component_col .* valid_range'), 1)';
    component_row = ...
        permute(sum(component_col .* permute(input_mat,[2,1,3]) .* permute(valid_range,[2,1,3]), 1),[2,1,3])...
        ./ permute(sum(component_col .* component_col .* permute(valid_range,[2,1,3]), 1),[2,1,3]);
    for index_page = 1 : size(input_mat,3)
        intermediate_mat(:,:,index_page) = component_row(:,:,index_page) * component_col(:,:,index_page)';
    end
    rmse_record(2*index_iter+0,2) = mean(((intermediate_mat(:) - input_mat(:)) .* valid_range(:)).^2)^0.5;
    
    % col estimation
%     component_col ...
%         = sum((component_row .* valid_range) .* (input_mat .* valid_range), 1)' ...
%         ./ sum((component_row .* valid_range) .* (component_row .* valid_range), 1)';
    component_col ...
        = permute(sum(component_row .* input_mat .* valid_range, 1),[2,1,3]) ...
        ./ permute(sum(component_row .* component_row .* valid_range, 1),[2,1,3]);
    for index_page = 1 : size(input_mat,3)
        intermediate_mat(:,:,index_page) = component_row(:,:,index_page) * component_col(:,:,index_page)';
    end
    rmse_record(2*index_iter+1,2) = mean(((intermediate_mat(:) - input_mat(:)) .* valid_range(:)).^2)^0.5;
end

output_mat = intermediate_mat;
output_component.row = permute(component_row, [1,3,2]);
output_component.col = permute(component_col, [1,3,2]);