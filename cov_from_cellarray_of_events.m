function [covEvents] = cov_from_cellarray_of_events(Events)
%COV Scalculates the covariances of a matrixs inside a cell array
%EventsMat = cell2mat(Events);
%size(EventsMat)
chanels_num = size(Events{1});
chanels_num = chanels_num(2);
covEvents = zeros(length(Events),chanels_num,chanels_num);

parfor n = 1:length(Events)
    covEvents(n,:,:)=cov(Events{n});  
end

%covEvents = Events;
end

