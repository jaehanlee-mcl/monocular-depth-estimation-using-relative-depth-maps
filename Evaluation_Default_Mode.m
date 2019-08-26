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
    load('dataset/splits.mat', 'testNdxs')
    imset = images(45:471, 41:601, :, testNdxs);
    gtset = depths(45:471, 41:601, testNdxs);
    clear images; clear depths; clear testNdxs;
    
    gtset_01 = exp(imresize(imresize(log(gtset),[064 064],'lanczos3'), [GLOBAL_DECODER01_OUTPUT_HEIGHT, GLOBAL_DECODER01_OUTPUT_WIDTH], 'box'));
    gtset_02_temp = exp(imresize(imresize(log(gtset),[064 064],'lanczos3'), [GLOBAL_DECODER02_OUTPUT_HEIGHT, GLOBAL_DECODER02_OUTPUT_WIDTH], 'box'));
    gtset_04_temp = exp(imresize(imresize(log(gtset),[064 064],'lanczos3'), [GLOBAL_DECODER04_OUTPUT_HEIGHT, GLOBAL_DECODER04_OUTPUT_WIDTH], 'box'));
    gtset_06_temp = exp(imresize(imresize(log(gtset),[064 064],'lanczos3'), [GLOBAL_DECODER06_OUTPUT_HEIGHT, GLOBAL_DECODER06_OUTPUT_WIDTH], 'box'));
    gtset_08_temp = exp(imresize(imresize(log(gtset),[064 064],'lanczos3'), [GLOBAL_DECODER08_OUTPUT_HEIGHT, GLOBAL_DECODER08_OUTPUT_WIDTH], 'box'));
    for index = 1 : 654
        gtset_01_label(:,:,:,index) = ch068_labeling(gtset_01(:,:,index));
        gtset_02(:,:,:,index) = relative_labeling_v1_part(gtset_02_temp(:,:,index));
        gtset_04(:,:,:,index) = relative_labeling_v2_part(gtset_04_temp(:,:,index));
        gtset_06(:,:,:,index) = relative_labeling_v3_part(gtset_06_temp(:,:,index));
        gtset_08(:,:,:,index) = relative_labeling_v4_part(gtset_08_temp(:,:,index));
    end
end

% test
resultpath = 'results/';
if ~exist( resultpath, 'dir' );
    mkdir( resultpath );
end

%% Encoder
net_name = ['models/', 'default_mode_net', '.prototxt'];
model_name = ['Snapshot/default_mode_net/default_mode_net.caffemodel'];
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

%% Space for prediction
modelre_01 = zeros( GLOBAL_DECODER01_OUTPUT_HEIGHT, GLOBAL_DECODER01_OUTPUT_WIDTH, 654 );
modelre_02 = zeros( GLOBAL_DECODER02_OUTPUT_HEIGHT, GLOBAL_DECODER02_OUTPUT_WIDTH, GLOBAL_DECODER02_OUTPUT_CHANNEL_REDUCED, 654 );
modelre_04 = zeros( GLOBAL_DECODER04_OUTPUT_HEIGHT, GLOBAL_DECODER04_OUTPUT_WIDTH, GLOBAL_DECODER04_OUTPUT_CHANNEL_REDUCED, 654 );
modelre_06 = zeros( GLOBAL_DECODER06_OUTPUT_HEIGHT, GLOBAL_DECODER06_OUTPUT_WIDTH, GLOBAL_DECODER06_OUTPUT_CHANNEL_REDUCED, 654 );
modelre_08 = zeros( GLOBAL_DECODER08_OUTPUT_HEIGHT, GLOBAL_DECODER08_OUTPUT_WIDTH, GLOBAL_DECODER08_OUTPUT_CHANNEL_REDUCED, 654 );

%% image setting
% image RGB -> BGR
imset2 = double(imset(:,:,[3 2 1],:));
% image subtract mean value
imset2(:,:,1,:) = imset2(:,:,1,:) - 104;
imset2(:,:,2,:) = imset2(:,:,2,:) - 117;
imset2(:,:,3,:) = imset2(:,:,3,:) - 123;

%% Prediction step
disp('Prediction Start')
tic
im = zeros(size(imset2,1), size(imset2,2), size(imset2,3), GLOBAL_BATCH_SIZE);
for fInd = 1 : GLOBAL_BATCH_SIZE : 654
    
    fInd_start = fInd;
    fInd_end = min(fInd + (GLOBAL_BATCH_SIZE-1), 654);
    im(:, :, :, 1 : fInd_end-fInd_start+1) = imset2(:,:,:,fInd_start:fInd_end);
    
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
        modelre_01(:,:,index_batch) = pred_01;
        
        pred_02 = relative_labeling_v1_inv(round(pred_02_label(:, :, :, index_batch-fInd_start+1)));
        modelre_02(:, :, :, index_batch) = pred_02;
        
        pred_04 = relative_labeling_v2_inv(round(pred_04_label(:, :, :, index_batch-fInd_start+1)));
        modelre_04(:, :, :, index_batch) = pred_04;
        
        pred_06 = relative_labeling_v3_inv(round(pred_06_label(:, :, :, index_batch-fInd_start+1)));
        modelre_06(:, :, :, index_batch) = pred_06;
        
        pred_08 = relative_labeling_v4_inv(round(pred_08_label(:, :, :, index_batch-fInd_start+1)));
        modelre_08(:, :, :, index_batch) = pred_08;
    end
    
    
    disp(num2str(fInd))
    toc
end

scorere_01 = error_metrics_full( double(modelre_01), gtset_01, (gtset_01>0) );
scorere_02 = error_metrics_full( double(modelre_02), gtset_02, ones( size( gtset_02 ) ) )
scorere_04 = error_metrics_full( double(modelre_04), gtset_04, ones( size( gtset_04 ) ) )
scorere_06 = error_metrics_full( double(modelre_06), gtset_06, ones( size( gtset_06 ) ) )
scorere_08 = error_metrics_full( double(modelre_08), gtset_08, ones( size( gtset_08 ) ) )

mkdir(['results/default_mode_net']);
save(['results/default_mode_net/default_mode_results.mat'], ...
    'modelre_01', 'modelre_02', 'modelre_04', 'modelre_06', 'modelre_08');

caffe.reset_all