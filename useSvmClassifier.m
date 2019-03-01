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
% acc = 1.0;
% [pca_reduce_data_Events               , pca_mat1] = pcaReduceData( Events               , acc, "EventsAfterPca");
% [pca_reduce_data_STFTEvents           , pca_mat2] = pcaReduceData( STFTEvents           , acc, "STFTEventsAfterPca");
% [pca_reduce_data_STFTEvents_whole_time, pca_mat3] = pcaReduceData( STFTEvents_whole_time, acc, "STFTEvents_whole_timeAfterPca" );
% [pca_reduce_data_F_Events             , pca_mat4] = pcaReduceData( F_Events             , acc, "F_EventsAfterPca" );

%% preprocessing - add more features

% % extended_pca_reduce_data_Events                = extendData(pca_reduce_data_Events);
% % extended_pca_reduce_data_STFTEvents            = extendData(pca_reduce_data_STFTEvents);
% % extended_pca_reduce_data_STFTEvents_whole_time = extendData(pca_reduce_data_STFTEvents_whole_time);
% % extended_pca_reduce_data_F_Events              = extendData(pca_reduce_data_F_Events);
% % extended_data_Events                           = extendData(Events);
% % extended_data_STFTEvents                       = extendData(STFTEvents);
% % extended_data_F_Events                         = extendData(F_Events);

%% split in time

window_size = 250;
Events_split_time = splitInTime( Events, window_size );


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



events_names    = { "on split time series"};          
events_cell     = { Events_split_time};



%set base functions
% all_base_functions = ["linear", "gaussian", "polynomial"];
all_base_functions = ["linear", "gaussian", "polynomial"];

%extract the features
[c_data_for_classifier, c_description_for_data] = extractFeatures( events_cell, events_names,...
                                                                   funcs, funcs_names, vClass );




%% just run svm
%get svm loss for the funcs and input the we set up here
% table_to_show = [];
% table_to_show = calcSvmLoss( c_short_classifier, vClass,...
%                              c_description_for_data, all_base_functions,...
%                              table_to_show)
clc
table_to_show = [];
table_to_show = calcSvmLoss( c_data_for_classifier, vClass,...
                             c_description_for_data, all_base_functions,...
                             table_to_show)

