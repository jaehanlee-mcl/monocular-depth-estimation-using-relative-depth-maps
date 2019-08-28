addpath('functionset');

% Add MatCaffe Path
matcaffe_path = 'caffe-master/matlab/';
addpath(matcaffe_path)

caffe.set_mode_gpu();
caffe.reset_all;
caffe.set_device(2); % Setting GPU here

GLOBAL_BATCH_SIZE = 6;

GLOBAL_ENCODER_NAME = 'DenseNet1651or';
GLOBAL_ENCODER_INPUT_NAME = 'data';
GLOBAL_ENCODER_INPUT_WIDTH = 224;
GLOBAL_ENCODER_INPUT_HEIGHT = 224;
GLOBAL_ENCODER_INPUT_CHANNEL = 003;
GLOBAL_ENCODER_OUTPUT_WIDTH = 008;
GLOBAL_ENCODER_OUTPUT_HEIGHT = 008;
GLOBAL_ENCODER_OUTPUT_CHANNEL = 1056;

% for Ordinal Depth 3
GLOBAL_DECODER01_OUTPUT_NAME = 'DenseNet16520or/pred_2D_008_008_ch068';
GLOBAL_DECODER01_OUTPUT_WIDTH = 008;
GLOBAL_DECODER01_OUTPUT_HEIGHT = 008;
GLOBAL_DECODER01_OUTPUT_CHANNEL = 068;
% for Relative Depth 3
GLOBAL_DECODER02_OUTPUT_NAME = 'DenseNet16521or/pred_2D_008_008_ch2560';
GLOBAL_DECODER02_OUTPUT_WIDTH = 008;
GLOBAL_DECODER02_OUTPUT_HEIGHT = 008;
GLOBAL_DECODER02_OUTPUT_CHANNEL = 2560;
GLOBAL_DECODER02_OUTPUT_CHANNEL_REDUCED = 064;
% for Relative Depth 4
GLOBAL_DECODER04_OUTPUT_NAME = 'DenseNet16523or/pred_2D_016_016_ch1000';
GLOBAL_DECODER04_OUTPUT_WIDTH = 016;
GLOBAL_DECODER04_OUTPUT_HEIGHT = 016;
GLOBAL_DECODER04_OUTPUT_CHANNEL = 1000;
GLOBAL_DECODER04_OUTPUT_CHANNEL_REDUCED = 025;
% for Relative Depth 5
GLOBAL_DECODER06_OUTPUT_NAME = 'DenseNet16525or/pred_2D_032_032_ch1000';
GLOBAL_DECODER06_OUTPUT_WIDTH = 032;
GLOBAL_DECODER06_OUTPUT_HEIGHT = 032;
GLOBAL_DECODER06_OUTPUT_CHANNEL = 1000;
GLOBAL_DECODER06_OUTPUT_CHANNEL_REDUCED = 025;
GLOBAL_DECODER02_INPUT_HEIGHT = GLOBAL_ENCODER_OUTPUT_HEIGHT;
% for Relative Depth 6
GLOBAL_DECODER08_OUTPUT_NAME = 'DenseNet16527or/pred_2D_064_064_ch1000';
GLOBAL_DECODER08_OUTPUT_WIDTH = 064;
GLOBAL_DECODER08_OUTPUT_HEIGHT = 064;
GLOBAL_DECODER08_OUTPUT_CHANNEL = 1000;
GLOBAL_DECODER08_OUTPUT_CHANNEL_REDUCED = 025;

%% Load Image & depth
if ~exist('imset')
    load('dataset/nyu_depth_v2_labeled.mat', 'images')
    load('dataset/nyu_depth_v2_labeled.mat', 'depths')
    load('dataset/splits.mat', 'testNdxs', 'trainNdxs')
    imset_test = images(45:471, 41:601, :, testNdxs);
    gtset_test = depths(45:471, 41:601, testNdxs);
    imset_train = images(45:471, 41:601, :, trainNdxs);
    gtset_train = depths(45:471, 41:601, trainNdxs);
    clear images; clear depths; clear testNdxs;
end

