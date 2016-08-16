function params = initParams()
%option to display incorrect classifications
params.recogDisp = 1; %value other than 0 will display all misclassified objects (messy)

% Set the data folder here
params.dataFolder = '../W_RGBD_dataset/';

% set the data split to train and test on 
params.split = 2;

% set the number of CNN filters
params.numFilters = 256; %number of filters in selected layer of CNN model

% set the number of RNN to use
params.numRNN = 128;

%load the pretrained deep net model
run('vl_setupnn.m')
% params.cnnModel.net = load('imagenet-caffe-alex.mat'); %AlexNet (2012)
params.cnnModel.net = load('imagenet-vgg-f.mat'); %KenNet (2014)

%choose the layer in deep net to extract feature
% params.layer = 10; %3rd CNN layer 
				   %KenNet: 2*(13*13*128) or (256*13*13)
				   %AlexNet: 2*(13*13*192) or (384*13*13)
params.layer = 13; %4th CNN layer
				   %KenNet: 2*(13*13*128) or (256*13*13)
				   %AlexNet: 2*(13*13*192) or (384*13*13)
% params.layer = 15; %5th CNN layer 2*(13*13*128) or (13*13*256)
% params.layer = 17; %first fully connect layer 2*(2048) = 64*64
% params.layer = 19; %second fully connect layer 2*(2048) = 64*64
