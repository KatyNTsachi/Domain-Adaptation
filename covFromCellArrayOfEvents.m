function [covEvents] = covFromCellArrayOfEvents(Events)
    %COV Scalculates the covariances of a matrixs inside a cell array
    %EventsMat = cell2mat(Events);

    chanels_num = size(Events{1}, 2);
    covEvents   = nan(chanels_num, chanels_num, length(Events));

    for nn = 1 : length(Events)
        covEvents(:,:,nn) = cov(Events{nn});  
    end
end

