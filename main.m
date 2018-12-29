%this is main

day=1;
subject=1;
[Events, vClass] = GetEvents(subject,day);
cov_of_all_events=covFromCellArrayOfEvents(Events);
group1=1;
group2=2;
group1_cov=cov_of_all_events(vClass==group1,:,:);
group2_cov=cov_of_all_events(vClass==group2,:,:);
step=1e-4;
epsilon=1;
max_num_of_iter=1000;

mean1=riemannianMean(group1_cov,step,epsilon,max_num_of_iter);
mean2=riemannianMean(group2_cov,step,epsilon,max_num_of_iter);
dist11=calcDistanceBetweenOneCovAndLotOfCov(mean1,group1_cov);
dist12=calcDistanceBetweenOneCovAndLotOfCov(mean1,group2_cov);
dist21=calcDistanceBetweenOneCovAndLotOfCov(mean2,group1_cov);
dist22=calcDistanceBetweenOneCovAndLotOfCov(mean2,group2_cov);       



% dist 12 is the distance of group 2 to center of group 1
% dist11 = [0,0,0,0];
% dist12 = [2,3,3,4];
% dist21 = [2,3,3,4];
% dist22 = [1,2,3,3];

figure();
scatter(dist11,dist21);
hold on;
scatter(dist12,dist22,'d');
title("Reimanian Distance to Reimanian mean");
xlabel("reimanian Distance to mean1");
ylabel("reimanian Distance to mean2");