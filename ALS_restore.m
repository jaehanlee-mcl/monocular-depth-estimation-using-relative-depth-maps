function [data_train_rel, data_test_rel] = ALS_restore(data_train, data_test) 
%% disp
disp(' ')
disp('#################################################')
disp('############# Step03, Rel Depth ALS #############')
disp('#################################################')
disp(' ')
tic

%% prediction relative depth ALS
% train
tic
for index = 6 : length(data_train)
    if strcmp(data_train(index).type, 'rel') && (index <= 10)
        disp(['size: ', num2str(data_train(index).size), '  type: ', data_train(index).type, '  path: ', data_train(index).path]);
        depth_size = data_train(index).size(1);
        depth_all = data_train(index).modelre;
        
        if depth_size == 008 && data_train(index).valid == 1
            disp('  depth map(rel), size 008x008')
            disp('    dist range = sqrt(98)')
            data_train_rel(1).size = [008,008];
            data_train_rel(1).type = 'rel';
            data_train_rel(1).dist = sqrt(98);
            data_train_rel(1).modelre2 = zeros(008, 008, size(depth_all,4));
            data_train_rel(2).size = [008,008];
            data_train_rel(2).type = 'rel';
            data_train_rel(2).dist = sqrt(98);
            data_train_rel(2).modelre2 = zeros(008, 008, size(depth_all,4));
            tic
            for index_img = 1 : size(depth_all,4)
                depth_one = reshape(depth_all(:,:,:,index_img), [008*008, 008*008]);
                [~, depth_component, ~] = ALS_rank_1_approximation_v3(depth_one, (depth_one>0));
                [depth_rel_1, depth_rel_2] = marge_rel_depth(depth_component, [008,008], [008,008]);
                data_train_rel(1).modelre2(:,:,index_img) = depth_rel_1;
                data_train_rel(2).modelre2(:,:,index_img) = depth_rel_2;
            end
            toc
            
        elseif depth_size == 016 && data_train(index).valid == 1
            disp('    dist range = sqrt(2)')
            data_train_rel(15).size = [016,016];
            data_train_rel(15).type = 'rel';
            data_train_rel(15).dist = sqrt(2);
            data_train_rel(15).modelre2 = zeros(016, 016, size(depth_all,4));
            data_train_rel(16).size = [008,008];
            data_train_rel(16).type = 'rel';
            data_train_rel(16).dist = sqrt(2);
            data_train_rel(16).modelre2 = zeros(008, 008, size(depth_all,4));
            for index_img = 1 : size(depth_all,4)
                depth_one = rel_depth_reindex(depth_all(:,:,:,index_img));
                valid_range = valid_range_maker_v2([016,008], 2);
                [depth_one, valid_range] = split_mat(depth_one, valid_range, [016,008], [016,008]);
                [~, depth_component, ~] = ALS_rank_1_approximation_v3(depth_one, (valid_range==1));
                [depth_rel_1, depth_rel_2] = marge_rel_depth(depth_component, [016,008], [016,008]);
                data_train_rel(15).modelre2(:,:,index_img) = depth_rel_1;
                data_train_rel(16).modelre2(:,:,index_img) = depth_rel_2;
            end
            toc
            
        elseif depth_size == 032 && data_train(index).valid == 1
            disp('    dist range = sqrt(2)')
            data_train_rel(23).size = [032,032];
            data_train_rel(23).type = 'rel';
            data_train_rel(23).dist = sqrt(2);
            data_train_rel(23).modelre2 = zeros(032, 032, size(depth_all,4));
            data_train_rel(24).size = [016,016];
            data_train_rel(24).type = 'rel';
            data_train_rel(24).dist = sqrt(2);
            data_train_rel(24).modelre2 = zeros(016, 016, size(depth_all,4));
            for index_img = 1 : size(depth_all,4)
                depth_one = rel_depth_reindex(depth_all(:,:,:,index_img));
                valid_range = valid_range_maker_v2([032,016], 2);
                [depth_one, valid_range] = split_mat(depth_one, valid_range, [032,016], [016,008]);
                [~, depth_component, ~] = ALS_rank_1_approximation_v3(depth_one, (valid_range==1));
                [depth_rel_1, depth_rel_2] = marge_rel_depth(depth_component, [032,016], [016,008]);
                data_train_rel(23).modelre2(:,:,index_img) = depth_rel_1;
                data_train_rel(24).modelre2(:,:,index_img) = depth_rel_2;
            end
            toc
            
        elseif depth_size == 064 && data_train(index).valid == 1
            disp('    dist range = sqrt(2)')
            data_train_rel(31).size = [064,064];
            data_train_rel(31).type = 'rel';
            data_train_rel(31).dist = sqrt(2);
            data_train_rel(31).modelre2 = zeros(064, 064, size(depth_all,4));
            data_train_rel(32).size = [032,032];
            data_train_rel(32).type = 'rel';
            data_train_rel(32).dist = sqrt(2);
            data_train_rel(32).modelre2 = zeros(032, 032, size(depth_all,4));
            for index_img = 1 : size(depth_all,4)
                depth_one = rel_depth_reindex(depth_all(:,:,:,index_img));
                valid_range = valid_range_maker_v2([064,032], 2);
                [depth_one, valid_range] = split_mat(depth_one, valid_range, [064,032], [016,008]);
                [~, depth_component, ~] = ALS_rank_1_approximation_v3(depth_one, (valid_range==1));
                [depth_rel_1, depth_rel_2] = marge_rel_depth(depth_component, [064,032], [016,008]);
                data_train_rel(31).modelre2(:,:,index_img) = depth_rel_1;
                data_train_rel(32).modelre2(:,:,index_img) = depth_rel_2;
            end
            toc
            
        elseif depth_size == 128 && data_train(index).valid == 1
            disp('    dist range = sqrt(2)')
            data_train_rel(39).size = [128,128];
            data_train_rel(39).type = 'rel';
            data_train_rel(39).dist = sqrt(2);
            data_train_rel(39).modelre2 = zeros(128, 128, size(depth_all,4));
            data_train_rel(40).size = [064,064];
            data_train_rel(40).type = 'rel';
            data_train_rel(40).dist = sqrt(2);
            data_train_rel(40).modelre2 = zeros(064, 064, size(depth_all,4));
            for index_img = 1 : size(depth_all,4)
                depth_one = rel_depth_reindex(depth_all(:,:,:,index_img));
                valid_range = valid_range_maker_v2([128,064], 2);
                [depth_one, valid_range] = split_mat(depth_one, valid_range, [128,064], [016,008]);
                [~, depth_component, ~] = ALS_rank_1_approximation_v3(depth_one, (valid_range==1));
                [depth_rel_1, depth_rel_2] = marge_rel_depth(depth_component, [128,064], [016,008]);
                data_train_rel(39).modelre2(:,:,index_img) = depth_rel_1;
                data_train_rel(40).modelre2(:,:,index_img) = depth_rel_2;
            end
            toc
        end
    end
