function [cWithAverage] = addAverage(cInput, vClass)
    %ADDAVERAGE Summary of this function goes here
    %   Detailed explanation goes here
    count_1 = 0;
    mean_1 = 0;
    cWithAverage = {};
    for data_i = 1:length(cInput)

        if vClass(data_i) == 1
            cell_i = cInput{data_i};
            count_1 = count_1 + 1;
            mean_1 = ((count_1-1)/count_1)*mean_1 + (1/count_1)*cell_i;
        end


    end


    for data_i = 1:length(cInput)

        cWithAverage{data_i} = [cInput{data_i}, mean_1];

    end

end

