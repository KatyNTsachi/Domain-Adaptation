close all;
clear;
clc;

%%
% subjects = [1];
% sessions = [1];
table_to_show = [];


table_to_show = [...
                 "subject1"                         ,...
                 "session1"                         ,...
                 "subject2"                         ,...
                 "session2"                         ,...
                 "original"                         ,...
                 "with real mean"                   ,...
                 "with train mean"                  ,...
                 "with PCA"                         ,...
                 "with seperate PCA"                ,...
                 ];
             
for subject1 = 1
    for sess1 = 1:8
        for subject2 = 1:24
            for sess2 = 1:8
                
                if subject2 > 7 & sess2 > 1 
                    continue;
                end
                
                if subject1 == subject2 & sess1 == sess2
                    continue
                end
                
                %% get events 1 
                epsilon = 0.01;
                max_iter = 100;

                [Events1, vClass1]  = getERPEvents(subject1, sess1);
                cov1 = covFromCellArrayOfEvents(Events1);
                mean_of_cov1 = riemannianMean(cov1, epsilon, max_iter);


                %% get events 2
                [Events2, vClass2]  = getERPEvents(subject2, sess2);
                cov2 = covFromCellArrayOfEvents(Events2);
                mean_of_cov2 = riemannianMean(cov2, epsilon, max_iter);

                %% transorm events 1 to events 2
%                 T = ( mean_of_cov2 * ( (mean_of_cov1)^(-1) ) ) ^ (1 / 2);
%                 Events1_transformed = {};
%                 for ii = 1 : length(Events1)
%                     Events1_transformed{ii} = (T * Events1{ii}')';
%                 end
% 
%                 cov_transformed = covFromCellArrayOfEvents(Events1_transformed);

                
                
                
                %% add extra chanels
                Events1_with_mean                 = addAverageSub(Events1, vClass1);               
                Events2_with_mean                 = addAverageSub(Events2, vClass2);

                                                                                
                [~,Events2_with_oter_mean]        = addDiffrenceAverageOldDataTest( Events1,...
                                                                                    Events2            ,...
                                                                                    vClass1);
                                                                                
                
                Events1_with_pca_1                = addPCAAverage(Events1);
                Events2_with_pca_2                = addPCAAverage(Events2);
                
                [Events1_with_pca,... 
                 Events2_with_pca]                = addPCAAverageTest(Events1, Events2);


                %%
                c_data_for_classifier  = {};
                c_description_for_data = {};

                funcs       = { @covFromCellArrayOfEvents};
                funcs_names = { "Covariance"};

                tmp_description  = "subject " + num2str(subject1) + "    session " + num2str(sess1);

                events_names    = { 
                                    "Events1"                        + tmp_description,...
                                    "Events2"                        + tmp_description,...
                                    "Events1 with mean"              + tmp_description,...
                                    "Events2 with mean"              + tmp_description,...                                   
                                    "Events2 with other mean"        + tmp_description,...
                                    "Events1 with pca"               + tmp_description,...
                                    "Events2 with pca "              + tmp_description,...
                                    "Events1 with pca_1"             + tmp_description,...
                                    "Events2 with pca_2"             + tmp_description,...
                                   };
               
                events_cell     = { 
                                    Events1                     ,...
                                    Events2                     ,...
                                    Events1_with_mean           ,...
                                    Events2_with_mean           ,...
                                    Events2_with_oter_mean      ,...                                    
                                    Events1_with_pca            ,...                                    
                                    Events2_with_pca            ,...
                                    Events1_with_pca_1          ,...
                                    Events2_with_pca_2          ,...
                                   };


                %set base functions
                % all_base_functions = ["linear", "gaussian", "polynomial"];
                all_base_functions = ["linear"];

                %extract the features
                [c_data_for_classifier, c_description_for_data] = extractFeatures( events_cell, events_names,...
                                                                                     funcs, funcs_names );



                %%


                NUM_OF_RES = 5;
                precision = zeros(NUM_OF_RES, 1);
                tmp_idx = 1;
                [pre1, ~] = calPrecision(...
                                                    c_data_for_classifier{1},...
                                                    c_data_for_classifier{2},...
                                                    vClass1                 ,...
                                                    vClass2                  ...
                                                 );
                precision(tmp_idx) = precision(tmp_idx) + pre1;
                tmp_idx = tmp_idx + 1;

                [pre1, ~] = calPrecision(...
                                                    c_data_for_classifier{3},...
                                                    c_data_for_classifier{4},...
                                                    vClass1                 ,...
                                                    vClass2                  ...
                                                 );
                precision(tmp_idx) = precision(tmp_idx) + pre1;
                tmp_idx = tmp_idx + 1;


                [pre1, ~] = calPrecision(  ...
                                                c_data_for_classifier{3},...
                                                c_data_for_classifier{5},...
                                                vClass1                 ,...
                                                vClass2                  ...
                                               );
                precision(tmp_idx) = precision(tmp_idx) + pre1;
                tmp_idx = tmp_idx + 1;

             
                [pre1, ~] = calPrecision(  ...
                                                c_data_for_classifier{6},...
                                                c_data_for_classifier{7},...
                                                vClass1                 ,...
                                                vClass2                  ...
                                               );
                precision(tmp_idx) = precision(tmp_idx) + pre1;
                tmp_idx = tmp_idx + 1;


                [pre1, ~] = calPrecision(  ...
                                                c_data_for_classifier{8},...
                                                c_data_for_classifier{9},...
                                                vClass1                 ,...
                                                vClass2                  ...
                                               );
                precision(tmp_idx) = precision(tmp_idx) + pre1;
                tmp_idx = tmp_idx + 1;

                
                
               
convertCharsToStrings(num2str(subject1))

                table_to_show = [table_to_show ; 
                                                [convertCharsToStrings(num2str(subject1))      ,...
                                                 convertCharsToStrings(num2str(sess1))         ,...
                                                 convertCharsToStrings(num2str(subject2))      ,...
                                                 convertCharsToStrings(num2str(sess2))         ,...
                                                 convertCharsToStrings(num2str( precision(1) )),...
                                                 convertCharsToStrings(num2str( precision(2) )),...
                                                 convertCharsToStrings(num2str( precision(3) )),...
                                                 convertCharsToStrings(num2str( precision(4) )),...
                                                 convertCharsToStrings(num2str( precision(5) ))]
                                ];
                disp(table_to_show); 

            end 
        end
    end
end

save no_tranfer_subject_1 table_to_show;










































%%
function [mean_1] = getMean(cInput, vClass)
    %ADDAVERAGE Summary of this function goes here
    %   Detailed explanation goes here
    
    %calc mean of vClass == 1
    mat = cat(3, cInput{:});
    mean_1 = mean(mat(:, :, vClass==2 ), 3);
    
end

function [] = showTSNElocal(flattened_cov, vClass)

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

