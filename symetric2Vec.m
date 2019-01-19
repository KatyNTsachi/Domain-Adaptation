function [res_vec] = symetric2Vec(input_mat)
    %input  - symetric mat
    %output - upper triangle of the mat as vector
    %         and normalize

    %we want to extract the upper triangle pattern
    ones_size_of_input     = ones(size(input_mat,1),size(input_mat,2));
    pattern_for_upper      = triu( ones_size_of_input );
    pattern_for_upper_vec  = reshape(pattern_for_upper,[],1);
    
    %we want to extract the factor
    pattern_for_factor     = triu( ones_size_of_input, 1 );
    pattern_for_factor_vec = reshape(pattern_for_factor,[],1);
    
    %prepare for loop
    input_mat_vec = reshape( input_mat, size(input_mat,1) * size(input_mat,2), size(input_mat,3));
    res_vec       = zeros(sum(pattern_for_upper_vec),size(input_mat,3));
    
    parfor ii=1:size(input_mat,3)
        mat_i                            = input_mat(:,:,ii);
        vec_i                            = reshape(mat_i, [], 1);
        vec_i(pattern_for_factor_vec==1) = vec_i(pattern_for_factor_vec==1) * sqrt(2);
        vec_i_upper                      = vec_i( pattern_for_upper_vec==1 ) ;
        res_vec(:,ii)                    = vec_i_upper;
    end
end

