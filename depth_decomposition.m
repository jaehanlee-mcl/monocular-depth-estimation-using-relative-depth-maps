function [data_train, data_test, gt_train, gt_test] = depth_decomposition(data_train, data_test, gt_train, gt_test)

%% disp
disp(' ')
disp('#################################################')
disp('########## Step01, Depth Decomposition ##########')
disp('#################################################')
disp(' ')
tic

%% GT depth decomposition
% train
gt_train.depth_256_256 = exp(imresize(log(gt_train.depth_427_561), [256,256], 'lanczos3'));
gt_train.depth_128_128 = exp(imresize(log(gt_train.depth_427_561), [128,128], 'lanczos3'));
gt_train.depth_064_064 = exp(imresize(log(gt_train.depth_427_561), [064,064], 'lanczos3'));
gt_train.depth_032_032 = exp(imresize(log(gt_train.depth_064_064), [032,032], 'lanczos3'));
gt_train.depth_016_016 = exp(imresize(log(gt_train.depth_032_032), [016,016], 'lanczos3'));
gt_train.depth_008_008 = exp(imresize(log(gt_train.depth_016_016), [008,008], 'lanczos3'));
gt_train.depth_004_004 = exp(imresize(log(gt_train.depth_008_008), [004,004], 'lanczos3'));
gt_train.depth_002_002 = exp(imresize(log(gt_train.depth_004_004), [002,002], 'lanczos3'));
gt_train.depth_001_001 = exp(imresize(log(gt_train.depth_002_002), [001,001], 'lanczos3'));
gt_train.depth_mean = exp(mean(log(gt_train.depth_001_001(:))));
gt_train.depth_427_561_res = gt_train.depth_427_561 ./ imresize(gt_train.depth_256_256, [427,561], 'box');
gt_train.depth_256_256_res = gt_train.depth_256_256 ./ imresize(gt_train.depth_128_128, [256,256], 'box');
gt_train.depth_128_128_res = gt_train.depth_128_128 ./ imresize(gt_train.depth_064_064, [128,128], 'box');
gt_train.depth_064_064_res = gt_train.depth_064_064 ./ imresize(gt_train.depth_032_032, [064,064], 'box');
gt_train.depth_032_032_res = gt_train.depth_032_032 ./ imresize(gt_train.depth_016_016, [032,032], 'box');
gt_train.depth_016_016_res = gt_train.depth_016_016 ./ imresize(gt_train.depth_008_008, [016,016], 'box');
gt_train.depth_008_008_res = gt_train.depth_008_008 ./ imresize(gt_train.depth_004_004, [008,008], 'box');
gt_train.depth_004_004_res = gt_train.depth_004_004 ./ imresize(gt_train.depth_002_002, [004,004], 'box');
gt_train.depth_002_002_res = gt_train.depth_002_002 ./ imresize(gt_train.depth_001_001, [002,002], 'box'); 
gt_train.depth_001_001_res = gt_train.depth_001_001 / gt_train.depth_mean;
% test
gt_test.depth_256_256 = exp(imresize(log(gt_test.depth_427_561), [256,256], 'lanczos3'));
gt_test.depth_128_128 = exp(imresize(log(gt_test.depth_427_561), [128,128], 'lanczos3'));
gt_test.depth_064_064 = exp(imresize(log(gt_test.depth_427_561), [064,064], 'lanczos3'));
gt_test.depth_032_032 = exp(imresize(log(gt_test.depth_064_064), [032,032], 'lanczos3'));
gt_test.depth_016_016 = exp(imresize(log(gt_test.depth_032_032), [016,016], 'lanczos3'));
gt_test.depth_008_008 = exp(imresize(log(gt_test.depth_016_016), [008,008], 'lanczos3'));
gt_test.depth_004_004 = exp(imresize(log(gt_test.depth_008_008), [004,004], 'lanczos3'));
gt_test.depth_002_002 = exp(imresize(log(gt_test.depth_004_004), [002,002], 'lanczos3'));
gt_test.depth_001_001 = exp(imresize(log(gt_test.depth_002_002), [001,001], 'lanczos3'));
gt_test.depth_mean = exp(mean(log(gt_test.depth_001_001(:))));
gt_test.depth_427_561_res = gt_test.depth_427_561 ./ imresize(gt_test.depth_256_256, [427,561], 'box');
gt_test.depth_256_256_res = gt_test.depth_256_256 ./ imresize(gt_test.depth_128_128, [256,256], 'box');
gt_test.depth_128_128_res = gt_test.depth_128_128 ./ imresize(gt_test.depth_064_064, [128,128], 'box');
gt_test.depth_064_064_res = gt_test.depth_064_064 ./ imresize(gt_test.depth_032_032, [064,064], 'box');
gt_test.depth_032_032_res = gt_test.depth_032_032 ./ imresize(gt_test.depth_016_016, [032,032], 'box');
gt_test.depth_016_016_res = gt_test.depth_016_016 ./ imresize(gt_test.depth_008_008, [016,016], 'box');
gt_test.depth_008_008_res = gt_test.depth_008_008 ./ imresize(gt_test.depth_004_004, [008,008], 'box');
gt_test.depth_004_004_res = gt_test.depth_004_004 ./ imresize(gt_test.depth_002_002, [004,004], 'box');
gt_test.depth_002_002_res = gt_test.depth_002_002 ./ imresize(gt_test.depth_001_001, [002,002], 'box'); 
gt_test.depth_001_001_res = gt_test.depth_001_001 / gt_test.depth_mean;
disp('01-1. GT depth decomposition'); toc

