function [cWithAverage1, cWithAverage2] = addPCAAverageOldDataTestTwoOptions(cInput, vClass)
    %ADDAVERAGE Summary of this function goes here
    %   Detailed explanation goes here
    
    %calc mean of vClass == 1
    
    
    mat = cat(3, cInput{:});
    
    average_chanels = nan( size(mat, 1), size(mat, 2) );
    
   for chanel_num = 1:size(cInput{1},2)
        
        tmp = squeeze(mat(:, chanel_num, :));
        [eigen_vectors, ~, latent] = pca(tmp');
        
%         tmp = 10;
%         figure();
%         subplot(3,1,1);
%         plot( eigen_vectors(:, 1:tmp) );
%         subplot(3,1,2);
%         plot( mean( eigen_vectors(:, 1:tmp), 2 ) );
%         subplot(3,1,3);
%         plot( mean( squeeze( mat(:, chanel_num,:) ), 2 ) );
        
        num_of_pca_vectors = 10;
        eigen_vectors_to_use = eigen_vectors(:, 1:num_of_pca_vectors);
        average_chanels(:, chanel_num) = mean(eigen_vectors_to_use, 2);
        
    end
     
    mean_1    = average_chanels;
    mean_0    = 0;
    mean_diff = mean_1 - mean_0;
    %add mean to every cell

    
    %add mean to every cell
    cWithAverage1 = {};
    cWithAverage2 = {};
    
    for data_i = 1:length(cInput)

        cWithAverage1{data_i} = [cInput{data_i}, mean_diff];
        cWithAverage2{data_i} = [cInput{data_i}, -mean_diff];
        
    end



end

