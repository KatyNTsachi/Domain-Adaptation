close all;
clear;
clc;

%%
% subjects = [1];
% sessions = [1];
table_to_show = [];

% 1,2  - worst
% 5,6  - best
% 5,3  - suppose to be good 
% 11,4 - other mean
% 5,8  - mean vs pca
% 7,8  - pca vs pca
% 5,10 - mean vs our pca
% 9,10 - our pca vs our pca

table_to_show = [...
                 "name"                  ,...
                 "worst"                 ,...
                 "best"                  ,... 
                 "suppose to be good "   ,... 
                 "other mean "           ,... 
                 "mean vs pca "          ,... 
                 "pca vs pca "           ,... 
                 "mean vs our pca "      ,... 
                 "our pca vs our pca "   ,... 
                 ];
for subject1 = 1:7
    for sess1 = 1:2
        for subject2 = 1:7
            for sess2 = 1:2
                
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
                T = ( mean_of_cov2 * ( (mean_of_cov1)^(-1) ) ) ^ (1 / 2);
                Events1_transformed = {};
                for ii = 1 : length(Events1)
                    Events1_transformed{ii} = (T * Events1{ii}')';
                end

                cov_transformed = covFromCellArrayOfEvents(Events1_transformed);


%                 %% sanity check - show data before and after transformation
%                 % before
%                 tmp_cov = cat(3, cov1, cov2);
%                 flattened_cov = prepareForClassification(tmp_cov);
%                 tsne_points = tsne(flattened_cov');
%                 vClass_one = zeros(size(flattened_cov, 2), 1);
%                 vClass_one(1:size(cov1,3)) = 1;
%                 class_1 = 1;
%                 class_2 = 2;
% 
%                 figure();
%                 scatter( tsne_points(vClass_one == 1, 1), tsne_points(vClass_one == 1, 2), 30, 'r', 'filled', 'MarkerEdgeColor', 'k' );
%                 hold on;
%                 scatter( tsne_points(vClass_one ~= 1, 1), tsne_points(vClass_one ~= 1, 2), 30, 'b', 'filled', 'MarkerEdgeColor', 'k' );
% 
%                 %after
%                 tmp_cov = cat(3, cov_transformed, cov2);
%                 flattened_cov = prepareForClassification(tmp_cov);
%                 tsne_points = tsne(flattened_cov');
%                 vClass_one = zeros(size(flattened_cov, 2), 1);
%                 vClass_one(1:size(cov2,3)) = 1;
%                 class_1 = 1;
%                 class_2 = 2;
% 
%                 figure();
%                 scatter( tsne_points(vClass_one == 1, 1), tsne_points(vClass_one == 1, 2), 30, 'r', 'filled', 'MarkerEdgeColor', 'k' );
%                 hold on;
%                 scatter( tsne_points(vClass_one ~= 1, 1), tsne_points(vClass_one ~= 1, 2), 30, 'b', 'filled', 'MarkerEdgeColor', 'k' );
% 




                %% -see average of target

%                 figure();
%                 subplot(3, 1, 1);
%                 plot( getMean(Events1            , vClass1) );
%                 title('mean of events1 data');
%                 subplot(3, 1, 2);
%                 plot( getMean(Events2            , vClass2) );
%                 title('mean of events2 data');
%                 subplot(3, 1, 3);
%                 plot( getMean(Events1_transformed, vClass1) );
%                 title('mean of events1 on events 2 damain');


                %% Original Data
                
                %V 1,2 - worst                Events1_transformed,   Events2
                %V 4,5 - best                 TEvents1_with_mean ,   Events2_with_mean
                %V 4,3 - suppose to be good   TEvents1_with_mean,    Events2_with_transformed_mean
                % 4,7 - mean vs pca          TEvents1_with_mean,    Events2_with_pca
                % 6,7 - pca vs pca           TEvents1_with_pca,     Events2_with_pca
                % 4,9 - mean vs pca          TEvents1_with_mean,    Events2_with_our_pca
                % 8,9 - pca vs pca           TEvents1_with_our_pca, Events2_with_our_pca

                Events1_with_mean                = addAverageSub(Events1, vClass1); 
                TEvents1_with_mean                = addAverageSub(Events1_transformed, vClass1);               
                Events2_with_mean                 = addAverageSub(Events2            , vClass2);

                [~,Events2_with_transformed_mean] = addDiffrenceAverageOldDataTest( Events1_transformed,...
                                                                                    Events2            ,...
                                                                                    vClass1);
                                                                                
                [~,Events2_with_oter_mean]        = addDiffrenceAverageOldDataTest( Events1,...
                                                                                    Events2            ,...
                                                                                    vClass1);
                                                                                
                [TEvents1_with_pca,... 
                 Events2_with_pca]                = addPCAAverageTest(Events1_transformed, Events2);   

                [TEvents1_with_our_pca, ~]        = addPCAAverageOldDataTest(Events1_transformed, [], vClass1);   
                [Events2_with_our_pca, ~]         = addPCAAverageOldDataTest(Events2, [], vClass2);   


                %%
                c_data_for_classifier  = {};
                c_description_for_data = {};

                funcs       = { @covFromCellArrayOfEvents};
                funcs_names = { "Covariance"};

                tmp_description  = "subject " + num2str(subject1) + "    session " + num2str(sess1);

                events_names    = { 
                                    "transformed"                        + tmp_description,...
                                    "new session"                        + tmp_description,...
                                    "new session transformed mean"       + tmp_description,...
                                    "new session other mean"             + tmp_description,...
                                    "transformed session with mean"      + tmp_description,...                                   
                                    "new session with real mean"         + tmp_description,...
                                    "transformed session PCA"            + tmp_description,...
                                    "new session PCA "                   + tmp_description,...
                                    "transformed session our PCA"        + tmp_description,...
                                    "new session our PCA "               + tmp_description,...
                                    "original with mean"                 + tmp_description,...
                                   };

                events_cell     = { 
                                    Events1_transformed           ,...
                                    Events2                       ,...
                                    Events2_with_transformed_mean ,...
                                    Events2_with_oter_mean        ,...
                                    TEvents1_with_mean            ,...
                                    Events2_with_mean             ,...
                                    TEvents1_with_pca             ,... 
                                    Events2_with_pca              ,...
                                    TEvents1_with_our_pca         ,...
                                    Events2_with_our_pca          ,...
                                    Events1_with_mean              ,...
                                   };


                %set base functions
                % all_base_functions = ["linear", "gaussian", "polynomial"];
                all_base_functions = ["linear"];

                %extract the features
                [c_data_for_classifier, c_description_for_data] = extractFeatures( events_cell, events_names,...
                                                                                     funcs, funcs_names );

                %% - show TSNE
%                 figure();
%                 subplot(3, 3, 1);
%                 showTSNElocal(c_data_for_classifier{2}, vClass1);
%                 title('TSNE original');
% 
%                 subplot(3, 3, 2);
%                 showTSNElocal(c_data_for_classifier{4}, vClass1);
%                 title('TSNE with mean');




                %%

                % 1,2  - worst
                % 5,6  - best
                % 5,3  - suppose to be good 
                % 11,4 - other mean
                % 5,8  - mean vs pca
                % 7,8  - pca vs pca
                % 5,10 - mean vs our pca
                % 9,10 - our pca vs our pca


                NUM_OF_RES = 8;
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
                                                    c_data_for_classifier{5},...
                                                    c_data_for_classifier{6},...
                                                    vClass1                 ,...
                                                    vClass2                  ...
                                                 );
                precision(tmp_idx) = precision(tmp_idx) + pre1;
                tmp_idx = tmp_idx + 1;


                [pre1, ~] = calPrecision(  ...
                                                c_data_for_classifier{5},...
                                                c_data_for_classifier{3},...
                                                vClass1                 ,...
                                                vClass2                  ...
                                               );
                precision(tmp_idx) = precision(tmp_idx) + pre1;
                tmp_idx = tmp_idx + 1;

             
                [pre1, ~] = calPrecision(  ...
                                                c_data_for_classifier{11},...
                                                c_data_for_classifier{4},...
                                                vClass1                 ,...
                                                vClass2                  ...
                                               );
                precision(tmp_idx) = precision(tmp_idx) + pre1;
                tmp_idx = tmp_idx + 1;


                
                
                
                [pre1, ~] = calPrecision(  ...
                                                c_data_for_classifier{5},...
                                                c_data_for_classifier{8},...
                                                vClass1                 ,...
                                                vClass2                  ...
                                               );
                precision(tmp_idx) = precision(tmp_idx) + pre1;
                tmp_idx = tmp_idx + 1;


                [pre1, ~] = calPrecision(  ...
                                                c_data_for_classifier{7},...
                                                c_data_for_classifier{8},...
                                                vClass1                 ,...
                                                vClass2                  ...
                                               );
                precision(tmp_idx) = precision(tmp_idx) + pre1;
                tmp_idx = tmp_idx + 1;

                [pre1, ~] = calPrecision(  ...
                                                c_data_for_classifier{5},...
                                                c_data_for_classifier{10},...
                                                vClass1                 ,...
                                                vClass2                  ...
                                               );
                precision(tmp_idx) = precision(tmp_idx) + pre1;
                tmp_idx = tmp_idx + 1;


                [pre1, ~] = calPrecision(  ...
                                                c_data_for_classifier{9},...
                                                c_data_for_classifier{10},...
                                                vClass1                 ,...
                                                vClass2                  ...
                                               );
                precision(tmp_idx) = precision(tmp_idx) + pre1;


                tmp_table_to_show = ["subject: " + num2str(subject1) + " session: " + num2str(sess1) + " to " + "subject: " + num2str(subject2) + " session: " + num2str(sess2)];

                table_to_show = [table_to_show ; 
                                                [tmp_table_to_show      ,...
                                                 num2str( precision(1) ),...
                                                 num2str( precision(2) ),...
                                                 num2str( precision(3) ),...
                                                 num2str( precision(4) ),...
                                                 num2str( precision(5) ),...
                                                 num2str( precision(6) ),...
                                                 num2str( precision(7) ),...
                                                 num2str( precision(8) )]
                                ];
                disp(table_to_show); 

            end 
        end
    end
end









































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

