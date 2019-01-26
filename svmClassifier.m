close all
clear
%% prepare for calc 
day               = 1;
subject           = 3;
[Events, vClass]  = GetEvents( subject, day );
epsilon           = 1e-6;
max_iter          = 100;

%-- Create Forier Events 
F_Events={length(Events)};
for ii=1:length(Events)
    F_Events{ii} = abs( fft( Events{ii} ) );
end

funcs = {@covFromCellArrayOfEvents, @correlationFromCellArrayOfEvents, @partialCorrelationFromCellArrayOfEvents};
funcs_names = {"Covariance", "Correlation", "Partial Correlation"};
events_names = {" on Furier transform", " on time series"};
events_cell = {Events, F_Events};

for ii = 1:length(events_cell)% Fourier or not
    for func_idx=1:length(funcs)% Covarience Correlation or Partial Correlation
        data_for_classifier = prepareForClassification( funcs{func_idx}(events_cell{ii}) );
        for base_func=["gaussian" "linear" "polynomial"]% SVM Kernal
            showSvmResults( data_for_classifier, vClass, funcs_names{func_idx}+events_names{ii} ,base_func);
        end
    end  
end


