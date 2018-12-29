function [covEvents] = covFromCellArrayOfEvents(Events)
    %COV Scalculates the covariances of a matrixs inside a cell array
    %EventsMat = cell2mat(Events);

    chanels_num = size(Events{1});
    chanels_num = chanels_num(2);
    covEvents = zeros(chanels_num,chanels_num,length(Events));

    parfor n = 1:length(Events)
        covEvents(:,:,n)=cov(Events{n});  
    end
end

