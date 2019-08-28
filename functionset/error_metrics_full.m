function results = error_metrics_full(pred, gt, mask)
    n_pxls = sum( mask(:) );
    
    gt = gt(find(mask));
    pred = pred(find(mask));
    
    rms = mean( ( gt(:) - pred(:) ).^2 ) ^ 0.5;
    rms_log = mean( ( log(gt(:)) - log(pred(:)) ).^2 ) ^ 0.5;
    
    % Mean Absolute Relative Error
    rel = abs(gt(:) - pred(:)) ./ gt(:);    % compute errors
    rel = sum(rel) / n_pxls;                % average over all pixels
    rel_sqr = (gt(:) - pred(:)) .^ 2 ./ gt(:);    % compute errors
    rel_sqr = sum(rel_sqr) / n_pxls;                % average over all pixels
    % fprintf('Mean Absolute Relative Error: %4f\n', rel);
    
    % LOG10 Error
    lg10 = abs(log10(gt(:)) - log10(pred(:)));
    lg10 = sum(lg10) / n_pxls ;
    
    % delta measure
    delta1 = sum(   max( pred(:)./gt(:), gt(:)./pred(:) ) < 1.25 )/n_pxls;
    delta2 =  sum(   max( pred(:)./gt(:), gt(:)./pred(:) ) < 1.25^2 )/n_pxls;
    delta3 = sum(   max( pred(:)./gt(:), gt(:)./pred(:) ) < 1.25^3 )/n_pxls;
    
    % all harmony
    performance_harmony = harmmean([rel, rel_sqr, rms, rms_log, lg10, (1-delta1), (1-delta2), (1-delta3)]);
    % all geo
    performance_geo = geomean([rel, rms, (1-delta1)]);
    
    % % nmeasure
    % nmea = cal_nmea(pred, gt, [] );
    
    % results.nmea = nmea;
    results.rel = rel;
    results.rel_sqr = rel_sqr;
    results.rms = rms;
    results.rms_log = rms_log;
    results.log10 = lg10;
    results.delta1= delta1;
    results.delta2= delta2;
    results.delta3= delta3;
    results.performance_harmony = performance_harmony;
    results.performance_geo = performance_geo;
