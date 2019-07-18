function [cWithAverage1, cWithAverage2] = addPCAAverageTest(cInput1, cInput2, vClass1, vClass2)
    %ADDAVERAGE Summary of this function goes here
    %   Detailed explanation goes here
    
    %calc mean of vClass == 1
    all_cInput = {cInput1{:}, cInput2{:}};
    mat = cat(3, all_cInput{:});
    
    average_chanels = nan( size(mat, 1), size(mat, 2) );
    
   for chanel_num = 1 : size(mat, 2)
        
        tmp = squeeze(mat(:, chanel_num, :));
        eigen_vectors = pca(tmp');
        num_of_pca_vectors = 10;
        eigen_vectors_to_use = eigen_vectors(:, 1:num_of_pca_vectors);
        average_chanels(:, chanel_num) = mean(eigen_vectors_to_use, 2);
        
    end
     
    mean_1    = average_chanels;
    mean_diff = mean_1;
    %add mean to every cell

    
    %add mean to every cell
    cWithAverage1 = {};
    cWithAverage2 = {};
    
    for data_i = 1:length(cInput1)

        cWithAverage1{data_i} = [cInput1{data_i}, mean_diff];
        
    end
    for data_i = 1:length(cInput2)

        cWithAverage2{data_i} = [cInput2{data_i}, mean_diff];
        
    end


end

