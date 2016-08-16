%separate data depend on slit config
function [new_train, new_test] = split_config(old_train, old_test, SPLIT_CHOICE)
    load ('classes.mat');
    load ('splits.mat');
    splits = splits(:, SPLIT_CHOICE);
    new_train.count = 0;
    new_test.count = 0;

    for i = 1:old_test.count
        idx = regexp(old_test.file{i},'[0-9]');
        inst = idx(1);      %position of first digit in the file name, which is the instance number
        class_name = old_test.file{i}(1:inst-2); %ex: 'apple'
        k = 1;
        inst_num = str2double(old_test.file{i}(inst));
        while (k < length(idx) && (idx(k+1) - inst) == 1) %build number from consecutive digits
            k = k + 1;
            inst_num = inst_num*10+str2double(old_test.file{i}(idx(k)));
        end
        inst = inst_num; %complete instance number from file name

        if(inst == splits(old_test.labels(i)) && strcmp(classes(old_test.labels(i)), class_name)) %correct instance and class -> test set!
           new_test.count = new_test.count+1;
           new_test.data(:,new_test.count) = old_test.data(:,i);
           new_test.labels(new_test.count) = old_test.labels(i);
           new_test.extra(new_test.count,:) = old_test.extra(i,:);
           new_test.file(new_test.count) = old_test.file(i);

        else
           new_train.count = new_train.count+1;
           new_train.data(:,new_train.count) = old_test.data(:,i);
           new_train.labels(new_train.count) = old_test.labels(i);
           new_train.extra(new_train.count,:) = old_test.extra(i,:);
           new_train.file(new_train.count) = old_test.file(i);
        end
    end

    for i = 1:old_train.count
        idx = regexp(old_train.file{i},'[0-9]');
        inst = idx(1);
        class_name = old_train.file{i}(1:inst-2);
        k = 1;
        inst_num = str2double(old_train.file{i}(inst));
        while (k < length(idx) && (idx(k+1) - inst) == 1) 
            k = k + 1;
            inst_num = inst_num*10+str2double(old_train.file{i}(idx(k)));
        end
        inst = inst_num;

        if(inst == splits(old_train.labels(i)) && strcmp(classes(old_train.labels(i)), class_name))
           new_test.count = new_test.count+1;
           new_test.data(:,new_test.count) = old_train.data(:,i);
           new_test.labels(new_test.count) = old_train.labels(i);
           new_test.extra(new_test.count,:) = old_train.extra(i,:);
           new_test.file(new_test.count) = old_train.file(i);

        else
           new_train.count = new_train.count+1;
           new_train.data(:,new_train.count) = old_train.data(:,i);
           new_train.labels(new_train.count) = old_train.labels(i);
           new_train.extra(new_train.count,:) = old_train.extra(i,:);
           new_train.file(new_train.count) = old_train.file(i);
        end
    end

        
    %     grayTest = test;
    %     save('new_grayTest.mat', 'grayTest', '-v7.3');
    %     grayTrain = train;
    %     save('new_grayTrain.mat', 'grayTrain', '-v7.3');
    %     


