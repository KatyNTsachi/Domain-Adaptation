close all
clear

%% prepare for calc
day               = 1;
subject           = 3;
[Events, vClass]  = GetEvents(subject,day);
cov_of_all_events = covFromCellArrayOfEvents(Events);
class1            = 1;
class2            = 2;
class1_cov        = cov_of_all_events(:,:,vClass == class1);
class2_cov        = cov_of_all_events(:,:,vClass == class2);
two_cov           = cov_of_all_events(:,:, (vClass == class1 | vClass == class2) );
epsilon           = 1e-6;
max_iter          = 100;

mean1  = riemannianMean(class1_cov, epsilon, max_iter);
mean2  = riemannianMean(class2_cov, epsilon, max_iter);
dist11 = calcDistanceBetweenCovMat(mean1, class1_cov);
dist12 = calcDistanceBetweenCovMat(mean1, class2_cov);
dist21 = calcDistanceBetweenCovMat(mean2, class1_cov);
dist22 = calcDistanceBetweenCovMat(mean2, class2_cov);       

%% print
figure; hold on; grid on; set(gca, 'FontSize', 16);
scatter(dist11, dist21, 50, 'Fill', 'MarkerEdgeColor', 'k');
scatter(dist12, dist22, 50, 'Fill', 'MarkerEdgeColor', 'k');
axis equal;

title('Reimanian Distance to Reimanian mean');
xlabel('Reimanian distance to class 1 mean');
ylabel('Reimanian distance to class 2 mean');

%% svm for Covariance
data_for_classifier_cov = prepareForClassification(cov_of_all_events);


%calc svm and show confusion matrix
Md_cov    = fitcecoc( data_for_classifier_cov', vClass, 'KFold', 5);
label_cov = Md_cov.kfoldPredict();


% label_cov = predict(Md_cov.Trained{1},data_for_classifier_cov(1:end-1,:)');
C_cov     = confusionmat(data_for_classifier_cov(end,:),label_cov);
% confusionchart(C_cov);
% title('covariance');
figure; plotconfusion(vClass, label_cov);


%% svm for Correlation 

corr_of_all_events              = correlationFromCellArrayOfEvents(Events);
data_for_classifier_correlation = prepareForClassification(corr_of_all_events,vClass);

%calc svm and show confusion matrix
Md_corr    = fitcecoc( data_for_classifier_correlation(1:end-1,:)', ...
                  data_for_classifier_correlation(end,:), 'Holdout', 0.15);
label_corr = predict(Md_corr.Trained{1},data_for_classifier_correlation(1:end-1,:)');
C_corr     = confusionmat(data_for_classifier_correlation(end,:),label_corr);
confusionchart(C_corr);
title('correlation');correlation

%% svm for partialCorrelation 
partial_corr_of_all_events = partialCorrelationFromCellArrayOfEvents(Events);
data_for_classifier_par_correlation = prepareForClassification(partial_corr_of_all_events,vClass);


