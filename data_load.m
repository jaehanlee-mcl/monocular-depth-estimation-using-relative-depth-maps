function [data_train, data_test, gt_train, gt_test] = data_load() 
%% disp
disp(' ')
disp('#################################################')
disp('############### Step00, Data Load ###############')
disp('#################################################')
disp(' ')
tic
%% path setting
% data_test
data_test(01,1).size = [008,008]; data_test(01).type = 'abs'; data_test(01).path = 'results/default_mode_results_test.mat';
data_test(02,1).size = [016,016]; data_test(02).type = 'abs'; data_test(02).path = 'results/default_mode_results_test.mat';
data_test(03,1).size = [032,032]; data_test(03).type = 'abs'; data_test(03).path = 'results/default_mode_results_test.mat';
data_test(04,1).size = [064,064]; data_test(04).type = 'abs'; data_test(04).path = 'results/default_mode_results_test.mat';
data_test(05,1).size = [128,128]; data_test(05).type = 'abs'; data_test(05).path = 'results/default_mode_results_test.mat';
data_test(06,1).size = [008,008]; data_test(06).type = 'rel'; data_test(06).path = 'results/default_mode_results_test.mat';
data_test(07,1).size = [016,016]; data_test(07).type = 'rel'; data_test(07).path = 'results/default_mode_results_test.mat';
data_test(08,1).size = [032,032]; data_test(08).type = 'rel'; data_test(08).path = 'results/default_mode_results_test.mat';
data_test(09,1).size = [064,064]; data_test(09).type = 'rel'; data_test(09).path = 'results/default_mode_results_test.mat';
data_test(10,1).size = [128,128]; data_test(10).type = 'rel'; data_test(10).path = 'results/default_mode_results_test.mat';
% data_train
data_train(01,1).size = [008,008]; data_train(01).type = 'abs'; data_train(01).path = 'results/default_mode_results_train.mat';
data_train(02,1).size = [016,016]; data_train(02).type = 'abs'; data_train(02).path = 'results/default_mode_results_train.mat';
data_train(03,1).size = [032,032]; data_train(03).type = 'abs'; data_train(03).path = 'results/default_mode_results_train.mat';
data_train(04,1).size = [064,064]; data_train(04).type = 'abs'; data_train(04).path = 'results/default_mode_results_train.mat';
data_train(05,1).size = [128,128]; data_train(05).type = 'abs'; data_train(05).path = 'results/default_mode_results_train.mat';
data_train(06,1).size = [008,008]; data_train(06).type = 'rel'; data_train(06).path = 'results/default_mode_results_train.mat';
data_train(07,1).size = [016,016]; data_train(07).type = 'rel'; data_train(07).path = 'results/default_mode_results_train.mat';
data_train(08,1).size = [032,032]; data_train(08).type = 'rel'; data_train(08).path = 'results/default_mode_results_train.mat';
data_train(09,1).size = [064,064]; data_train(09).type = 'rel'; data_train(09).path = 'results/default_mode_results_train.mat';
data_train(10,1).size = [128,128]; data_train(10).type = 'rel'; data_train(10).path = 'results/default_mode_results_train.mat';
disp('00-1. path setting'); toc
%% data loading
for index = [1]
    try
        % data_test
        load(data_test(index).path, 'modelre_01');
        data_test(index).modelre = modelre_01;
        % data_train
        load(data_train(index).path, 'modelre_01');
        data_train(index).modelre = modelre_01;
        data_test(index).valid = 1;
        data_train(index).valid = 1;
    catch
        data_test(index).modelre = ones(008,008,654);
        data_train(index).modelre = ones(008,008,795);
        data_test(index).valid = 0;
        data_train(index).valid = 0;
    end
end
for index = [6]
    try
        % data_test
        load(data_test(index).path, 'modelre_02');
        data_test(index).modelre = modelre_02;
        % data_train
        load(data_train(index).path, 'modelre_02');
        data_train(index).modelre = modelre_02;
        data_test(index).valid = 1;
        data_train(index).valid = 1;
    catch
        data_test(index).modelre = ones(008,008,64,654);
        data_train(index).modelre = ones(008,008,64,795);
        data_test(index).valid = 0;
        data_train(index).valid = 0;
    end
end
for index = [2]
    try
        % data_test
        load(data_test(index).path, 'modelre_03');
        data_test(index).modelre = modelre_03;
        % data_train
        load(data_train(index).path, 'modelre_03');
        data_train(index).modelre = modelre_03;
        data_test(index).valid = 1;
        data_train(index).valid = 1;
    catch
        data_test(index).modelre = ones(016,016,654);
        data_train(index).modelre = ones(016,016,795);
        data_test(index).valid = 0;
        data_train(index).valid = 0;
    end
