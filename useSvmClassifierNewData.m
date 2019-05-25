close all
clear
clc
addpath("./functions");
addpath("./functions/npy");

%% prepare for calc 

subject = 2;
[Events, vClass] = getERPEvents(subject);

%% JUST FOR FUN see expirement number tmp_num

event_num = 1;
showAllChannels(Events{event_num});


%% add the avrg

Events_with_mean = addAverage(Events, vClass);
% add mean to chanells
% show covarience 
% do svm


%% show covarience

trial = 6;
calcAndShowCov(Events_with_mean{trial}, "Cov with avg");


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

events_names    = {"on time series subject_" + num2str(subject), "on time series with more features subject_" + num2str(subject) };

events_cell     = { Events, Events_with_mean };

%set base functions
% all_base_functions = ["linear", "gaussian", "polynomial"];
all_base_functions = ["linear"];

%extract the features
[c_data_for_classifier, c_description_for_data] = extractFeatures( events_cell, events_names,...
                                                                     funcs, funcs_names, vClass );

                                                                 
%% show PCA

pcaReduceCovData(c_data_for_classifier{1}, c_description_for_data{1}, vClass);
pcaReduceCovData(c_data_for_classifier{2}, c_description_for_data{2}, vClass);


%% just run svm
%get svm loss for the funcs and input the we set up here
% table_to_show = [];
% table_to_show = calcSvmLoss( c_short_classifier, vClass,...
%                              c_description_for_data, all_base_functions,...
%                              table_to_show)

table_to_show = [];
table_to_show = calcSvmLoss( c_data_for_classifier , vClass,...
                             c_description_for_data, all_base_functions,...
                             table_to_show)
















