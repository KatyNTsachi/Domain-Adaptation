function [corEvents] = partialCorrelationFromCellArrayOfEvents(Events)
    %COV Scalculates the covariances of a matrixs inside a cell array
    %EventsMat = cell2mat(Events);

    chanels_num = size(Events{1}, 2);
    corEvents   = nan(chanels_num, chanels_num, length(Events));

    for nn = 1 : length(Events)
        corEvents(:,:,nn) = partialcorr(Events{nn});  
    end
end

