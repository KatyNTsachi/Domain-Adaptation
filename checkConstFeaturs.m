close all
clear
addpath("./functions")

%% prepare for calc 
day               = 1;
subject           = 8;
[Events, vClass]  = GetEvents( subject, day );
N                 = length(Events);
%-- Create STFT Events
%-- Create Forier Events 
parfor ii = 1 : N
    F_Events{ii} = abs( fft( Events{ii} ) );
end

%% preprocessing - add more features

extended_data_Events   = extendData(Events);
extended_data_F_Events = extendData(F_Events);

%% doing covariance correlation and partial correlation
c_data_for_classifier  = {};
c_description_for_data = {};
% funcs       = { @covFromCellArrayOfEvents, @correlationFromCellArrayOfEvents, @partialCorrelationFromCellArrayOfEvents };
% funcs_names = { "Covariance"             , "Correlation"                    , "Partial Correlation"  };
funcs       = { @covFromCellArrayOfEvents, @correlationFromCellArrayOfEvents, @partialCorrelationFromCellArrayOfEvents };
funcs_names = { "Covariance"             , "Correlation"                    , "Partial Correlation"  };


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



events_names    = { "on time series"                                   , "F Events"                                         ,...
                    "on extended data Events"                          , "on extended data F Events"};

events_cell     = { Events                                         , F_Events                                       ,...
                    extended_data_Events                           , extended_data_F_Events};



%set base functions
% all_base_functions = ["linear", "gaussian", "polynomial"];
all_base_functions = ["linear", "gaussian", "polynomial"];

%extract the features
[c_data_for_classifier, c_description_for_data] = extractFeatures( events_cell, events_names,...
                                                                   funcs, funcs_names, vClass );

%% extend data rectangular wave

c_data_to_add_waves             = { Events                  , F_Events };
c_data_to_add_waves_description = { "Events time with waves", "furier Events time with waves" };

                               
waves_size = [10, 20, 30, 40, 50, 60];
[ c_data_for_classifier_with_rec_waves,...
  c_description_for_data_with_rec_waves] = covWIthConstFeatures(   c_data_to_add_waves,...
                                                                   c_data_to_add_waves_description,...
                                                                   @addTimeWindowChanels, waves_size );
                                                               
sigma = [50 ,51];
[ c_data_for_classifier_with_gau_waves,...
  c_description_for_data_with_gau_waves] = covWIthConstFeatures(   c_data_to_add_waves,...
                                                                   c_data_to_add_waves_description,...
                                                                   @addGaussianWindowCannels, sigma );



%% create one data
[ c_combined_data, c_combined_description ] = combineThreeCellArray(   c_data_for_classifier, c_description_for_data,...
                                                                       c_data_for_classifier_with_rec_waves, c_description_for_data_with_rec_waves,...
                                                                       c_data_for_classifier_with_gau_waves, c_description_for_data_with_gau_waves);

%% calc svm
table_to_show = [];
table_to_show = calcSvmLossTnV( c_combined_data, vClass,...
                                c_combined_description, all_base_functions,...
                                table_to_show);

