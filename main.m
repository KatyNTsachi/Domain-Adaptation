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