%% prediction depth decomposition
% test
for index = 1 : length(data_test)
    if strcmp(data_test(index).type, 'abs')
        disp(['size: ', num2str(data_test(index).size), '  type: ', data_test(index).type, '  path: ', data_test(index).path]);
        depth_size = data_test(index).size(1);
        depth_all = data_test(index).modelre;
        if depth_size == 128
            disp('  depth map(abs), size 128x128')
            depth_downsized = exp(imresize(log(depth_all), [064,064], 'box'));
            depth_downsized_up = imresize(depth_downsized, [128,128], 'box');
            
            data_test(index).depth_128_128 = depth_all;
            data_test(index).depth_128_128_res = depth_all ./ depth_downsized_up;
            depth_all = depth_downsized;
            depth_size = depth_size/2;
            clear depth_downsized; clear depth_downsized_up;
        end
        if depth_size == 064
            disp('  depth map(abs), size 064x064')
            depth_downsized = exp(imresize(log(depth_all), [032,032], 'box'));
            depth_downsized_up = imresize(depth_downsized, [064,064], 'box');
            
            data_test(index).depth_064_064 = depth_all;
            data_test(index).depth_064_064_res = depth_all ./ depth_downsized_up;
            depth_all = depth_downsized;
            depth_size = depth_size/2;
            clear depth_downsized; clear depth_downsized_up;
        end
        if depth_size == 032
            disp('  depth map(abs), size 032x032')
            depth_downsized = exp(imresize(log(depth_all), [016,016], 'box'));
            depth_downsized_up = imresize(depth_downsized, [032,032], 'box');
            
            data_test(index).depth_032_032 = depth_all;
            data_test(index).depth_032_032_res = depth_all ./ depth_downsized_up;
            depth_all = depth_downsized;
            depth_size = depth_size/2;
            clear depth_downsized; clear depth_downsized_up;
        end
        if depth_size == 016
            disp('  depth map(abs), size 016x016')
            depth_downsized = exp(imresize(log(depth_all), [008,008], 'box'));
            depth_downsized_up = imresize(depth_downsized, [016,016], 'box');
            
            data_test(index).depth_016_016 = depth_all;
            data_test(index).depth_016_016_res = depth_all ./ depth_downsized_up;
            depth_all = depth_downsized;
            depth_size = depth_size/2;
            clear depth_downsized; clear depth_downsized_up;
        end
        if depth_size == 008
            disp('  depth map(abs), size 008x008')
            depth_downsized = exp(imresize(log(depth_all), [004,004], 'box'));
            depth_downsized_up = imresize(depth_downsized, [008,008], 'box');
            
            data_test(index).depth_008_008 = depth_all;
            data_test(index).depth_008_008_res = depth_all ./ depth_downsized_up;
            depth_all = depth_downsized;
            depth_size = depth_size/2;
            clear depth_downsized; clear depth_downsized_up;
        end
        if depth_size == 004
            disp('  depth map(abs), size 004x004')
            depth_downsized = exp(imresize(log(depth_all), [002,002], 'box'));
            depth_downsized_up = imresize(depth_downsized, [004,004], 'box');
            
            data_test(index).depth_004_004 = depth_all;
            data_test(index).depth_004_004_res = depth_all ./ depth_downsized_up;
            depth_all = depth_downsized;
            depth_size = depth_size/2;
            clear depth_downsized; clear depth_downsized_up;
        end
        if depth_size == 002
            disp('  depth map(abs), size 002x002')
            depth_downsized = exp(imresize(log(depth_all), [001,001], 'box'));
            depth_downsized_up = imresize(depth_downsized, [002,002], 'box');
            
            data_test(index).depth_002_002 = depth_all;
            data_test(index).depth_002_002_res = depth_all ./ depth_downsized_up;
            depth_all = depth_downsized;
            depth_size = depth_size/2;
            clear depth_downsized; clear depth_downsized_up;
        end
        if depth_size == 001
            disp('  depth map(abs), size 001x001')
            data_test(index).depth_001_001 = depth_all;
            data_test(index).depth_001_001_res = depth_all / exp(mean(log(depth_all(:))));
            data_test(index).depth_mean = exp(mean(log(depth_all(:)))); 
        end
    end
