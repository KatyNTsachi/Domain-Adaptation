close all
clear
addpath("./functions");
addpath("./functions/npy");
addpath("./functions/clustering");



table_to_show = [];
table_to_show = [table_to_show; [   ...
                                    "description"                    ,...
                                    "regular"                        ,...
                                    "with PCA mean"                  ,...
                                    
                                ]
                ];

%%


%% prepare for calc
NUM_OF_DATA = 2;
subjects = 1:7;
session = 1:8;

for subject = subjects
    
    for sess = session
        
        [Events, vClass]  = getERPEvents(subject, sess);
        EventsMat         = cell2mat(Events);

        n_time     = size(Events{1}, 1);
        n_channels = size(Events{1}, 2);

        EventsMat         = reshape(EventsMat, n_time, n_channels, [] );

        %permute
        N = size(vClass,1);
        p = randperm(N);
        tmp_res = zeros(NUM_OF_DATA, 1);
        k = 10;
        test_size = int32(linspace(1, N, k+1 ));
        for ii = 1:k

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

            vClass_train = vClass(p_train);
            vClass_test  = vClass(p_test);

            % put events mats back to cell array
            EventsMat_train = reshape(EventsMat_train, n_time, [] );
            EventsMat_test  = reshape(EventsMat_test , n_time, [] );

            rowDest_train =  n_channels * ones(size(p_train));
            rowDest_test  =  n_channels * ones(size(p_test));

            Events_train = mat2cell(EventsMat_train, n_time, rowDest_train);
            Events_test  = mat2cell(EventsMat_test , n_time,  rowDest_test);



            %% extract relevant classes
            class_1 = 1;
            class_2 = 2;

            good_idx     = vClass_train == class_1 | vClass_train == class_2;
            Events_train = Events_train( good_idx(:) );
            vClass_train = vClass_train(good_idx);

            good_idx     = vClass_test == class_1 | vClass_test == class_2;
            Events_test  = Events_test( good_idx(:) );
            vClass_test  = vClass_test(good_idx);
            %% add the average

            [Events_train_with_PCA_mean, Events_test_with_PCA_mean] = addPCAAverageOldDataTest( Events_train,...
                                                                                                Events_test,...
                                                                                                vClass_train);   
                                                                                         
            %% doing covariance correlation and partial correlation
            c_data_for_classifier  = {};
            c_description_for_data = {};
            % funcs       = { @covFromCellArrayOfEvents, @correlationFromCellArrayOfEvents, @partialCorrelationFromCellArrayOfEvents };
            % funcs_names = { "Covariance"             , "Correlation"                    , "Partial Correlation"  };
            funcs       = { @covFromCellArrayOfEvents};
            funcs_names = { "Covariance"};

            % events_names    = { "on time series"                                   , "on STFT transform",...
            %                     "on STFTEvents whole_time"                         , "F Events",...
            %                     "on pca_reduce data Events"                        , "pca reduce data STFTEvents",...
            %                     "on pca_reduce data STFTEvents whole time"         , "pca reduce data F Events",...
            %                     "on extended pca reduce data Events"               , "on extended pca reduce data STFTEvents",...
            %                     "on extended pca reduce data STFTEvents whole time", "on extended pca reduce data F Events",...
            %                     "on extended data Events"                          , "on extended data STFTEvents",...
            %                     "on extended data F Events"                        , "on extended data Events with const fetures"};

            % events_cell     = { Events                                         , STFTEvents,...
            %                     STFTEvents_whole_time                          , F_Events,...
            %                     pca_reduce_data_Events                         , pca_reduce_data_STFTEvents,...
            %                     pca_reduce_data_STFTEvents_whole_time          , pca_reduce_data_F_Events,...
            %                     extended_pca_reduce_data_Events                , extended_pca_reduce_data_STFTEvents,...
            %                     extended_pca_reduce_data_STFTEvents_whole_time , extended_pca_reduce_data_F_Events,...
            %                     extended_data_Events                           , extended_data_STFTEvents,...
            %                     extended_data_F_Events                         , extended_data_Events_with_const_fetures};
           
            tmp_description  = "subject " + num2str(subject) + "    session " + num2str(sess) + "    k(not relevant) " + num2str(ii);
            events_names    = {
                                "Events train "                     + tmp_description,...
                                "Events test "                      + tmp_description,...
                                "Events train with PCA mean"        + tmp_description,...
                                "Events test with PCA mean"         + tmp_description...

                              };

            events_cell     = { 
                                Events_train                            ,...
                                Events_test                             ,...
                                Events_train_with_PCA_mean              ,...
                                Events_test_with_PCA_mean                ...

                              };

            %set base functions
            % all_base_functions = ["linear", "gaussian", "polynomial"];
            all_base_functions = ["linear"];

            %extract the features
            [c_data_for_classifier, c_description_for_data] = extractFeatures( events_cell, events_names,...
                                                                                 funcs, funcs_names, vClass );


            %% show PCA

            %     pcaReduceCovData(c_data_for_classifier{1}, c_description_for_data{1}, vClass);
            %     pcaReduceCovData(c_data_for_classifier{2}, c_description_for_data{2}, vClass);
            %     pcaReduceCovData(c_data_for_classifier{3}, c_description_for_data{3}, vClass);

            %% show TSNE

            %     showTSNE2class(  c_data_for_classifier, vClass, c_description_for_data );


            %% just run svm
            %get svm loss for the funcs and input the we set up here
            % table_to_show = [];
            % table_to_show = calcSvmLoss( c_short_classifier, vClass,...
            %                              c_description_for_data, all_base_functions,...
            %                              table_to_show)


    %         table_to_show = calcSvmLoss( c_data_for_classifier , vClass,...
    %                                      c_description_for_data, all_base_functions,...
    %                                      table_to_show);

            for res_idx = 1 : NUM_OF_DATA
         
                tmp_res(res_idx) = tmp_res(res_idx) + calPrecision(...
                                                                    c_data_for_classifier{(res_idx-1)*2+1},...
                                                                    c_data_for_classifier{(res_idx-1)*2+2},...
                                                                    vClass_train                          ,...
                                                                    vClass_test                            ...
                                                                    );          
            end




            
            
            
        end
        
        tmp_str = [];
        
        for tmp_str_num = 1 : NUM_OF_DATA
        
            tmp_str = [ string(tmp_str) ,...
                        num2str(tmp_res(tmp_str_num)/k)];
            
        end
        
        table_to_show = [table_to_show; [   ...
                                            "subject: " + num2str(subject) + "session: " + num2str(sess),...
                                            tmp_str                                        
                                        ]
                        ]
    end
end

disp(table_to_show);





function [pre] = calPrecision(X, X_test,y, y_test)
    
    t             = templateSVM('Standardize', false, 'KernelFunction', 'linear');
    Mdl           = fitcecoc( X', ...
                              y, ...
                              'Learners', t);
    predicted_label = predict( Mdl, X_test' );

    tp  = sum((y_test == 2) & (predicted_label == 2));
    fp  = sum((y_test == 1) & (predicted_label == 2));
    pre = tp / (tp + fp);

end