end
for index = [7]
    try
        % data_test
        load(data_test(index).path, 'modelre_04');
        data_test(index).modelre = modelre_04;
        % data_train
        load(data_train(index).path, 'modelre_04');
        data_train(index).modelre = modelre_04;
        data_test(index).valid = 1;
        data_train(index).valid = 1;
    catch
        data_test(index).modelre = ones(016,016,25,654);
        data_train(index).modelre = ones(016,016,25,795);
        data_test(index).valid = 0;
        data_train(index).valid = 0;
    end
end
for index = [3]
    try
        % data_test
        load(data_test(index).path, 'modelre_05');
        data_test(index).modelre = modelre_05;
        % data_train
        load(data_train(index).path, 'modelre_05');
        data_train(index).modelre = modelre_05;
        data_test(index).valid = 1;
        data_train(index).valid = 1;
    catch
        data_test(index).modelre = ones(032,032,654);
        data_train(index).modelre = ones(032,032,795);
        data_test(index).valid = 0;
        data_train(index).valid = 0;
    end
end
for index = [8]
    try
        % data_test
        load(data_test(index).path, 'modelre_06');
        data_test(index).modelre = modelre_06;
        % data_train
        load(data_train(index).path, 'modelre_06');
        data_train(index).modelre = modelre_06;
        data_test(index).valid = 1;
        data_train(index).valid = 1;
    catch
        data_test(index).modelre = ones(032,032,25,654);
        data_train(index).modelre = ones(032,032,25,795);
        data_test(index).valid = 0;
        data_train(index).valid = 0;
    end
end
for index = [4]
    try
        % data_test
        load(data_test(index).path, 'modelre_07');
        data_test(index).modelre = modelre_07;
        % data_train
        load(data_train(index).path, 'modelre_07');
        data_train(index).modelre = modelre_07;
        data_test(index).valid = 1;
        data_train(index).valid = 1;
    catch
        data_test(index).modelre = ones(064,064,654);
        data_train(index).modelre = ones(064,064,795);
        data_test(index).valid = 0;
        data_train(index).valid = 0;
    end
end
for index = [9]
    try
        % data_test
        load(data_test(index).path, 'modelre_08');
        data_test(index).modelre = modelre_08;
        % data_train
        load(data_train(index).path, 'modelre_08');
        data_train(index).modelre = modelre_08;
        data_test(index).valid = 1;
        data_train(index).valid = 1;
    catch
        data_test(index).modelre = ones(064,064,25,654);
        data_train(index).modelre = ones(064,064,25,795);
        data_test(index).valid = 0;
        data_train(index).valid = 0;
    end
end
for index = [5]
    try
        % data_test
        load(data_test(index).path, 'modelre_09');
        data_test(index).modelre = modelre_09;
        % data_train
        load(data_train(index).path, 'modelre_09');
        data_train(index).modelre = modelre_09;
        data_test(index).valid = 1;
        data_train(index).valid = 1;
    catch
        data_test(index).modelre = ones(128,128,654);
        data_train(index).modelre = ones(128,128,795);
        data_test(index).valid = 0;
        data_train(index).valid = 0;
    end
end
for index = [10]
    try
        % data_test
        load(data_test(index).path, 'modelre_10');
        data_test(index).modelre = modelre_10;
        % data_train
        load(data_train(index).path, 'modelre_10');
        data_train(index).modelre = modelre_10;
        data_test(index).valid = 1;
        data_train(index).valid = 1;
    catch
        data_test(index).modelre = ones(128,128,25,654);
        data_train(index).modelre = ones(128,128,25,795);
        data_test(index).valid = 0;
        data_train(index).valid = 0;
    end
end
clear index;
clear modelre_01; clear modelre_02; clear modelre_03; clear modelre_04; clear modelre_05;
clear modelre_06; clear modelre_07; clear modelre_08; clear modelre_09; clear modelre_10;
disp('00-2. data loading'); toc
%% gt loading
gt_test.size = [427,561]; gt_test.path = 'dataset/nyu_depth_v2_labeled.mat'; gt_test.path_split = 'dataset/splits.mat';
gt_train.size = [427,561]; gt_train.path = 'dataset/nyu_depth_v2_labeled.mat'; gt_train.path_split = 'dataset/splits.mat';
load(gt_test.path, 'depths', 'images');
load(gt_test.path_split);
depths = double(depths(45:471, 41:601, :));
images = images(45:471, 41:601, :, :);
gt_test.image = images(:, :, :, testNdxs);
gt_test.depth_427_561 = depths(:, :, testNdxs);
gt_train.image = images(:, :, :, trainNdxs);
gt_train.depth_427_561 = depths(:, :, trainNdxs);
clear depths; clear images; clear testNdxs; clear trainNdxs;
disp('00-3. gt loading'); toc