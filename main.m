close all
clear all
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

%% svm
two_mean                        = riemannianMean(two_cov, epsilon, max_iter);
class1_cov_projected_to_two_cov = projectToTangentSpace(two_mean, class1_cov);
class2_cov_projected_to_two_cov = projectToTangentSpace(two_mean, class2_cov); 
num_of_features                 = size(class1_cov,1)*size(class1_cov,2);
class1_cov_projected_to_two_cov = reshape(class1_cov_projected_to_two_cov, num_of_features,[]);
class2_cov_projected_to_two_cov = reshape(class2_cov_projected_to_two_cov, num_of_features,[]);

%calc svm
X = [class1_cov_projected_to_two_cov,class2_cov_projected_to_two_cov]
Y = [ ones( size(class1_cov_projected_to_two_cov,2),1 ); ones(size(class1_cov_projected_to_two_cov,2),1) * 2 ];
Mdl = fitcsvm(X',Y);
tmp = [X',Y]





