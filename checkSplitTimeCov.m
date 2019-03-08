close all
clear
addpath("./functions")
    
%% prepare for calc 
day               = 1;
subject           = 8;
[Events, vClass]  = GetEvents( subject, day );
N                 = length(Events);
%-- Create STFT Events
STFTEvents            = getSTFTEvents(Events, vClass);
%-- Create Forier Events 
parfor ii = 1 : N
    F_Events{ii} = abs( fft( Events{ii} ) );
end

%% split in time

window_size           = 250;
Events_split_time     = splitInTime( Events, window_size );
Fureiet_split_time    = splitInTime( F_Events, window_size );
%window_size           = 
%STFTEvents_split_time = splitInTime( STFTEvents, window_size );
 


%% doing covariance correlation and partial correlation
c_data_for_classifier  = {};
c_description_for_data = {};

% funcs       = { @covFromCellArrayOfEvents, @correlationFromCellArrayOfEvents, @partialCorrelationFromCellArrayOfEvents };
% funcs_names = { "Covariance"             , "Correlation"                    , "Partial Correlation"  };
funcs       = { @covFromCellArrayOfEvents, @correlationFromCellArrayOfEvents, @partialCorrelationFromCellArrayOfEvents };
funcs_names = { "Covariance"             , "Correlation"                    , "Partial Correlation"  };

%events_names    = { "on split time series", "on split furier series", "on split stft series"};          
%events_cell     = { Events_split_time     , Fureiet_split_time      ,  STFTEvents_split_time};

events_names    = {" on time series ", "on furier series" ," on split time series " + num2str(window_size), " on split furier series " + num2str(window_size)};          
events_cell     = { Events           , F_Events           , Events_split_time                             , Fureiet_split_time                               };


%set base functions
% all_base_functions = ["linear", "gaussian", "polynomial"];
all_base_functions = ["linear", "gaussian", "polynomial"];

%extract the features
[c_data_for_classifier, c_description_for_data] = extractFeatures( events_cell, events_names,...
                                                                   funcs, funcs_names, vClass );
%% add original covarience

tmp                                        = length(c_data_for_classifier)/2;
c_data_for_classifier_combined             = c_data_for_classifier;
c_description_for_data_classifier_combined = c_description_for_data;

for ii = 1:tmp
    c_data_for_classifier_combined{end + 1}             = [c_data_for_classifier{ii};c_data_for_classifier{ii+tmp}];
    c_description_for_data_classifier_combined{end + 1} = c_description_for_data{ii} + "and" + c_description_for_data{ii+tmp};
end

%% use 
table_to_show = [];
table_to_show = calcSvmLossTnV( c_data_for_classifier_combined, vClass,...
                                c_description_for_data_classifier_combined, all_base_functions,...
                                table_to_show)

