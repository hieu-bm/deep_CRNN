clear all
clc 
acc = zeros(10,1); %10 split tests
for spl = 1:10
    load RNN_output.mat
    disp(['SPLIT: ' num2str(spl)]);
    [Train, Test] = split_config(Train, Test, spl);
    disp(['train_count: ' num2str(Train.count) '   test_count: ' num2str(Test.count)]);

    train_data = Train.data;
    train_label = Train.file;
    clear Train
    for i = 1:length(train_label)
        train_label{i} = train_label{i}(1:regexp(train_label{i}, '[0-9]')-2);
    end
    train_label = train_label';
    train_data = train_data';

    test_data = Test.data;
    test_label = Test.file;
    for i = 1:length(test_label)
        test_label{i} = test_label{i}(1:regexp(test_label{i}, '[0-9]')-2);
    end
    test_label = test_label';
    test_data = test_data';
    clear Test
    
    %%train model
    model = fitcecoc(train_data, train_label,'Coding', 'onevsall', 'Verbose', 2);

    %%save model
    file_str = sprintf('model_split%d.mat', spl);
    time = datestr(now);
    save(file_str, 'model', 'time', '-v7.3');

    %%test using trained model
    test_result = predict(model, test_data);
    cpr = zeros(length(test_label),1);
    for i = 1:length(test_label)
        cpr(i) = strcmp(test_result{i},test_label{i});
    end
    percent = sum(cpr)/length(test_label);

    acc(spl) = percent;
end
disp(['Average accuracy = ' num2str(mean(acc)) ' +/- ' num2str(std(acc))]);
 