%this is main

day=1;
subject=1;
[Events, vClass] = GetEvents(subject,day);
cov_of_all_events=cov_from_cellarray_of_events(Events);
group1_cov;
P1=riemannianMean(group1_cov,step,epsilon,max_num_of_iter);
P2=riemannianMean(group2_cov,step,epsilon,max_num_of_iter);