% =========================================================================
% An example code for the algorithm proposed in
%
%   [1] Xi Peng, Bo Zhao, Rui Yan, Huajin Tang, and Zhang Yi,
%       Bag of Events: An Efficient and Online Probability-based Low-level Feature Extraction Method for AER Image Sensors,
%       IEEE Trans. on Neural Networks and Learning Systems, 2016, In Press.

% Description: 
% 1. accumulate the events into frames and then training and testing based on these frames
% 2. all the data into the cell (CINs) are partitioned into mupltiple frame
% of which consists of nEvt events
% 3. event frequence - inverse frame frequence (ef-weight) is used to reweight the
% event frequence
% only SVM can be applied to this case!

% Written by Xi Peng @ I2R A*STAR
% Sep., 2014.
% More information can be accessed from *** www.pengxi.me ***

% Each column corresponds to a data point.
% NOTICED that:
% If the codes or data sets are helpful to you, please appropriately cite our works. Thank you very much!
% =========================================================================

clear; clc; close;
addpath('../data/');
addpath('../events/');
addpath ('../usages/LinearSVM/');
addpath ('../usages/');
% process the events or not
isSkipProceeEvent = false;

dataSet = 'MNIST_DVS_28x28_10000_100ms';

nEvt    = 300;     % each frame consists of nEvt events.
tr_rate = 90;      % use tr_rate percent data set for training purpose, and use the rest for testing
nRounds = 100;     % k-fold cross validation
img_width = 28;    % the number of columns
img_hight = 28;    % the number of rows
classifier = 2;    % 2:linear SVM
% set path
dir_data = fullfile('../data/', [dataSet '_nEvt' num2str(nEvt)]);
dir_event = fullfile('../events/',dataSet);

% set path
dir_data = fullfile('../data/', [dataSet '_nEvt' num2str(nEvt)]);
dir_event = fullfile('../events/',dataSet);

% load the dataSet
if ~isSkipProceeEvent
    load(dir_event);
    data = [];
    labels = [];
    nCounts = zeros(1,length(Labels));
    tic;
    for i = 1:length(Labels)
        img = zeros(img_hight,img_width);
        nFrame = floor(size(CINs{i},1)/nEvt);
        for j = 1:length(CINs{i})
            row_pos = CINs{i}(j,4) + 1;
            col_pos = CINs{i}(j,5) + 1;
            img(row_pos,col_pos) = img(row_pos,col_pos) + 1;
            % accumulate the events into a sample
            if (j/nEvt > nFrame)
                img = zeros(img_hight,img_width);
                break;
            end
            if floor(j/nEvt) > 0 && mod(j, nEvt) == 0
                data{i}(:,floor(j/nEvt)) = reshape(img,[],1);
                img = zeros(img_hight,img_width);
                labels{i}(floor((j-1)/nEvt)+1,1) = Labels(i);
                nCounts(i) = nCounts(i) + 1;
            end
        end;
        BOE_time = toc;
    end
    save(dir_data,'data','labels','nCounts');
else
    load(dir_data);
end
clear col_pos row_pos i j CINs img Labels ii;


accuracy = zeros(1,nRounds);
tr_time = zeros(1,nRounds);
tt_time = zeros(1,nRounds);
tr_BOE_time = zeros(1,nRounds);
tt_BOE_time = zeros(1,nRounds);

for i = 1:nRounds
    tr_data = [];
    tt_data = [];
    tr_labels = [];
    tt_labels = [];
    % split the data into two parts for training and testing
    idx = randperm (length(labels));
    tr_num = round(length(labels)*tr_rate/100);
    tt_num = length(labels) - tr_num;
    tr_idx = idx(1:tr_num);
    tt_idx = idx(tr_num+1:end);
    
    for j = 1:length(tr_idx)
        tr_data = [tr_data data{tr_idx(j)}];
        tr_labels = [tr_labels reshape(labels{tr_idx(j)},1,[])];  
    end
    for j = 1:length(tt_idx)
        tt_data = [tt_data data{tt_idx(j)}];
        tt_labels = [tt_labels reshape(labels{tt_idx(j)},1,[])];  
    end
    
    % reweight the vector
    tic;
    [tr_data, weight] = BOE(tr_data);
    tr_BOE_time(i) = toc + BOE_time;
    
    tic;
    tt_data = ef( tt_data ) .* repmat( weight, 1, size(tt_data,2) );
    tt_BOE_time(i) = toc + BOE_time;
    % Perform classification
    tic;
    SVMModel = train(tr_labels',sparse(tr_data'));
    tr_time(i) = toc;
    
    tic;
    [cpre] = predict(tt_labels', sparse(tt_data'), SVMModel);
    tt_time(i) = toc;

    accuracy(i) = sum(cpre==tt_labels')/length(cpre);
    fprintf('The recognition rate is about %f for the %dth test！\n', accuracy(i), i);
    fprintf('The training time cost is %fsec and the testing time is %fsec\n', tr_time(i), tt_time(i));
end;
clc;
fprintf('\n=========================================================\n');
fprintf('The mean recognition rate is about %f and the std is about %f\n', mean(accuracy), std(accuracy));
fprintf('The mean training time for feature extraction is about %f and the std is about %f\n', mean(tr_BOE_time), std(tr_BOE_time));
fprintf('The mean testing time for feature extraction is about %f and the std is about %f\n', mean(tt_BOE_time), std(tt_BOE_time));

fprintf('The mean training time for classification is about %f and the std is about %f\n', mean(tr_time), std(tr_time));
fprintf('The mean testing time for classification is about %f and the std is about %f\n', mean(tt_time), std(tt_time));


clear i idx j NBModel tr_data tr_idx tt_data tt_idx tr_labels tt_labels;
clear labels nCounts cpre data weight SVMModel;
save(['BOE_' dataSet '_nEvt' num2str(nEvt) '_trn' num2str(tr_rate) '_nRnd' num2str(nRounds)]);

