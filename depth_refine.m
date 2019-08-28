function ensemble_test = depth_refine(ensemble_test, gt_test)

refined_depth = zeros(size(ensemble_test.depth_128_128));
for index = 1 : size(refined_depth,3)
    refined_depth(:,:,index) = imguidedfilter(ensemble_test.depth_128_128(:,:,index), imresize(gt_test.image(:,:,:,index), [128,128], 'lanczos3'));
end
ensemble_test.depth_427_561_refined = imresize(refined_depth, [427,561], 'bilinear');
