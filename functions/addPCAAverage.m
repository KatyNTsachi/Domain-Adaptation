function [cWithAverage] = addPCAAverage(cInput)
    %ADDAVERAGE Summary of this function goes here
    %   Detailed explanation goes here
    
    %calc mean of vClass == 1
    mat = cat(3, cInput{:});
    
    average_chanels = nan( size(mat, 1), size(mat, 2) );
    
   for chanel_num = 1 : size(mat, 2)
        
        tmp = squeeze(mat(:, chanel_num, :));
        eigen_vectors = pca(tmp');
        num_of_pca_vectors = 1;
        eigen_vectors_to_use = eigen_vectors(:, 1:num_of_pca_vectors);
        average_chanels(:, chanel_num) = mean(eigen_vectors_to_use, 2);
        
    end
     
    mean_1    = average_chanels;
    mean_diff = mean_1;
    %add mean to every cell

    
    %add mean to every cell
    cWithAverage = {};
    
    for data_i = 1:length(cInput)

        cWithAverage{data_i} = [cInput{data_i}, mean_diff];
        
    end
    
end