% test
resultpath = 'results/';
if ~exist( resultpath, 'dir' );
    mkdir( resultpath );
end

%% Encoder
net_name = ['models/', 'default_mode_net', '.prototxt'];
model_name = ['Snapshot/default_mode_net.caffemodel'];
net = caffe.get_net(net_name, 'test');
net.copy_from(model_name);

%% Batch resape
data_sz = net.blobs('data').shape();
data_sz(4) = GLOBAL_BATCH_SIZE;
net.blobs('data').reshape(data_sz);

data_sz = net.blobs('label_008_008_ch068').shape();
data_sz(4) = GLOBAL_BATCH_SIZE;
net.blobs('label_008_008_ch068').reshape(data_sz);

data_sz = net.blobs('label_008_008_ch2560').shape();
data_sz(4) = GLOBAL_BATCH_SIZE;
net.blobs('label_008_008_ch2560').reshape(data_sz);

data_sz = net.blobs('label_016_016_ch1000').shape();
data_sz(4) = GLOBAL_BATCH_SIZE;
net.blobs('label_016_016_ch1000').reshape(data_sz);

data_sz = net.blobs('label_032_032_ch1000').shape();
data_sz(4) = GLOBAL_BATCH_SIZE;
net.blobs('label_032_032_ch1000').reshape(data_sz);

data_sz = net.blobs('label_064_064_ch1000').shape();
data_sz(4) = GLOBAL_BATCH_SIZE;
net.blobs('label_064_064_ch1000').reshape(data_sz);

net.forward_prefilled;

