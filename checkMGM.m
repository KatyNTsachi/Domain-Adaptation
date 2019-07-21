close all;
clear;
clc;

%%
% subjects = [1];
% sessions = [1];
table_to_show = [];
table_to_show = [...
                 "name"                   ,...
                 "worst precision"        ,...
                 "best precision"         ,... 
                 "pca "                   ,... 
                 "pca GMM precision"      ,... 
                 ];
             
subjects = 1:1;
sessions = 1:1;


subject  = 2;
sess = 1;
[Events, vClass]  = getERPEvents(subject, sess);


%% Original Data

Events_with_mean = addDiffrenceAverage( Events, vClass);   
Events_with_pca  = addPCAAverage( Events );   

                                                           

%%
c_data_for_classifier  = {};
c_description_for_data = {};

funcs       = { @covFromCellArrayOfEvents};
funcs_names = { "Covariance"};

tmp_description  = "subject " + num2str(subject) + "    session " + num2str(sess);

events_names    = { 
                    "original session"                   + tmp_description,...
                    "new session"                        + tmp_description,...
                   };

events_cell     = { 
                    Events                        ,...
                    Events_with_pca               ,...
                   };

%set base functions
% all_base_functions = ["linear", "gaussian", "polynomial"];
all_base_functions = ["linear"];

%extract the features
[c_data_for_classifier, c_description_for_data] = extractFeatures( events_cell, events_names,...
                                                                     funcs, funcs_names );

%% - show pca

figure();
subplot(3, 3, 4);
showPCA(c_data_for_classifier{1}, vClass);
title('PCA original');

subplot(3, 3, 5);
showPCA(c_data_for_classifier{2}, vClass);
title('PCA with mean');
%%

% t             = templateSVM('Standardize'   , false,...
%                             'KernelFunction', 'linear');
%                         
% Mdl           = fitcecoc( c_data_for_classifier{2}', ...
%                           vClass                   , ...
%                           'Learners'               , ...
%                           t);
%                       
% CMdl          = compact(Mdl);                        
% avr_loss      = crossval(CMdl)


input_data  = c_data_for_classifier{2};
input_lable = vClass;
t             = templateSVM('Standardize', false, 'KernelFunction', 'linear');
Mdl           = fitcecoc( input_data', ...
                          input_lable, ...
                          'KFold', 10, ...
                          'Learners', t);
avr_loss      = 1 - kfoldLoss(Mdl)


%%
























%%
function [mean_1] = getMean(cInput, vClass)
    %ADDAVERAGE Summary of this function goes here
    %   Detailed explanation goes here
    
    %calc mean of vClass == 1
    mat = cat(3, cInput{:});
    mean_1 = mean(mat(:, :, vClass==2 ), 3);
    
end

function [] = showTSNE(flattened_cov, vClass)

    tsne_points = tsne(flattened_cov');

    % firsst session
    class_1 = 1;
    class_2 = 2;

    scatter( tsne_points(vClass == class_1, 1), tsne_points(vClass == class_1, 2), 30, 'r', 'filled', 'MarkerEdgeColor', 'k' );
    hold on;
    scatter( tsne_points(vClass == class_2, 1), tsne_points(vClass == class_2, 2), 30, 'b', 'filled', 'MarkerEdgeColor', 'k' );
    hold on;
%     legend('not target', 'target');
    
end

function [] = showPCA(flattened_cov, vClass)

    eigen_vectors = pca(flattened_cov');
    two_components = (flattened_cov' * eigen_vectors(:, 1:2));
    % firsst session
    class_1 = 1;
    class_2 = 2;

    scatter( two_components(vClass == class_1, 1), two_components(vClass == class_1, 2), 30, 'r', 'filled', 'MarkerEdgeColor', 'k' );
    hold on;
    scatter( two_components(vClass == class_2, 1), two_components(vClass == class_2, 2), 30, 'b', 'filled', 'MarkerEdgeColor', 'k' );
    hold on;
%     legend('not target', 'target');
    
end

function [pre1, pre2] = calPrecision(X, X_test,y, y_test, data_name)
    
    t             = templateSVM('Standardize', false, 'KernelFunction', 'linear');
    Mdl           = fitcecoc( X', ...
                              y, ...
                              'Learners', t);
   
    predicted_label = predict( Mdl, X_test' );
    
    % calc precision
    tp  = sum((y_test == 2) & (predicted_label == 2));
    fp  = sum((y_test == 1) & (predicted_label == 2));
    if tp + fp ~= 0 
        pre1 = tp / (tp + fp);
    else 
        pre1 = 0;
    end
    
    %calc recal
    tn  = sum((y_test == 1) & (predicted_label == 1));
    fn  = sum((y_test == 2) & (predicted_label == 1));
    if tn + fn ~= 0 
        pre2 = tn / (tn + fn);
    else 
        pre2 = 0;
    end
    
        
end