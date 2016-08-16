function [combineAcc rgbAcc depthAcc] = runCRNN()
startTime = tic;
% init params
addpath(genpath('../matconvnet-1.0-beta20'));
addpath(genpath('../minFunc'));

params = initParams();

disp(params);

%% Run RGB
disp('Forward propagating RGB data');
params.depth = false;

% extract deep CNN features from RGB data
[cnnTrain cnnTest] = forwardCNN(params);

save('cnnTrain.mat','cnnTrain', '-v7.3');
save('cnnTest.mat','cnnTest', '-v7.3');

test_numRNN

disp('Elapsed time: ');
toc(startTime)
return;