for data_train_test = [0,1]
    
    %% image setting
    if data_train_test == 0
        data_class = 'train';
        data_num = 795;
        % image RGB -> BGR
        imset2 = double(imset_train(:,:,[3 2 1],:));
    elseif data_train_test == 1
        data_class = 'test';
        data_num = 654;
        % image RGB -> BGR
        imset2 = double(imset_test(:,:,[3 2 1],:));
    end
    % image subtract mean value
    imset2(:,:,1,:) = imset2(:,:,1,:) - 104;
    imset2(:,:,2,:) = imset2(:,:,2,:) - 117;
    imset2(:,:,3,:) = imset2(:,:,3,:) - 123;
    
    %% Space for prediction
    modelre_01_temp = zeros( GLOBAL_DECODER01_OUTPUT_HEIGHT, GLOBAL_DECODER01_OUTPUT_WIDTH, data_num, 2 );
    modelre_02_temp = zeros( GLOBAL_DECODER02_OUTPUT_HEIGHT, GLOBAL_DECODER02_OUTPUT_WIDTH, GLOBAL_DECODER02_OUTPUT_CHANNEL_REDUCED, data_num, 2 );
    modelre_04_temp = zeros( GLOBAL_DECODER04_OUTPUT_HEIGHT, GLOBAL_DECODER04_OUTPUT_WIDTH, GLOBAL_DECODER04_OUTPUT_CHANNEL_REDUCED, data_num, 2 );
    modelre_06_temp = zeros( GLOBAL_DECODER06_OUTPUT_HEIGHT, GLOBAL_DECODER06_OUTPUT_WIDTH, GLOBAL_DECODER06_OUTPUT_CHANNEL_REDUCED, data_num, 2 );
    modelre_08_temp = zeros( GLOBAL_DECODER08_OUTPUT_HEIGHT, GLOBAL_DECODER08_OUTPUT_WIDTH, GLOBAL_DECODER08_OUTPUT_CHANNEL_REDUCED, data_num, 2 );

    %% Prediction step
    disp('Prediction Start')
    tic
    for image_flip = 1 : 2
        im = zeros(size(imset2,1), size(imset2,2), size(imset2,3), GLOBAL_BATCH_SIZE);
        for fInd = 1 : GLOBAL_BATCH_SIZE : data_num
            
            fInd_start = fInd;
            fInd_end = min(fInd + (GLOBAL_BATCH_SIZE-1), data_num);
            if image_flip == 1 % NO-FLIP (left-right)
                im(:, :, :, 1 : fInd_end-fInd_start+1) = imset2(:,:,:,fInd_start:fInd_end);
            elseif image_flip == 2 % FLIP (left-right)
                im(:, :, :, 1 : fInd_end-fInd_start+1) = flip(imset2(:,:,:,fInd_start:fInd_end), 2);
            end
            
            %% Result
            % encoder
            net.blobs(GLOBAL_ENCODER_INPUT_NAME).set_data( single( permute( imresize(im, [GLOBAL_ENCODER_INPUT_HEIGHT GLOBAL_ENCODER_INPUT_WIDTH]), [2 1 3 4] ) ) );
            net.forward_prefilled;
            
            pred_01_label = permute(net.blobs(GLOBAL_DECODER01_OUTPUT_NAME).get_data, [2 1 3 4]);
            pred_02_label = permute(net.blobs(GLOBAL_DECODER02_OUTPUT_NAME).get_data, [2 1 3 4]);
            pred_04_label = permute(net.blobs(GLOBAL_DECODER04_OUTPUT_NAME).get_data, [2 1 3 4]);
            pred_06_label = permute(net.blobs(GLOBAL_DECODER06_OUTPUT_NAME).get_data, [2 1 3 4]);
            pred_08_label = permute(net.blobs(GLOBAL_DECODER08_OUTPUT_NAME).get_data, [2 1 3 4]);
            
            for index_batch = fInd_start : fInd_end
                pred_01 = ch068_labeling_inv(round(pred_01_label(:, :, :, index_batch-fInd_start+1)));
                pred_02 = relative_labeling_v1_inv(round(pred_02_label(:, :, :, index_batch-fInd_start+1)));
                pred_04 = relative_labeling_v2_inv(round(pred_04_label(:, :, :, index_batch-fInd_start+1)));
                pred_06 = relative_labeling_v3_inv(round(pred_06_label(:, :, :, index_batch-fInd_start+1)));
                pred_08 = relative_labeling_v4_inv(round(pred_08_label(:, :, :, index_batch-fInd_start+1)));
                
                if image_flip == 1 % NO-FLIP (left-right)
                    % PASS
                elseif image_flip == 2 % NO-FLIP (left-right)
                    pred_01 = flip(pred_01,2);
                    pred_02 = reshape(flip(flip(reshape(pred_02, 008,008,008,008),2),4),008,008,008*008);
                    pred_04 = reshape(flip(flip(reshape(pred_04, 016,016,005,005),2),4),016,016,005*005);
                    pred_06 = reshape(flip(flip(reshape(pred_06, 032,032,005,005),2),4),032,032,005*005);
                    pred_08 = reshape(flip(flip(reshape(pred_08, 064,064,005,005),2),4),064,064,005*005);
                end  
                
                modelre_01_temp(:,:,index_batch, image_flip) = pred_01;
                modelre_02_temp(:, :, :, index_batch, image_flip) = pred_02;
                modelre_04_temp(:, :, :, index_batch, image_flip) = pred_04;
                modelre_06_temp(:, :, :, index_batch, image_flip) = pred_06;
                modelre_08_temp(:, :, :, index_batch, image_flip) = pred_08;
            end
            
            disp(num2str(fInd))
            toc
        end
    end
    modelre_01 = modelre_01_temp(:,:,:,1)/2 + modelre_01_temp(:,:,:,2)/2;
    modelre_02 = modelre_02_temp(:,:,:,:,1)/2 + modelre_02_temp(:,:,:,:,2)/2;
    modelre_04 = modelre_04_temp(:,:,:,:,1)/2 + modelre_04_temp(:,:,:,:,2)/2;
    modelre_06 = modelre_06_temp(:,:,:,:,1)/2 + modelre_06_temp(:,:,:,:,2)/2;
    modelre_08 = modelre_08_temp(:,:,:,:,1)/2 + modelre_08_temp(:,:,:,:,2)/2;
    
    mkdir(['results']);
    save(['results/default_mode_results_', data_class, '.mat'], ...
        'modelre_01', 'modelre_02', 'modelre_04', 'modelre_06', 'modelre_08', '-v7.3');
end

caffe.reset_all