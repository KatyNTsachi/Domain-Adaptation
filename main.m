%this is main

day=1;
subject=1;
[Events, vClass] = GetEvents(subject,day);
cov_of_all_events=covFromCellArrayOfEvents(Events);
group1=1;
group2=2;
group1_cov=getCovOfGroup(cov_of_all_events,vClass,group1);          %need to implement
group2_cov=getCovOfGroup(cov_of_all_events,vClass,group2);

mean1=riemannianMean(group1_cov,step,epsilon,max_num_of_iter);
mean2=riemannianMean(group2_cov,step,epsilon,max_num_of_iter);
dist1=calcDistanceBetweenOneCovAndLotOfCov(mean1,group1_cov);
dist2=calcDistanceBetweenOneCovAndLotOfCov(mean2,group2_cov);       %need to implement