end

% test
tic
for index = 1 : length(data_test)
    if strcmp(data_test(index).type, 'rel') && (index <= 10)
        disp(['size: ', num2str(data_test(index).size), '  type: ', data_test(index).type, '  path: ', data_test(index).path]);
        depth_size = data_test(index).size(1);
        depth_all = data_test(index).modelre;
        
        if depth_size == 008 && data_test(index).valid == 1
            disp('  depth map(rel), size 008x008')
            disp('    dist range = sqrt(98)')
            data_test_rel(1).size = [008,008];
            data_test_rel(1).type = 'rel';
            data_test_rel(1).dist = sqrt(98);
            data_test_rel(1).modelre2 = zeros(008, 008, size(depth_all,4));
            data_test_rel(2).size = [008,008];
            data_test_rel(2).type = 'rel';
            data_test_rel(2).dist = sqrt(98);
            data_test_rel(2).modelre2 = zeros(008, 008, size(depth_all,4));
            for index_img = 1 : size(depth_all,4)
                depth_one = reshape(depth_all(:,:,:,index_img), [008*008, 008*008]);
                [~, depth_component, ~] = ALS_rank_1_approximation_v3(depth_one, (depth_one>0));
                [depth_rel_1, depth_rel_2] = marge_rel_depth(depth_component, [008,008], [008,008]);
                data_test_rel(1).modelre2(:,:,index_img) = depth_rel_1;
                data_test_rel(2).modelre2(:,:,index_img) = depth_rel_2;
            end
            toc
            
        elseif depth_size == 016 && data_test(index).valid == 1
            disp('    dist range = sqrt(2)')
            data_test_rel(15).size = [016,016];
            data_test_rel(15).type = 'rel';
            data_test_rel(15).dist = sqrt(2);
            data_test_rel(15).modelre2 = zeros(016, 016, size(depth_all,4));
            data_test_rel(16).size = [008,008];
            data_test_rel(16).type = 'rel';
            data_test_rel(16).dist = sqrt(2);
            data_test_rel(16).modelre2 = zeros(008, 008, size(depth_all,4));
            for index_img = 1 : size(depth_all,4)
                depth_one = rel_depth_reindex(depth_all(:,:,:,index_img));
                valid_range = valid_range_maker_v2([016,008], 2);
                [depth_one, valid_range] = split_mat(depth_one, valid_range, [016,008], [016,008]);
                [~, depth_component, ~] = ALS_rank_1_approximation_v3(depth_one, (valid_range==1));
                [depth_rel_1, depth_rel_2] = marge_rel_depth(depth_component, [016,008], [016,008]);
                data_test_rel(15).modelre2(:,:,index_img) = depth_rel_1;
                data_test_rel(16).modelre2(:,:,index_img) = depth_rel_2;
            end
            toc
            
        elseif depth_size == 032 && data_test(index).valid == 1
            disp('    dist range = sqrt(2)')
            data_test_rel(23).size = [032,032];
            data_test_rel(23).type = 'rel';
            data_test_rel(23).dist = sqrt(2);
            data_test_rel(23).modelre2 = zeros(032, 032, size(depth_all,4));
            data_test_rel(24).size = [016,016];
            data_test_rel(24).type = 'rel';
            data_test_rel(24).dist = sqrt(2);
            data_test_rel(24).modelre2 = zeros(016, 016, size(depth_all,4));
            for index_img = 1 : size(depth_all,4)
                depth_one = rel_depth_reindex(depth_all(:,:,:,index_img));
                valid_range = valid_range_maker_v2([032,016], 2);
                [depth_one, valid_range] = split_mat(depth_one, valid_range, [032,016], [016,008]);
                [~, depth_component, ~] = ALS_rank_1_approximation_v3(depth_one, (valid_range==1));
                [depth_rel_1, depth_rel_2] = marge_rel_depth(depth_component, [032,016], [016,008]);
                data_test_rel(23).modelre2(:,:,index_img) = depth_rel_1;
                data_test_rel(24).modelre2(:,:,index_img) = depth_rel_2;
            end
            toc
            
        elseif depth_size == 064 && data_test(index).valid == 1
            disp('    dist range = sqrt(2)')
            data_test_rel(31).size = [064,064];
            data_test_rel(31).type = 'rel';
            data_test_rel(31).dist = sqrt(2);
            data_test_rel(31).modelre2 = zeros(064, 064, size(depth_all,4));
            data_test_rel(32).size = [032,032];
            data_test_rel(32).type = 'rel';
            data_test_rel(32).dist = sqrt(2);
            data_test_rel(32).modelre2 = zeros(032, 032, size(depth_all,4));
            for index_img = 1 : size(depth_all,4)
                depth_one = rel_depth_reindex(depth_all(:,:,:,index_img));
                valid_range = valid_range_maker_v2([064,032], 2);
                [depth_one, valid_range] = split_mat(depth_one, valid_range, [064,032], [016,008]);
                [~, depth_component, ~] = ALS_rank_1_approximation_v3(depth_one, (valid_range==1));
                [depth_rel_1, depth_rel_2] = marge_rel_depth(depth_component, [064,032], [016,008]);
                data_test_rel(31).modelre2(:,:,index_img) = depth_rel_1;
                data_test_rel(32).modelre2(:,:,index_img) = depth_rel_2;
            end
            toc
            
        elseif depth_size == 128 && data_test(index).valid == 1
            disp('    dist range = sqrt(2)')
            data_test_rel(39).size = [128,128];
            data_test_rel(39).type = 'rel';
            data_test_rel(39).dist = sqrt(2);
            data_test_rel(39).modelre2 = zeros(128, 128, size(depth_all,4));
            data_test_rel(40).size = [064,064];
            data_test_rel(40).type = 'rel';
            data_test_rel(40).dist = sqrt(2);
            data_test_rel(40).modelre2 = zeros(064, 064, size(depth_all,4));
            for index_img = 1 : size(depth_all,4)
                depth_one = rel_depth_reindex(depth_all(:,:,:,index_img));
                valid_range = valid_range_maker_v2([128,064], 2);
                [depth_one, valid_range] = split_mat(depth_one, valid_range, [128,064], [016,008]);
                [~, depth_component, ~] = ALS_rank_1_approximation_v3(depth_one, (valid_range==1));
                [depth_rel_1, depth_rel_2] = marge_rel_depth(depth_component, [128,064], [016,008]);
                data_test_rel(39).modelre2(:,:,index_img) = depth_rel_1;
                data_test_rel(40).modelre2(:,:,index_img) = depth_rel_2;
            end
            toc
            
        end
    end
