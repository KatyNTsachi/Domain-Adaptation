function [cWithAverage] = addClusterAverage(Events, vClass)
    
    %calc mean of vClass == 1
    mat = cat(3, Events{:});
    C   = customKmean(mat, @initTag, vClass);
    mean_1 = C(:, :, 1);
    mean_0 = C(:, :, 2);

    %add mean to every cell
    cWithAverage = {};
    for data_i = 1:length(Events)
        cWithAverage{data_i} = [Events{data_i}, mean_0 - mean_1];

    end
end

