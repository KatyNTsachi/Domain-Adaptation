function [cWithAverage, c_input_test] = addPCAAverageOldDataTest(cInput, c_input_test, vClass)
    %ADDAVERAGE Summary of this function goes here
    %   Detailed explanation goes here
    
    %calc mean of vClass == 1
    
    
    mat = cat(3, cInput{:});
    
    downsampled_mat = downsample(mat, 2);

    average_chanels = nan( size(mat, 1), size(mat, 2) );
    for chanel_num = 1:size(cInput{1},2)
        tmp = squeeze(downsampled_mat(:, chanel_num, :));
        [eigen_vectors, ~, latent] = pca(tmp');
        num_of_pca_vectors = 3;
        eigen_vectors_to_use = eigen_vectors(:, 1:num_of_pca_vectors);
        projected = (tmp' * eigen_vectors_to_use)*eigen_vectors_to_use';
        tmp = mean(projected, 1);
        %average_chanels(:, chanel_num) = mean(projected, 1);
        tmp = upsample(tmp, 2);
        %tmp = upsample(mean(eigen_vectors_to_use, 2), 2);
        average_chanels(:, chanel_num) = tmp(1:end-1);
       
    end
     
    
    

    mean_1 = average_chanels;
    mean_0 = 0;

    %add mean to every cell
    cWithAverage = {};
    for data_i = 1:length(cInput)

        cWithAverage{data_i} = [cInput{data_i}, mean_0 - mean_1];

    end
    
    for data_i = 1:length(c_input_test)

        c_input_test{data_i} = [c_input_test{data_i}, mean_0 - mean_1];

    end

end