end

%% rel depth decomposition
% test
for index = 1 : length(data_test_rel)
    try
        if strcmp(data_test_rel(index).type, 'rel')
            disp(['size: ', num2str(data_test_rel(index).size), '  type: ', data_test_rel(index).type]);
            depth_size = data_test_rel(index).size(1);
            depth_all = data_test_rel(index).modelre2;
            if depth_size == 128
                disp('  depth map(rel), size 128x128')
                depth_downsized = exp(imresize(log(depth_all), [064,064], 'box'));
                depth_downsized_up = imresize(depth_downsized, [128,128], 'box');
                
                data_test_rel(index).depth_128_128_res = depth_all ./ depth_downsized_up;
                depth_all = depth_downsized;
                depth_size = depth_size/2;
                clear depth_downsized; clear depth_downsized_up;
            end
            if depth_size == 064
                disp('  depth map(rel), size 064x064')
                depth_downsized = exp(imresize(log(depth_all), [032,032], 'box'));
                depth_downsized_up = imresize(depth_downsized, [064,064], 'box');
                
                data_test_rel(index).depth_064_064_res = depth_all ./ depth_downsized_up;
                depth_all = depth_downsized;
                depth_size = depth_size/2;
                clear depth_downsized; clear depth_downsized_up;
            end
            if depth_size == 032
                disp('  depth map(rel), size 032x032')
                depth_downsized = exp(imresize(log(depth_all), [016,016], 'box'));
                depth_downsized_up = imresize(depth_downsized, [032,032], 'box');
                
                data_test_rel(index).depth_032_032_res = depth_all ./ depth_downsized_up;
                depth_all = depth_downsized;
                depth_size = depth_size/2;
                clear depth_downsized; clear depth_downsized_up;
            end
            if depth_size == 016
                disp('  depth map(rel), size 016x016')
                depth_downsized = exp(imresize(log(depth_all), [008,008], 'box'));
                depth_downsized_up = imresize(depth_downsized, [016,016], 'box');
                
                data_test_rel(index).depth_016_016_res = depth_all ./ depth_downsized_up;
                depth_all = depth_downsized;
                depth_size = depth_size/2;
                clear depth_downsized; clear depth_downsized_up;
            end
            if depth_size == 008
                disp('  depth map(rel), size 008x008')
                depth_downsized = exp(imresize(log(depth_all), [004,004], 'box'));
                depth_downsized_up = imresize(depth_downsized, [008,008], 'box');
                
                data_test_rel(index).depth_008_008_res = depth_all ./ depth_downsized_up;
                depth_all = depth_downsized;
                depth_size = depth_size/2;
                clear depth_downsized; clear depth_downsized_up;
            end
            if depth_size == 004
                disp('  depth map(rel), size 004x004')
                depth_downsized = exp(imresize(log(depth_all), [002,002], 'box'));
                depth_downsized_up = imresize(depth_downsized, [004,004], 'box');
                
                data_test_rel(index).depth_004_004_res = depth_all ./ depth_downsized_up;
                depth_all = depth_downsized;
                depth_size = depth_size/2;
                clear depth_downsized; clear depth_downsized_up;
            end
            if depth_size == 002
                disp('  depth map(rel), size 002x002')
                depth_downsized = exp(imresize(log(depth_all), [001,001], 'box'));
                depth_downsized_up = imresize(depth_downsized, [002,002], 'box');
                
                data_test_rel(index).depth_002_002_res = depth_all ./ depth_downsized_up;
                depth_all = depth_downsized;
                depth_size = depth_size/2;
                clear depth_downsized; clear depth_downsized_up;
            end
        end
    catch
    end
