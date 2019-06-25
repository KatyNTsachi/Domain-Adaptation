close all
clear
addpath("./functions");
addpath("./functions/npy");
addpath("./functions/clustering");

table_to_show = [];


%% prepare for calc

subjects              = [1, 2, 3, 4, 5, 6, 7, 8, 9];
place_in_the_mid_list = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
days_list             = [1, 2];

for subject = subjects
    for day_number = days_list
        for place_in_the_mid = place_in_the_mid_list

            day               = day_number;
            [Events, vClass]  = GetEvents( subject, day );

            %%
            good_idx = vClass==1 | vClass==2;
            Events = Events(good_idx(:));
            vClass = vClass(good_idx);
            %% add the avrg
            Events_with_mean            = addAverage(Events, vClass);
            Events_with_mean_difference = addDiffrenceAverageOldData(Events, vClass);
            Events_with_shifted_mean    = addShiftedAverage(Events, vClass, place_in_the_mid);

        %     Events_with_Claster_mean    = addClusterAverage(Events, vClass, @customKmean);
            % add mean to chanells
            % show covarience 
            % do svm



            %% find PCA and add to Events

            %Events_with_pca = concatPcaToData( Events, vClass, 2);

            %% JUST FOR FUN see expirement number tmp_num

            event_num = 1;
            %     showAllChannels( Events{event_num}, 'event' + num2str(event_num));
            %     showAllChannels( Events_with_mean_difference{event_num}(:, 17:end), 'mean' );
            %     showAllChannels( Events_with_Claster_mean{event_num}(:, 17:end), 'PCA' );
            % 

            %% show covarience

            trial = 6;
            %     calcAndShowCov(Events_with_pca{trial}, "Cov with avg");

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
                        "on time series subject_"                      + num2str(subject) + num2str(day_number) ,...
                        "on time series with mean_"                    + num2str(subject) + num2str(day_number),...
                        "on time series with mean difference_"         + num2str(subject) + num2str(day_number),...
                        "on time series with mean difference shifted_" + num2str(subject) + num2str(day_number) + num2str(place_in_the_mid),...
                      };

            events_cell     = { 
                                Events,...
                                Events_with_mean,...
                                Events_with_mean_difference,...
                                Events_with_shifted_mean
                              };


            events_names    = {
                                "on time series subject_"                      + num2str(subject) + num2str(day_number) ,...
                                "on time series with mean_"                    + num2str(subject) + num2str(day_number) ,...
                                "on time series with mean difference_"         + num2str(subject) + num2str(day_number) ,...
                                "on time series with mean difference shifted_" + num2str(subject) + num2str(day_number) + num2str(place_in_the_mid),...
                              };

            events_cell     = { 
                                Events,...
                                Events_with_mean,...
                                Events_with_mean_difference,...
                                Events_with_shifted_mean
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
end

disp(table_to_show);







