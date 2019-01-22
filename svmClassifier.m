close all
clear
%% prepare for calc 
day               = 1;
subject           = 3;
[Events, vClass]  = GetEvents( subject, day );
epsilon           = 1e-6;
max_iter          = 100;

%-- create forier Events 
F_Events={};
for ii=1:length(Events)
    F_Events{ii} = abs( fft( Events{ii} ) );
end

for base_func=["gaussian" "linear" "polynomial"]
    
    
    
    %% svm for Covariance
    cov_of_all_events       = covFromCellArrayOfEvents( Events );
    data_for_classifier_cov = prepareForClassification( cov_of_all_events );
    showSvmResults( data_for_classifier_cov, vClass, 'Covariance' ,base_func);

    %% svm for Correlation 
    corr_of_all_events              = correlationFromCellArrayOfEvents( Events );
    data_for_classifier_correlation = prepareForClassification( corr_of_all_events );
    showSvmResults( data_for_classifier_cov, vClass, 'Correlation', base_func );

    %% svm for partialCorrelation 
    partial_corr_of_all_events          = partialCorrelationFromCellArrayOfEvents( Events );
    data_for_classifier_par_correlation = prepareForClassification( partial_corr_of_all_events );
    showSvmResults( data_for_classifier_par_correlation, vClass, 'partialCorrelation', base_func );

    %% svm for Fourier  Covariance
    F_cov_of_all_events       = covFromCellArrayOfEvents( F_Events );
    F_data_for_classifier_cov = prepareForClassification( F_cov_of_all_events );
    showSvmResults( F_data_for_classifier_cov, vClass, 'Fourier Covariance', base_func );

    %% svm for Fourier  Correlation 
    F_corr_of_all_events              = correlationFromCellArrayOfEvents( F_Events );
    F_data_for_classifier_correlation = prepareForClassification( F_corr_of_all_events );
    showSvmResults( F_data_for_classifier_cov, vClass, 'Fourier Correlation', base_func );

    %% svm for Fourier  partialCorrelation 
    F_partial_corr_of_all_events          = partialCorrelationFromCellArrayOfEvents( F_Events );
    F_data_for_classifier_par_correlation = prepareForClassification( F_partial_corr_of_all_events );
    showSvmResults( F_data_for_classifier_par_correlation, vClass, 'Fourier partialCorrelation', base_func );

end 

