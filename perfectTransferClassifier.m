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
             
subjects = 8:24;
sessions = 1:1;


for subject = subjects
    for sess = sessions 

        %% -arrange data
        [Events, vClass]  = getERPEvents(subject, sess);
        EventsMat         = cell2mat(Events);

        n_time     = size(Events{1}, 1);
        n_channels = size(Events{1}, 2);

        EventsMat         = reshape(EventsMat, n_time, n_channels, [] );



        %permute
        N = size(vClass,1);
        p = randperm(N);
        k = 10;
        test_size = int32(linspace(1, N, k+1 ));



        NUMBER_OF_PRECISIONS = 5;
        precision = zeros(NUMBER_OF_PRECISIONS, 1);

        for ii = 1 : k

            test_start_i = test_size(ii);
            test_end_i   = test_size(ii + 1);

            if test_start_i == 1
                p_train = p(test_end_i + 1 : end);
            elseif  test_end_i == N
                p_train = p(1 : test_start_i - 1);
            else 
                p_train = [p(1 : test_start_i - 1), p(test_end_i + 1 : end)];
            end
            p_test  =  p(test_start_i : test_end_i);

            % devide events mat to train and test
            EventsMat_train = EventsMat(:, :, p_train);
            EventsMat_test  = EventsMat(:, :, p_test);

            vClass1 = vClass(p_train);
            vClass2  = vClass(p_test);

            % put events mats back to cell array
            EventsMat_train = reshape(EventsMat_train, n_time, [] );
            EventsMat_test  = reshape(EventsMat_test , n_time, [] );

            rowDest_train =  n_channels * ones(size(p_train));
            rowDest_test  =  n_channels * ones(size(p_test));

            Events1 = mat2cell(EventsMat_train, n_time, rowDest_train);
            Events2  = mat2cell(EventsMat_test , n_time,  rowDest_test);

            %- extract relevant classes
            class_1 = 1;
            class_2 = 2;

            good_idx     = vClass1 == class_1 | vClass1 == class_2;
            Events1 = Events1( good_idx(:) );
            vClass1 = vClass1(good_idx);

            good_idx     = vClass2 == class_1 | vClass2 == class_2;
            Events2  = Events2( good_idx(:) );
            vClass2  = vClass2(good_idx);








            %% -see average of target

        %     figure();
        %     subplot(2, 1, 1);
        %     plot( getMean(Events1, vClass1) );
        %     subplot(2, 1, 2);
        %     plot( getMean(Events2, vClass2) );


            %% Original Data

            Events1_with_mean                 = addAverageSub(Events1, vClass1);               
            Events2_with_mean                 = addAverageSub(Events2, vClass2);

            [Events1_with_pca,... 
             Events2_with_pca]                = addPCAAverageTest(Events1, Events2, vClass1, vClass2);   

            [Events1_with_pca_GMM,...
             Events2_with_pca_GMM]            = addPCAGMMAverageTest( Events1, Events2, vClass1, vClass2);   





            % [Events1_with_pca_GMM, ~]         = addPCAGMMAverageOldDataTestTwoOptions( Events1, vClass1); 
            % [Events2_with_pca_GMM_option1,...
            %  Events2_with_pca_GMM_option2]    = addPCAGMMAverageOldDataTestTwoOptions( Events2, vClass2);                                                              
            % 
            %     [~, Events2_with_train_mean] = addDiffrenceAverageOldDataTest(Events1, Events2, vClass1);
            %     [Events1_with_pca, ~]        = addPCAAverageOldDataTestTwoOptions(  Events1,...

            %         [Events2_with_pca_option1,...
            %          Events2_with_pca_option2] = addPCAAverageOldDataTestTwoOptions(  Events2,...
            %                                                                           vClass2);   
            %     
            %     [Events2_with_pca_GMM_option1,...
            %      Events2_with_pca_GMM_option2] = addPCAGMMAverageOldDataTestTwoOptions( Events2,...
            %                                                                             vClass2);   
            %                                                             

            %%
            c_data_for_classifier  = {};
            c_description_for_data = {};

            funcs       = { @covFromCellArrayOfEvents};
            funcs_names = { "Covariance"};

            tmp_description  = "subject " + num2str(subject) + "    session " + num2str(sess);

            events_names    = { 
                                "original session"                   + tmp_description,...
                                "new session"                        + tmp_description,...
                                "original session with real mean"    + tmp_description,...
                                "new session with real mean"         + tmp_description,...
                                "original session PCA"               + tmp_description,...
                                "new session PCA "                   + tmp_description,...
                                "original session GMM PCA"           + tmp_description,...
                                "new session GMM PCA"       + tmp_description,...
                               };

            events_cell     = { 
                                Events1                       ,...
                                Events2                       ,...
                                Events1_with_mean             ,...
                                Events2_with_mean             ,...
                                Events1_with_pca              ,...
                                Events2_with_pca              ,...
                                Events1_with_pca_GMM          ,...
                                Events2_with_pca_GMM          ,...
                               };

            %set base functions
            % all_base_functions = ["linear", "gaussian", "polynomial"];
            all_base_functions = ["linear"];

            %extract the features
            [c_data_for_classifier, c_description_for_data] = extractFeatures( events_cell, events_names,...
                                                                                 funcs, funcs_names, vClass );

        %     %% - show TSNE
        %     figure();
        %     subplot(3, 3, 1);
        %     showTSNE(c_data_for_classifier{1}, vClass1);
        %     title('TSNE original');
        % 
        %     subplot(3, 3, 2);
        %     showTSNE(c_data_for_classifier{3}, vClass1);
        %     title('TSNE with mean');
        %     % subplot(2, 2, 3);
        %     % showTSNE(c_data_for_classifier{5}, vClass1);
        %     % title('with PCA');
        % 
        %     %% - show pca
        % 
        %     % figure();
        %     subplot(3, 3, 4);
        %     showPCA(c_data_for_classifier{1}, vClass1);
        %     title('PCA original');
        % 
        %     subplot(3, 3, 5);
        %     showPCA(c_data_for_classifier{3}, vClass1);
        %     title('PCA with mean');
        % 
        %     %% clustering
        %     subplot(3, 3, 7);
        %     showPCA(c_data_for_classifier{5}, vClass1);
        %     title('PCA CLUSTERING');
        % 
        %     subplot(3, 3, 8);
        %     showPCA(c_data_for_classifier{7}, vClass1);
        %     title('GMM PCA CLUSTERING');


            %%

            tmp_idx = 1;
            [pre1, ~] = calPrecision(...
                                                c_data_for_classifier{1},...
                                                c_data_for_classifier{2},...
                                                vClass1                 ,...
                                                vClass2                  ...
                                             );
            precision(tmp_idx) = precision(tmp_idx) + pre1;
            tmp_idx = tmp_idx + 1;

            [pre1, ~] = calPrecision(  ...
                                            c_data_for_classifier{3},...
                                            c_data_for_classifier{4},...
                                            vClass1                 ,...
                                            vClass2                  ...
                                           );
            precision(tmp_idx) = precision(tmp_idx) + pre1;
            tmp_idx = tmp_idx + 1;

            [pre1, ~] = calPrecision(  ...
                                            c_data_for_classifier{5},...
                                            c_data_for_classifier{6},...
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



        end

        tmp_table_to_show = ["subject: " + num2str(subject) + " session: " + num2str(sess)];

        table_to_show = [table_to_show ; 
                                        [tmp_table_to_show         ,...
                                         num2str( precision(1) / k),...
                                         num2str( precision(2) / k),...
                                         num2str( precision(3) / k),...
                                         num2str( precision(4) / k)]
                        ];
        disp(table_to_show); 


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