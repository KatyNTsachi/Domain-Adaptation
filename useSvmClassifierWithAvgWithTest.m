close all
clear
addpath("./functions");
addpath("./functions/npy");
addpath("./functions/clustering");



table_to_show = [];


%% prepare for calc

subjects = [1, 2, 3, 4, 5, 6, 7, 8, 9];
for subject = subjects
    day     = 1;
    [Events, vClass]  = GetEvents( subject, day );
    
    %permute
    N = size(vClass,1);
    p = randperm(N);

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

        EventsMat       = cell2mat(Events);
        EventsMat       = reshape(EventsMat,750, 22, [] );
        EventsMat_train = EventsMat(:, :, p_train);
        EventsMat_test  = EventsMat(:, :, p_test);

        EventsMat_train = reshape(EventsMat_train,750, [] );
        EventsMat_test  = reshape(EventsMat_test ,750, [] );

        rowDest_train =  22*ones(size(p_train));
        rowDest_test  =  22*ones(size(p_test));

        Events_train = mat2cell(EventsMat_train, 750, rowDest_train);
        Events_test  = mat2cell(EventsMat_test , 750,  rowDest_test);
        
        vClass_train = vClass(p_train);
        vClass_test  = vClass(p_test);

        %%
        good_idx     = vClass_train == 1 | vClass_train == 2;
        Events_train = Events_train( good_idx(:) );
        vClass_train = vClass_train(good_idx);
        
        good_idx     = vClass_test == 1 | vClass_test == 2;
        Events_test  = Events_test( good_idx(:) );
        vClass_test  = vClass_test(good_idx);
        %% add the avrg

        [Events_train_with_mean, Events_test_with_mean] = addAverageTest( Events_train,...
                                                                          Events_test,...
                                                                          vClass_train);
                                                                      
        [Events_train_with_mean_difference,...
         Events_test_with_mean_difference] = addDiffrenceAverageOldDataTest(    Events_train,...
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

        events_names    = {
                            "Events train "                     + num2str(subject) + num2str(day) + num2str(ii),...
                            "Events test "                      + num2str(subject) + num2str(day) + num2str(ii),...
                            "Events train with mean "           + num2str(subject) + num2str(day) + num2str(ii),...
                            "Events test with mean mean "       + num2str(subject) + num2str(day) + num2str(ii),...
                            "Events train with mean difference" + num2str(subject) + num2str(day) + num2str(ii),...
                            "Events test with mean difference"  + num2str(subject) + num2str(day) + num2str(ii) ...
                          };

        events_cell     = { 
                            Events_train                     ,...
                            Events_test                      ,...
                            Events_train_with_mean           ,...
                            Events_test_with_mean            ,...
                            Events_train_with_mean_difference,...
                            Events_test_with_mean_difference  ...
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


        table_to_show = calcSvmLoss( c_data_for_classifier , vClass,...
                                     c_description_for_data, all_base_functions,...
                                     table_to_show);



    end

end

disp(table_to_show);








