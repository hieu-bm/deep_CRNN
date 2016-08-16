%separate training and testing data from convolutional output will be very
%slow due to huge array access. RNN mapping is individually independent,
%thus separate after mapping will not affect the performance.
%However, the same process will not be true for filter selecting, as during
%RNN mapping, filter responses are mixed!

% --> change number of RNN, then run the mapping, then separate.


clear
addpath(genpath('../matconvnet-1.0-beta20'));
addpath(genpath('../minFunc'));

params = initParams();
% hard code the receptive field size (or child size) of each RNN
params.RFS = [13 13]; %set base on size of extracted CNN features

numRNN_array = [128, 64, 32, 16, 8, 4, 2, 1];
acc = zeros(10,length(numRNN_array));
count = 1;
for i = numRNN_array
    load('cnnTest.mat')
    load('cnnTrain.mat')
    
    params.numRNN = i;
    disp(['numRNN = ' num2str(params.numRNN)]);
    
    % rnn = initRandomRNNWeights(params, size(rgbTest.data,2));
    for r = 1:(floor(log(size(cnnTest.data,2))/log(params.RFS(1))+0.5) - 1) %need "depth-1" sets of weights for each RNN
        rnn{r} = initRandomRNNWeights(params, size(cnnTest.data,2));
    end

    %%using RNN
    [rnnTrain, rnnTest] = forwardRNN(cnnTrain, cnnTest, params, rnn);
    if (params.numRNN == 128)
        save('RNN_output', 'rnnTrain', 'rnnTest', '-v7.3');
    end
    clear cnnTrain cnnTest  %release some memory
    
    % not using RNN
    %     rnnTrain = cnnTrain;
    %     rnnTest = cnnTest;
    %     rnnTrain.data = rnnTrain.data(:,:)';
    %     rnnTest.data  = rnnTest.data(:,:)';

    %%
    for spl = 1:10
        params.split = spl;
        disp(['SPLIT: ' num2str(spl)]);
        [rnnTrain, rnnTest] = split_config(rnnTrain, rnnTest, spl);
        disp(['train_count: ' num2str(rnnTrain.count) '   test_count: ' num2str(rnnTest.count)]);

        [rgbAcc, y_predict, confidence] = trainSoftmax(rnnTrain, rnnTest, params);

        acc(spl, count) = rgbAcc;
    end
    disp(['Num of RNN: ' num2str(params.numRNN)]);
    disp(['Average accuracy = ' num2str(mean(acc(:,count))) ' +/- ' num2str(std(acc(:,count)))]);
    
    count = count + 1; %tracking RNN profile
    
end

Accuracy = mean(acc);
Std_dev = std(acc);
Num_of_RNN = numRNN_array;
t = table(Num_of_RNN', Accuracy', Std_dev','VariableNames',{'Num_of_RNN' 'Accuracy' 'Std_dev'});
disp 'SUMMARY:'
disp(t);
