close all
clear
addpath("./functions/")

%% --prepare for calc 
clc
num_days     = 2;
num_subjects = 9;
vClass = [];
Events = {};

for subject = 1:num_subjects
    for day = 1:num_days
        [tmp_Events, tmp_vClass]  = GetEvents( subject, day );
        Events = combineTwoCellArrays(Events,tmp_Events);
        vClass = [vClass; tmp_vClass];
    end
end

%% --Devide to test training and            
m_data   = cell2mat(Events);
v_lables = kron(vClass, ones(22,1));

start_of_train = 1;
end_of_train   = int32(size(v_lables,1) * 0.7);
start_of_val   = end_of_train + 1 ;
end_of_val     = int32(size(v_lables,1) * 0.8);
start_of_test  = end_of_val + 1;
end_of_test    = size(v_lables,1);



m_train_data  = m_data(:,start_of_train:end_of_train);
v_train_lable = v_lables(start_of_train:end_of_train);

m_val_data    = m_data(:,start_of_val:end_of_val);
v_val_lable   = v_lables(start_of_val:end_of_val);

m_test_data   = m_data(:,start_of_test:end_of_test);
v_test_lable  = v_lables(start_of_test:end_of_test);

%-- shuffel data
train_perm = randperm(length(v_train_lable));
val_perm   = randperm(length(v_val_lable));
test_perm  = randperm(length(v_test_lable));

%--change the order
m_train_data  = m_train_data(:,train_perm);
v_train_lable = v_train_lable(train_perm);

m_val_data   = m_val_data(:,val_perm);
v_val_lable  = v_val_lable(val_perm);

m_test_data   = m_test_data(:,test_perm);
v_test_lable  = v_test_lable(test_perm);


%% cut the data

% m_train_data  = m_train_data(:,1:500);
% v_train_lable = v_train_lable(1:500);
% m_val_data  = m_train_data;
% v_val_lable = v_train_lable;



%% set the data to network
v_train_lable_categorical = discretize(v_train_lable,[0.5 1.5 2.5 3.5 4.5],...
                                       'categorical', {'1' '2' '3' '4'});
tmp_m_train_data           = reshape(m_train_data,750,1,1,[]);     



v_val_lable_categorical = discretize(v_val_lable,[0.5 1.5 2.5 3.5 4.5],...
                                       'categorical', {'1' '2' '3' '4'});
tmp_m_val_data          = reshape(m_val_data,750,1,1,[]);     



v_test_lable_categorical = discretize(v_test_lable,[0.5 1.5 2.5 3.5 4.5],...
                                       'categorical', {'1' '2' '3' '4'});
tmp_m_test_data          = reshape(m_test_data,750,1,1,[]);     



%% define network structure

% layers = [
%     
%     imageInputLayer([int32(size(m_train_data,1)), int32(1)])
%     %-- layer 1
%     convolution2dLayer([3 1], 4,'Padding','same')
%     batchNormalizationLayer
%     reluLayer
%     dropoutLayer
%     maxPooling2dLayer([2 1],'Stride',2)
%     
%     %-- layer 2
%     convolution2dLayer([3 1], 8,'Padding','same')
%     batchNormalizationLayer
%     reluLayer
%     dropoutLayer
%     maxPooling2dLayer([2 1],'Stride',2)
%     
%     
%     %-- layer 3
%     convolution2dLayer([3 1], 16,'Padding','same')
%     batchNormalizationLayer
%     reluLayer
%     dropoutLayer
%     maxPooling2dLayer([2 1],'Stride',2)
%     
%     %-- layer 4
%     convolution2dLayer([3 1], 32,'Padding','same')
%     batchNormalizationLayer
%     reluLayer
%     dropoutLayer
%     maxPooling2dLayer([2 1],'Stride',2)
%     
%     %-- layer 5
%     convolution2dLayer([3 1], 64,'Padding','same')
%     batchNormalizationLayer
%     reluLayer
%     dropoutLayer
%     maxPooling2dLayer([2 1],'Stride',2)
%     
%     %-- layer 6
%     convolution2dLayer([3 1], 128,'Padding','same')
%     batchNormalizationLayer
%     reluLayer
%     
%     
%     %-- fully connected
%     fullyConnectedLayer(4)
%     softmaxLayer
%     classificationLayer];




layers = [
    
    imageInputLayer([int32(size(m_train_data,1)), int32(1)])
    %-- layer 1
    convolution2dLayer([60 1], 80,'Padding','same')
    batchNormalizationLayer
    reluLayer
    maxPooling2dLayer([4 1],'Stride',1)
    dropoutLayer
    
    %-- layer 2
    convolution2dLayer([1 1], 80,'Padding','same')
    batchNormalizationLayer
    reluLayer
    maxPooling2dLayer([2 1],'Stride',2)
    

    
    %-- fully connected
    fullyConnectedLayer(5000)
    dropoutLayer
    fullyConnectedLayer(5000)
    dropoutLayer
    
    
    %--output
    fullyConnectedLayer(4)    
    softmaxLayer
    
    classificationLayer];


    







%% training options


options = trainingOptions(  'sgdm', ...
                            'InitialLearnRate',0.01, ...
                            'MaxEpochs',300, ...
                            'Shuffle','every-epoch', ...
                            'ValidationData',{tmp_m_val_data, v_val_lable_categorical}, ...
                            'ValidationFrequency',30, ...
                            'Verbose',false, ...
                            'Plots','training-progress');

%% train 

net = trainNetwork( tmp_m_train_data, v_train_lable_categorical, layers, options );

%% test accuracy
YPred       = classify(net,tmp_m_test_data);
YValidation = v_test_lable_categorical;

test_accuracy = sum(YPred == YValidation)/numel(YValidation)
%% accuracy on val
YPred       = classify(net, tmp_m_val_data);
YValidation = v_val_lable_categorical;

val_accuracy = sum(YPred == YValidation)/numel(YValidation)
%% accuracy on train
YPred       = classify(net, tmp_m_train_data);
YValidation = v_train_lable_categorical;

train_accuracy = sum(YPred == YValidation)/numel(YValidation)