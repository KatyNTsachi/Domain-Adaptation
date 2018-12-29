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
max_num_of_iter=100;

mean1=riemannianMean(group1_cov,step,epsilon,max_num_of_iter);
mean2=riemannianMean(group2_cov,step,epsilon,max_num_of_iter);
dist1=calcDistanceBetweenOneCovAndLotOfCov(mean1,group1_cov);
dist2=calcDistanceBetweenOneCovAndLotOfCov(mean2,group2_cov);       %need to implement