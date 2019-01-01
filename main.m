close all
clear

%%
day     = 1;
subject = 1;

[Events, vClass] = GetEvents(subject,day);

%%
cov_of_all_events = covFromCellArrayOfEvents(Events);
group1            = 1;
group2            = 2;
group1_cov        = cov_of_all_events(:,:,vClass == group1);
group2_cov        = cov_of_all_events(:,:,vClass == group2);
epsilon           = 1e-6;
max_iter          = 100;

mean1  = riemannianMean(group1_cov, epsilon, max_iter);
mean2  = riemannianMean(group2_cov, epsilon, max_iter);
dist11 = calcDistanceBetweenOneCovAndLotOfCov(mean1,group1_cov);
dist12 = calcDistanceBetweenOneCovAndLotOfCov(mean1,group2_cov);
dist21 = calcDistanceBetweenOneCovAndLotOfCov(mean2,group1_cov);
dist22 = calcDistanceBetweenOneCovAndLotOfCov(mean2,group2_cov);       

figure();
scatter(dist11,dist21);
hold on;
scatter(dist12,dist22,'d');
title("Reimanian Distance to Reimanian mean");
xlabel("reimanian Distance to mean1");
ylabel("reimanian Distance to mean2");