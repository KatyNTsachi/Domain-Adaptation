close all
clear
addpath("./functions/")

%% --prepare for calc 
clc

vClass = [];
Events = {};
for day = 1:num_days
    for subject = 1:num_subjects
        [tmp_Events, tmp_vClass]  = GetEvents( subject, day );
        Events = combineTwoCellArrays(Events,tmp_Events);
        vClass = [vClass; tmp_vClass];
    end
end

%% --Devide to test training and            
m_data   = cell2mat(Events);
v_lables = kron(vClass, ones(22,1));
max_diff = 10;
while true
    b_training   = rand( size(v_lables,1),1 ) > 0.3;
    b_test       = ~b_training;

    %--test our division
    class_one   = sum(v_lables(b_training)==1);
    class_two   = sum(v_lables(b_training)==2);
    class_three = sum(v_lables(b_training)==3);
    class_four  = sum(v_lables(b_training)==4);
    avg = (class_one + class_two + class_three + class_four)/4;
    if abs(class_one - avg)< max_diff && abs(class_two - avg)< max_diff && abs(class_three - avg)< max_diff && abs(class_four - avg)< max_diff
        break;
    end
end

m_train_data  = m_data(:,b_training);
v_train_lable = v_lables(b_training);
m_test_data   = m_data(:,b_test);
v_test_lable  = v_lables(b_test);

%-- shaffel data
test_perm  = randperm(length(v_test_lable));
train_perm = randperm(length(v_train_lable));
%val_perm   = randperm(length(v_val_lable));

m_train_data  = m_train_data(:,train_perm);
v_train_lable = v_train_lable(train_perm);
m_test_data   = m_test_data(:,test_perm);
v_test_lable  = v_test_lable(test_perm);
%m_val_data   = m_test_data(:,test_perm);
%v_val_lable  = v_test_lable(test_perm);

%% cut hte data

m_train_data  = m_train_data(:,1:500);
v_train_lable = v_train_lable(1:500);
m_val_data    = m_train_data
v_val_lable   = v_train_lable


%% define network structure

layers = [
    
    imageInputLayer([int32(size(m_train_data,1)), int32(1)])
    %-- layer 1
    convolution2dLayer([3 1], 4,'Padding','same')
    batchNormalizationLayer
    reluLayer
    maxPooling2dLayer([2 1],'Stride',2)
    
    %-- layer 2
    convolution2dLayer([3 1], 8,'Padding','same')
    batchNormalizationLayer
    reluLayer
    maxPooling2dLayer([2 1],'Stride',2)
    
    
    %-- layer 3
    convolution2dLayer([3 1], 16,'Padding','same')
    batchNormalizationLayer
    reluLayer
    maxPooling2dLayer([2 1],'Stride',2)
    
    %-- layer 4
    convolution2dLayer([3 1], 32,'Padding','same')
    batchNormalizationLayer
    reluLayer
    maxPooling2dLayer([2 1],'Stride',2)
    
    %-- layer 5
    convolution2dLayer([3 1], 64,'Padding','same')
    batchNormalizationLayer
    reluLayer
    maxPooling2dLayer([2 1],'Stride',2)
    
    %-- layer 6
    convolution2dLayer([3 1], 128,'Padding','same')
    batchNormalizationLayer
    reluLayer
       
    %-- fully connected
    fullyConnectedLayer(4)
    softmaxLayer
    classificationLayer];
    
%% training options

v_train_lable_categorical = discretize(v_train_lable,[0.5 1.5 2.5 3.5 4.5],...
                                       'categorical', {'1' '2' '3' '4'});
tmp_m_train_data = reshape(m_train_data,[750,1,1,500]);     

options = trainingOptions('sgdm', ...
    'InitialLearnRate',0.01, ...
    'MaxEpochs',100, ...
    'Shuffle','every-epoch', ...
    'ValidationData',{tmp_m_train_data, v_train_lable_categorical}, ...
    'ValidationFrequency',30, ...
    'Verbose',false, ...
    'Plots','training-progress');

%% train 

%c_train_data = mat2cell(m_train_data,[750],ones(500,1));
net = trainNetwork( tmp_m_train_data, v_train_lable_categorical, layers, options );

%% test accuracy

YPred       = classify(net,tmp_m_train_data);
YValidation = v_train_lable_categorical;

accuracy = sum(YPred == YValidation)/numel(YValidation)


