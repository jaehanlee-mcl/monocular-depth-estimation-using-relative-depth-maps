function metrics = evaluation(ensemble_test, gt_test)

gt = gt_test.depth_427_561;
pred = ensemble_test.depth_427_561_refined;

n_pxls = sum( gt(:)>0 );

% RMSE, RMSE(log)
rms = mean( ( gt(:) - pred(:) ).^2 ) ^ 0.5;
rms_log = mean( ( log(gt(:)) - log(pred(:)) ).^2 ) ^ 0.5;

% Mean Absolute Relative Error
rel = abs(gt(:) - pred(:)) ./ gt(:);    % compute errors
rel = sum(rel) / n_pxls;                % average over all pixels
rel_sqr = (gt(:) - pred(:)) .^ 2 ./ gt(:);    % compute errors
rel_sqr = sum(rel_sqr) / n_pxls;                % average over all pixels

% delta measure
delta1 = sum(   max( pred(:)./gt(:), gt(:)./pred(:) ) < 1.25 )/n_pxls;
delta2 =  sum(   max( pred(:)./gt(:), gt(:)./pred(:) ) < 1.25^2 )/n_pxls;
delta3 = sum(   max( pred(:)./gt(:), gt(:)./pred(:) ) < 1.25^3 )/n_pxls;

% RMSE, RMSE(log) -> mean of each data
rms2 = 0;
rms_log2 = 0;
for index_channel = 1 : size(gt,3)
    rms2 = rms2 + mean(mean( ( gt(:,:,index_channel) - pred(:,:,index_channel) ).^2 )) ^ 0.5 / size(gt,3);
    rms_log2 = rms_log2 + mean(mean( ( log(gt(:,:,index_channel)) - log(pred(:,:,index_channel)) ).^2 )) ^ 0.5 / size(gt,3);
end
    
% scale-invariant
for index_channel = 1 : size(gt, 3)
    pred(:,:,index_channel) = exp(log(pred(:,:,index_channel)) - mean(mean(log(pred(:,:,index_channel)))));
    gt(:,:,index_channel) = exp(log(gt(:,:,index_channel)) - mean(mean(log(gt(:,:,index_channel)))));
end
rms_s_inv = mean( ( log(gt(:)) - log(pred(:)) ).^2 ) ^ 0.5;

rms_s_inv2 = 0;
for index_channel = 1 : size(gt,3)
    rms_s_inv2 = rms_s_inv2 + mean(mean( ( log(gt(:,:,index_channel)) - log(pred(:,:,index_channel)) ).^2 )) ^ 0.5 / size(gt,3);
end

% correlation
corr_spearman = 0;
for index = 1 : size(gt, 3)
    temp_test = ensemble_test.depth_427_561_refined(:,:,index);
    temp_gt = gt_test.depth_427_561(:,:,index);
    temp_spearman = corr([temp_test(:), temp_gt(:)], 'Type', 'Spearman');
    
    corr_spearman = corr_spearman + temp_spearman(1,2)/size(gt, 3);
end

% results
metrics.RMSE_lin = rms;
metrics.RMSE_log = rms_log;
metrics.RMSE_s_inv = rms_s_inv;
metrics.ARD = rel;
metrics.SRD = rel_sqr;
metrics.delta1 = delta1;
metrics.delta2 = delta2;
metrics.delta3 = delta3;
metrics.spearman = corr_spearman;

metrics.RMSE_lin2 = rms2;
metrics.RMSE_log2 = rms_log2;
metrics.RMSE_s_inv2 = rms_s_inv2;

