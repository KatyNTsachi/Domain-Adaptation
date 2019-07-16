close all;
clear;
clc;
%%
subject = 1;
sess = 1:8;

figure()
for ii = sess
    [Events, vClass]  = getERPEvents(subject, ii);
    mean = getMean(Events, vClass);
    subplot(length(sess), 1, ii);
    plot(mean);
end
%works very well
% [Events1, vClass1]  = getERPEvents(subject, 5);
% [Events2, vClass2]  = getERPEvents(subject, 6);

[Events1, vClass1]  = getERPEvents(subject, 1);

%%
subjects = 2:8;
for subject = subjects 

%     figure()
%     for ii = sess
%         [Events, vClass]  = getERPEvents(subject, ii);
%         mean = getMean(Events, vClass);
%         subplot(length(sess), 1, ii);
%         plot(mean);
%     end
    %works very well
    % [Events1, vClass1]  = getERPEvents(subject, 5);
    % [Events2, vClass2]  = getERPEvents(subject, 6);

    [Events2, vClass2]  = getERPEvents(subject, 1);
    %%


    mean1 = getMean(Events1, vClass1);
    mean2 = getMean(Events2, vClass2);
    figure();
    subplot(2, 1, 1);
    plot(mean1);
    subplot(2, 1, 2);
    plot(mean2);

    %% TSNE

