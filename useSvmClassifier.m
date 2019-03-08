close all
clear

%% prepare for calc 
day               = 1;
subject           = 8;
[Events, vClass]  = GetEvents( subject, day );
N                 = length(Events);
%-- Create STFT Events
STFTEvents            = getSTFTEvents(Events, vClass);
STFTEvents_whole_time = getSTFTEventsWholeTime(Events, vClass);
%-- Create Forier Events 
parfor ii = 1 : N
    F_Events{ii} = abs( fft( Events{ii} ) );
end

%% preprocessing - dimentionality reduction
acc = 0.99;
[pca_reduce_data_Events               , pca_mat1] = pcaReduceData( Events               , acc, "EventsAfterPca");
[pca_reduce_data_STFTEvents           , pca_mat2] = pcaReduceData( STFTEvents           , acc, "STFTEventsAfterPca");
[pca_reduce_data_STFTEvents_whole_time, pca_mat3] = pcaReduceData( STFTEvents_whole_time, acc, "STFTEvents_whole_timeAfterPca" );
[pca_reduce_data_F_Events             , pca_mat4] = pcaReduceData( F_Events             , acc, "F_EventsAfterPca" );

%% preprocessing - add more features

extended_pca_reduce_data_Events                = extendData(pca_reduce_data_Events);
extended_pca_reduce_data_STFTEvents            = extendData(pca_reduce_data_STFTEvents);
extended_pca_reduce_data_STFTEvents_whole_time = extendData(pca_reduce_data_STFTEvents_whole_time);
extended_pca_reduce_data_F_Events              = extendData(pca_reduce_data_F_Events);
extended_data_Events                           = extendData(Events);
extended_data_STFTEvents                       = extendData(STFTEvents);
extended_data_F_Events                         = extendData(F_Events);

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



events_names    = { "on time series"                                   , "on STFT transform",...
                    "F Events"                                         ,...
                    "on pca_reduce data Events"                        , "pca reduce data STFTEvents",...
                    "on pca_reduce data STFTEvents whole time"         , "pca reduce data F Events",...
                    "on extended pca reduce data Events"               , "on extended pca reduce data STFTEvents",...
                    "on extended pca reduce data STFTEvents whole time", "on extended pca reduce data F Events",...
                    "on extended data Events"                          , "on extended data STFTEvents",...
                    "on extended data F Events"};

events_cell     = { Events                                         , STFTEvents,...
                    F_Events                                       ,...
                    pca_reduce_data_Events                         , pca_reduce_data_STFTEvents,...
                    pca_reduce_data_STFTEvents_whole_time          , pca_reduce_data_F_Events,...
                    extended_pca_reduce_data_Events                , extended_pca_reduce_data_STFTEvents,...
                    extended_pca_reduce_data_STFTEvents_whole_time , extended_pca_reduce_data_F_Events,...
                    extended_data_Events                           , extended_data_STFTEvents,...
                    extended_data_F_Events};



%set base functions
% all_base_functions = ["linear", "gaussian", "polynomial"];
all_base_functions = ["linear"];

%extract the features
[c_data_for_classifier, c_description_for_data] = extractFeatures( events_cell, events_names,...
                                                                   funcs, funcs_names, vClass );

%% preprocessing - dimentionality reduction
epsilon = -0.0001;
min_dim_number = [10, 15, 20, 25, 30]; 
idx = 1;  
c_short_classifier             = {};
c_short_classifier_description = {};
c_bad_features                 = {};

for jj = 1 : length(c_data_for_classifier)
    
    for ii = 1:length( min_dim_number )

        [ v_short_classifier, bad_features ] = AddImportantDimensions(  c_data_for_classifier{jj},...
                                                                        c_description_for_data{jj},...
                                                                        vClass,...
                                                                        epsilon,...
                                                                        min_dim_number(ii) );

        c_short_classifier{idx}              = v_short_classifier;
        c_short_classifier_description{idx}  = c_description_for_data{jj} + " reduced to min " + num2str(ii) + "dimentions";
        c_bad_features{idx}                  = bad_features;
        idx =  idx + 1;
        
    end
   
end


%% combine data

[ c_combine_data, c_description ] = combineFeatures( c_short_classifier );

%% create one data

 [ c_combined_data, c_combined_description ] = combineThreeCellArray(   c_data_for_classifier, c_description_for_data,...
                                                                        c_short_classifier, c_short_classifier_description,...
                                                                        c_combine_data, c_description);


%% just run svm
%get svm loss for the funcs and input the we set up here
% table_to_show = [];
% table_to_show = calcSvmLoss( c_short_classifier, vClass,...
%                              c_description_for_data, all_base_functions,...
%                              table_to_show)

table_to_show = [];
table_to_show = calcSvmLoss( c_combined_data, vClass,...
                             c_combined_description, all_base_functions,...
                             table_to_show)


%% run svm on all training - not very interesting
%get svm loss for the funcs and input the we set up here
% table_to_show = [];
% table_to_show = calcSvmLossAllTraining(  c_short_classifier, vClass,...
%                                          c_description_for_data, all_base_functions,...
%                                          table_to_show)
                         


table_to_show = [];
table_to_show = calcSvmLossAllTraining(  c_combined_data, vClass,...
                                         c_combined_description, all_base_functions,...
                                         table_to_show)
