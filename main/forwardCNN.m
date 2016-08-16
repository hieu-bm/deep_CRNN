function [train test] = forwardCNN(params)
%% init the data containers
nf = params.numFilters;
% hard code final size
fi = 13; %set based on layer size of CNN model
fj = 13;

numExtra = 3;
train = struct('data',zeros(100,nf,fi,fj),'labels',[],'count',0,'extra',zeros(100,numExtra),'file',[]);
test = struct('data',zeros(100,nf,fi,fj),'labels',[],'count',0,'extra',zeros(100,numExtra),'file',[]);

%% load the split information
load([params.dataFolder 'splits.mat'],'splits');
% testInstances specifies which instance from each class will used for testing
testInstances = splits(:,params.split);

% grab all categories in data folder
data = [params.dataFolder '/rgbd-dataset'];
categories = dir(data);
numCategories = length(categories);

catNum = 0;
for catInd = 1:numCategories
    if mod(catInd,10) == 0
        disp(['---Category: ' num2str(catInd) ' out of ' num2str(numCategories) '---']);
    end
    if isValid(categories(catInd).name)
        catNum = catNum+1;
        % grab all instances within this category
        fileCatName = [data '/' categories(catInd).name];
        instance = dir(fileCatName);
        for instInd = 1:length(instance)
            if isValid(instance(instInd).name)
                % check if a testing instance then take data
                fileInstName = [fileCatName '/' instance(instInd).name ];
                if testInstances(catNum) == str2double(instance(instInd).name(regexp(instance(instInd).name,'[0-9]')))
                    test = addInstance(fileInstName, catNum, test, params);
                else
                    train = addInstance(fileInstName, catNum, train, params);
                end
            end
        end
    end
end

train = cutData(train);
test = cutData(test);
return

function fileBool = isValid(name)
fileBool = (~strcmp(name,'.') && ~strcmp(name,'..') && ~strcmp(name,'.DS_Store'));
return;

function data = addInstance(fileInstName, catNum, data, params)

searchStr = '/*_crop.png';

% grab image names from this instance
instanceData = getValidInds(dir([fileInstName searchStr]), fileInstName);

subSampleInds = 1:5:length(instanceData);

% set the labels
data.labels = [data.labels ones(1,length(subSampleInds))*catNum];
for imgInd = subSampleInds
    data.count = data.count + 1;
    
    % read in our file from disk
    fileImgName = [fileInstName '/' instanceData(imgInd).name];
    img = imread(fileImgName);

    img = imresize(img, [224, 224]); %for KenNet
    img = single(img);
	
    startInd = max(strfind(instanceData(imgInd).name,'_'));
    
    % extract deep features
    fim = extract_AlexNet(img, params.cnnModel.net, params.layer);
    fim = permute(fim, [3, 2, 1]); %--> 256x13x13
    
    % add these features to data
    if data.count > size(data.data,1)
        data.data(end*2,end,end) = 0;
        data.extra(end*2,end) = 0;
    end
    data.data(data.count,:) = fim(:);
    
    % add for sanity check
    data.file{end+1} = instanceData(imgInd).name(1:startInd);
end
return


function data = cutData(data)
assert(length(data.labels) == data.count);
data.data = data.data(1:data.count,:,:,:);
data.extra = data.extra(1:data.count,:);
return