%     Events = {Events1{:}, Events2{:}};
%     vClass = [vClass1 ; vClass2 + 2];
% 
%     t_events = cat(3, Events{:});
% 
%     t_cov = nan( size(t_events, 2), size(t_events, 2), size(t_events, 3));
%     for ii = 1 : size(t_events , 3)
%         t_cov(:, :, ii)  =  cov( t_events(:, :, ii) );
%     end
% 
%     flattened_cov = symetric2Vec(t_cov);
% 
%     tsne_points = tsne(flattened_cov');
% 
%     % firsst session
%     class_1 = 1;
%     class_2 = 2;
%     % seconed session
%     class_3 = 3;
%     class_4 = 4;
% 
%     % green and blue first class, yellow and red seconed class
%     % green and yelow first session, blue and red seconed session
%     figure();
%     scatter( tsne_points(vClass == class_1, 1), tsne_points(vClass == class_1, 2), 30, 'g', 'filled', 'MarkerEdgeColor', 'k' );
%     hold on;
%     scatter( tsne_points(vClass == class_2, 1), tsne_points(vClass == class_2, 2), 30, 'y', 'filled', 'MarkerEdgeColor', 'k' );
%     hold on;
%     scatter( tsne_points(vClass == class_3, 1), tsne_points(vClass == class_3, 2), 30, 'b', 'filled', 'MarkerEdgeColor', 'k' );
%     hold on;
%     scatter( tsne_points(vClass == class_4, 1), tsne_points(vClass == class_4, 2), 30, 'r', 'filled', 'MarkerEdgeColor', 'k' );
%     legend('session 1 not target', 'session 1 target', 'session 2 not target', 'session 2 target')
    %%

    Events1_with_mean            = addAverageSub(Events1, vClass1);               
    [~, Events2_with_train_mean] = addDiffrenceAverageOldDataTest(Events1, Events2, vClass1);
    Events2_with_mean            = addAverageSub(Events2, vClass2);
    
    [Events1_with_pca, ~]        = addPCAAverageOldDataTestTwoOptions(  Events1,...
                                                                        vClass1);   
    
    [Events1_with_pca_GMM, ~]    = addPCAGMMAverageOldDataTestTwoOptions( Events1,...
                                                                          vClass1);   
                         
    [Events2_with_pca_option1,...
     Events2_with_pca_option2] = addPCAAverageOldDataTestTwoOptions(  Events2,...
                                                                      vClass2);   
    
    [Events2_with_pca_GMM_option1,...
     Events2_with_pca_GMM_option2] = addPCAGMMAverageOldDataTestTwoOptions( Events2,...
                                                                            vClass2);   
                                                            

    %%
    c_data_for_classifier  = {};
    c_description_for_data = {};

    funcs       = { @covFromCellArrayOfEvents};
    funcs_names = { "Covariance"};

    tmp_description  = "subject " + num2str(subject) + "    session " + num2str(sess);

    events_names    = { 
                        "session 1 with mean"             + tmp_description,...
                        "session 2 with train mean"       + tmp_description,... 
                        "session 2 with mean"             + tmp_description,... 
                        "session 1 with pca"              + tmp_description,... 
                        "session 1 with PCA GMM"          + tmp_description,... 
                        "session 2 with pca option 1"     + tmp_description,... 
                        "session 2 with PCA GMM option 1" + tmp_description,... 
                        "session 2 with pca option 2"     + tmp_description,... 
                        "session 2 with PCA GMM option 2" + tmp_description,... 

                       };

    events_cell     = { 
                        Events1_with_mean             ,...
                        Events2_with_train_mean       ,...
                        Events2_with_mean             ,...
                        Events1_with_pca              ,...
                        Events1_with_pca_GMM          ,...
                        Events2_with_pca_option1      ,...
                        Events2_with_pca_GMM_option1  ,...     
                        Events2_with_pca_option2      ,...
                        Events2_with_pca_GMM_option2  ,...                                      
                       };

    %set base functions
    % all_base_functions = ["linear", "gaussian", "polynomial"];
    all_base_functions = ["linear"];

    %extract the features
    [c_data_for_classifier, c_description_for_data] = extractFeatures( events_cell, events_names,...
                                                                         funcs, funcs_names, vClass );

    %%

    [persicion_worst, recall_worst] = calPrecision(...
                                                c_data_for_classifier{1},...
                                                c_data_for_classifier{2},...
                                                vClass1                 ,...
                                                vClass2                  ...
                                            );
    disp( "persicion_worst :             " + num2str(persicion_worst));
    disp( "    recall_worst:               " + num2str(recall_worst) );

    [persicion_best, recall_best] = calPrecision(  ...
                                    c_data_for_classifier{1},...
                                    c_data_for_classifier{3},...
                                    vClass1                 ,...
                                    vClass2                  ...
                                   );
    disp( "persicion_best :             " + num2str(persicion_best));
    disp( "    recall_best:               " + num2str(recall_best) );

    
    [persicion_pca1, recall_pca1] = calPrecision(...
                                                c_data_for_classifier{4},...
                                                c_data_for_classifier{6},...
                                                vClass1                 ,...
                                                vClass2                  ...
                                               );
                                       
    disp( "persicion_pca1 :             " + num2str(persicion_pca1));
    disp( "    recall_pca1:               " + num2str(recall_pca1) );
                                       
    [persicion_pca2, recall_pca2] = calPrecision(...
                                                c_data_for_classifier{4},...
                                                c_data_for_classifier{8},...
                                                vClass1                 ,...
                                                vClass2                  ...
                                               );
    disp( "persicion_pca2 :             " + num2str(persicion_pca2));
    disp( "    recall_pca2:               " + num2str(recall_pca2) );

    [persicion_pca_GMM1, recall_pca_GMM1] = calPrecision(...
                                                c_data_for_classifier{5},...
                                                c_data_for_classifier{7},...
                                                vClass1                 ,...
                                                vClass2                  ...
                                               );
    
    disp( "persicion_pca_GMM1 :         " + num2str(persicion_pca_GMM1));
    disp( "    recall_pca_GMM1:           " + num2str(recall_pca_GMM1) );
                                       
    [persicion_pca_GMM2, recall_pca_GMM2] = calPrecision(...
                                                c_data_for_classifier{5},...
                                                c_data_for_classifier{9},...
                                                vClass1                 ,...
                                                vClass2                  ...
                                               );

    disp( "persicion_pca_GMM2 :         " + num2str(persicion_pca_GMM2));
    disp( "    recall_pca_GMM2:           " + num2str(recall_pca_GMM2) );

                                           
    [persicion_pca_real_mean1, recall_pca_real_mean1] = calPrecision(...
                                                c_data_for_classifier{1},...
                                                c_data_for_classifier{6},...
                                                vClass1                 ,...
                                                vClass2                  ...
                                               );
    disp( "persicion_pca_real_mean1 :   " + num2str(persicion_pca_real_mean1));
    disp( "    recall_pca_real_mean1:     " + num2str(recall_pca_real_mean1) );

    [persicion_pca_real_mean2, recall_pca_real_mean2] = calPrecision(...
                                                c_data_for_classifier{1},...
                                                c_data_for_classifier{8},...
                                                vClass1                 ,...
                                                vClass2                  ...
                                               );
                                           
    disp( "persicion_pca_real_mean2 :   " + num2str(persicion_pca_real_mean2));
    disp( "    recall_pca_real_mean2:     " + num2str(recall_pca_real_mean2) );
    
                                           
                                           
    [persicion_pca_GMM_real_mean1, recall_pca_GMM_real_mean1] = calPrecision(...
                                                c_data_for_classifier{1},...
                                                c_data_for_classifier{7},...
                                                vClass1                 ,...
                                                vClass2                  ...
                                               );
    
    disp( "persicion_pca_GMM_real_mean1:" + num2str(persicion_pca_GMM_real_mean1));
    disp( "    recall_pca_GMM_real_mean1: " + num2str(recall_pca_GMM_real_mean1) );
    
                                       
    [persicion_pca_GMM_real_mean2, recall_pca_GMM_real_mean2] = calPrecision(...
                                                c_data_for_classifier{1},...
                                                c_data_for_classifier{9},...
                                                vClass1                 ,...
                                                vClass2                  ...
                                               );                                    
    disp( "persicion_pca_GMM_real_mean2:" + num2str(persicion_pca_GMM_real_mean2));
    disp( "    recall_pca_GMM_real_mean2: " + num2str(recall_pca_GMM_real_mean2) );


    disp( "########################################################");
end
       
                    
%%
function [mean_1] = getMean(cInput, vClass)
    %ADDAVERAGE Summary of this function goes here
    %   Detailed explanation goes here
    
    %calc mean of vClass == 1
    mat = cat(3, cInput{:});
    mean_1 = mean(mat(:, :, vClass==1 ), 3);
    
end





function [pre, rec] = calPrecision(X, X_test,y, y_test)
    
    t             = templateSVM('Standardize', false, 'KernelFunction', 'linear');
    Mdl           = fitcecoc( X', ...
                              y, ...
                              'Learners', t);
   
    predicted_label = predict( Mdl, X_test' );
    
    % calc precision
    tp  = sum((y_test == 2) & (predicted_label == 2));
    fp  = sum((y_test == 1) & (predicted_label == 2));
    if tp + fp ~= 0 
        pre = tp / (tp + fp);
    else 
        pre = 0;
    end
    
    %calc recal
    tn  = sum((y_test == 1) & (predicted_label == 1));
    fn  = sum((y_test == 2) & (predicted_label == 1));
    if tn + fn ~= 0 
        rec = tn / (tn + fn);
    else 
        rec = 0;
    end
    
end