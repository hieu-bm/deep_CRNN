function [percentCorrect, y_predict, confidence] = softmaxTest(theta,test, params)
%Hieu changed: x, y -> test, then:
x = test.data;
y = test.labels;


correct = 0;
total = 0;
y_predict = zeros(size(y));
confidence = zeros(size(y));
raw_predict = zeros(max(y),length(y)); %Hieu added
label_cmpr = {'PREDICTED', 'REAL ITEM'}; %Misclassified list
for i = 1:length(y)
    num = exp(theta*x(:,i));
    raw_predict(:,i) = num;
    norm_predict = num/sum(num); 
    [confidence(i), y_predict(i)] = max(norm_predict);

    %for comparing numbered labels
    if (y(i) == y_predict(i))
        correct = correct + 1;
    else %Hieu added
        tmp = find(y == y_predict(i),1);
        label_cmpr{i-correct+1,1} = test.file{tmp}(1:(regexp(test.file{tmp},'[0-9]') - 2));
        label_cmpr{i-correct+1,2} = test.file{i};
    end
    total = total + 1;
end
if (params.recogDisp)
    disp(label_cmpr);
end

%save result (unnormalized) for later combination (if need)
file_str = sprintf('raw_predict_split%d_%dRNN.mat', params.split, params.numRNN);
time = datestr(now);
real_labels = test.labels;
save(file_str, 'raw_predict', 'real_labels', 'time', '-v7.3');

percentCorrect = (correct/total)*100;
end