%this is main

day=1;
subject=1;
[Events, vClass] = GetEvents(subject,day);
cov_of_events=cov_from_cellarray_of_events(Events);