end
clear index; clear depth_size; clear depth_all;

% train
for index = 1 : length(data_train)
    if strcmp(data_train(index).type, 'abs')
        disp(['size: ', num2str(data_train(index).size), '  type: ', data_train(index).type, '  path: ', data_train(index).path]);
        depth_size = data_train(index).size(1);
        depth_all = data_train(index).modelre;
        if depth_size == 128
            disp('  depth map(abs), size 128x128')
            depth_downsized = exp(imresize(log(depth_all), [064,064], 'box'));
            depth_downsized_up = imresize(depth_downsized, [128,128], 'box');
            
            data_train(index).depth_128_128 = depth_all;
            data_train(index).depth_128_128_res = depth_all ./ depth_downsized_up;
            depth_all = depth_downsized;
            depth_size = depth_size/2;
            clear depth_downsized; clear depth_downsized_up;
        end
        if depth_size == 064
            disp('  depth map(abs), size 064x064')
            depth_downsized = exp(imresize(log(depth_all), [032,032], 'box'));
            depth_downsized_up = imresize(depth_downsized, [064,064], 'box');
            
            data_train(index).depth_064_064 = depth_all;
            data_train(index).depth_064_064_res = depth_all ./ depth_downsized_up;
            depth_all = depth_downsized;
            depth_size = depth_size/2;
            clear depth_downsized; clear depth_downsized_up;
        end
        if depth_size == 032
            disp('  depth map(abs), size 032x032')
            depth_downsized = exp(imresize(log(depth_all), [016,016], 'box'));
            depth_downsized_up = imresize(depth_downsized, [032,032], 'box');
            
            data_train(index).depth_032_032 = depth_all;
            data_train(index).depth_032_032_res = depth_all ./ depth_downsized_up;
            depth_all = depth_downsized;
            depth_size = depth_size/2;
            clear depth_downsized; clear depth_downsized_up;
        end
        if depth_size == 016
            disp('  depth map(abs), size 016x016')
            depth_downsized = exp(imresize(log(depth_all), [008,008], 'box'));
            depth_downsized_up = imresize(depth_downsized, [016,016], 'box');
            
            data_train(index).depth_016_016 = depth_all;
            data_train(index).depth_016_016_res = depth_all ./ depth_downsized_up;
            depth_all = depth_downsized;
            depth_size = depth_size/2;
            clear depth_downsized; clear depth_downsized_up;
        end
        if depth_size == 008
            disp('  depth map(abs), size 008x008')
            depth_downsized = exp(imresize(log(depth_all), [004,004], 'box'));
            depth_downsized_up = imresize(depth_downsized, [008,008], 'box');
            
            data_train(index).depth_008_008 = depth_all;
            data_train(index).depth_008_008_res = depth_all ./ depth_downsized_up;
            depth_all = depth_downsized;
            depth_size = depth_size/2;
            clear depth_downsized; clear depth_downsized_up;
        end
        if depth_size == 004
            disp('  depth map(abs), size 004x004')
            depth_downsized = exp(imresize(log(depth_all), [002,002], 'box'));
            depth_downsized_up = imresize(depth_downsized, [004,004], 'box');
            
            data_train(index).depth_004_004 = depth_all;
            data_train(index).depth_004_004_res = depth_all ./ depth_downsized_up;
            depth_all = depth_downsized;
            depth_size = depth_size/2;
            clear depth_downsized; clear depth_downsized_up;
        end
        if depth_size == 002
            disp('  depth map(abs), size 002x002')
            depth_downsized = exp(imresize(log(depth_all), [001,001], 'box'));
            depth_downsized_up = imresize(depth_downsized, [002,002], 'box');
            
            data_train(index).depth_002_002 = depth_all;
            data_train(index).depth_002_002_res = depth_all ./ depth_downsized_up;
            depth_all = depth_downsized;
            depth_size = depth_size/2;
            clear depth_downsized; clear depth_downsized_up;
        end
        if depth_size == 001
            disp('  depth map(abs), size 001x001')
            data_train(index).depth_001_001 = depth_all;
            data_train(index).depth_001_001_res = depth_all / exp(mean(log(depth_all(:))));
            data_train(index).depth_mean = exp(mean(log(depth_all(:)))); 
        end
    end
end
clear index; clear depth_size; clear depth_all;
disp('01-2. prediction depth decomposition'); toc