end
clear index; clear depth_size; clear depth_all;

% train
for index = 1 : length(data_train_rel)
    try
        if strcmp(data_train_rel(index).type, 'rel')
            disp(['size: ', num2str(data_train_rel(index).size), '  type: ', data_train_rel(index).type]);
            depth_size = data_train_rel(index).size(1);
            depth_all = data_train_rel(index).modelre2;
            if depth_size == 128
                disp('  depth map(rel), size 128x128')
                depth_downsized = exp(imresize(log(depth_all), [064,064], 'box'));
                depth_downsized_up = imresize(depth_downsized, [128,128], 'box');
                
                data_train_rel(index).depth_128_128_res = depth_all ./ depth_downsized_up;
                depth_all = depth_downsized;
                depth_size = depth_size/2;
                clear depth_downsized; clear depth_downsized_up;
            end
            if depth_size == 064
                disp('  depth map(rel), size 064x064')
                depth_downsized = exp(imresize(log(depth_all), [032,032], 'box'));
                depth_downsized_up = imresize(depth_downsized, [064,064], 'box');
                
                data_train_rel(index).depth_064_064_res = depth_all ./ depth_downsized_up;
                depth_all = depth_downsized;
                depth_size = depth_size/2;
                clear depth_downsized; clear depth_downsized_up;
            end
            if depth_size == 032
                disp('  depth map(rel), size 032x032')
                depth_downsized = exp(imresize(log(depth_all), [016,016], 'box'));
                depth_downsized_up = imresize(depth_downsized, [032,032], 'box');
                
                data_train_rel(index).depth_032_032_res = depth_all ./ depth_downsized_up;
                depth_all = depth_downsized;
                depth_size = depth_size/2;
                clear depth_downsized; clear depth_downsized_up;
            end
            if depth_size == 016
                disp('  depth map(rel), size 016x016')
                depth_downsized = exp(imresize(log(depth_all), [008,008], 'box'));
                depth_downsized_up = imresize(depth_downsized, [016,016], 'box');
                
                data_train_rel(index).depth_016_016_res = depth_all ./ depth_downsized_up;
                depth_all = depth_downsized;
                depth_size = depth_size/2;
                clear depth_downsized; clear depth_downsized_up;
            end
            if depth_size == 008
                disp('  depth map(rel), size 008x008')
                depth_downsized = exp(imresize(log(depth_all), [004,004], 'box'));
                depth_downsized_up = imresize(depth_downsized, [008,008], 'box');
                
                data_train_rel(index).depth_008_008_res = depth_all ./ depth_downsized_up;
                depth_all = depth_downsized;
                depth_size = depth_size/2;
                clear depth_downsized; clear depth_downsized_up;
            end
            if depth_size == 004
                disp('  depth map(rel), size 004x004')
                depth_downsized = exp(imresize(log(depth_all), [002,002], 'box'));
                depth_downsized_up = imresize(depth_downsized, [004,004], 'box');
                
                data_train_rel(index).depth_004_004_res = depth_all ./ depth_downsized_up;
                depth_all = depth_downsized;
                depth_size = depth_size/2;
                clear depth_downsized; clear depth_downsized_up;
            end
            if depth_size == 002
                disp('  depth map(rel), size 002x002')
                depth_downsized = exp(imresize(log(depth_all), [001,001], 'box'));
                depth_downsized_up = imresize(depth_downsized, [002,002], 'box');
                
                data_train_rel(index).depth_002_002_res = depth_all ./ depth_downsized_up;
                depth_all = depth_downsized;
                depth_size = depth_size/2;
                clear depth_downsized; clear depth_downsized_up;
            end
        end
    catch
    end
end
clear index; clear depth_size; clear depth_all;