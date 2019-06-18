function [cWithAverage] = addDiffrenceAverageOldData(cInput, vClass)
    %ADDAVERAGE Summary of this function goes here
    %   Detailed explanation goes here
    
    %calc mean of vClass == 1
    mat = cat(3, cInput{:});
    mean_1 = mean(mat(:, :, vClass==1 ), 3);
    mean_0 = mean(mat(:, :, vClass==2 ), 3);

    
    %add mean to every cell
    cWithAverage = {};
    for data_i = 1:length(cInput)

        cWithAverage{data_i} = [cInput{data_i}, mean_0 - mean_1];

    end

end

