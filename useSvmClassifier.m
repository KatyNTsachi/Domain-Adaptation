close all
clear

%% prepare for calc 
day               = 1;
subject           = 8;
[Events, vClass]  = GetEvents( subject, day );
N                 = length(Events);

%-- Create Forier Events 
F_Events{N} = [];
for ii = 1 : N
    F_Events{ii} = abs( fft( Events{ii} ) );
end

funcs       = { @covFromCellArrayOfEvents, @correlationFromCellArrayOfEvents, @partialCorrelationFromCellArrayOfEvents };
funcs_names = { "Covariance"             , "Correlation"                    , "Partial Correlation"  };


events_names    = {" on time series", " on Furier transform"};
events_cell     = { Events          , F_Events};
% events_cell     = { F_Events          , Events};
table_to_show   = [];
titles          = { 'feature', 'baseFunction', 'averageLoss' };

%-- Fourier or not
for ii = 1 : length(events_cell)
    
    %-- Covarience Correlation or Partial Correlation
    for func_idx = 1 : length(funcs)
        
        vectors_of_features = funcs{func_idx}(events_cell{ii});
        data_for_classifier = prepareForClassification( vectors_of_features );
        
        %-- SVM Kernal
        for base_func = ["gaussian", "linear", "polynomial"]
            
            description_of_classifier_and_fetures = funcs_names{func_idx} + events_names{ii};
            table_to_show                         = [ table_to_show;
                                                      showSvmResults( data_for_classifier,...
                                                                      vClass,...
                                                                      description_of_classifier_and_fetures,...
                                                                      base_func ) ];
                                                                  
%             table_to_show                         = [table_to_show; showSvmResultsNoDiag(   data_for_classifier,...
%                                                                     vClass,...
%                                                                     description_of_classifier_and_fetures,...
%                                                                     base_func,...
%                                                                     size(vectors_of_features,1)) ];
        end
    end 
    
    %--show table
    T                          = table( table_to_show(:,1),...
                                        table_to_show(:,2),...
                                        table_to_show(:,3) );
    T.Properties.VariableNames = titles
end


