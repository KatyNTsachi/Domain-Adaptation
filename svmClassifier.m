close all
clear
%% prepare for calc 
day               = 1;
subject           = 3;
[Events, vClass]  = GetEvents( subject, day );
epsilon           = 1e-6;
max_iter          = 100;

%% svm for Covariance
cov_of_all_events       = covFromCellArrayOfEvents( Events );
data_for_classifier_cov = prepareForClassification( cov_of_all_events );
showSvmResults( data_for_classifier_cov, vClass, 'Covariance' );

%% svm for Correlation 
corr_of_all_events              = correlationFromCellArrayOfEvents( Events );
data_for_classifier_correlation = prepareForClassification( corr_of_all_events );
showSvmResults( data_for_classifier_cov, vClass, 'Correlation' );

%% svm for partialCorrelation 
partial_corr_of_all_events          = partialCorrelationFromCellArrayOfEvents( Events );
data_for_classifier_par_correlation = prepareForClassification( partial_corr_of_all_events );
showSvmResults( data_for_classifier_par_correlation, vClass, 'partialCorrelation' );