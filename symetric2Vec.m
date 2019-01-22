function [res_vec] = symetric2Vec(input_mat)
    % input  - symetric mat
    % output - upper triangle of the mat as vector
    %          and normalize

    D = size(input_mat, 1); %-- D - matrix dimension
    N = size(input_mat, 3); %-- N - number of matrcies
    
    %-- we want to extract the upper triangle pattern
    ones_size_of_input     = ones(D, D);
    pattern_for_upper      = triu(ones_size_of_input);
    pattern_for_upper_vec  = reshape(pattern_for_upper, [], 1);
    
    %-- we want to extract the factor
    pattern_for_factor     = triu(ones_size_of_input, 1);
    pattern_for_factor_vec = reshape(pattern_for_factor, [], 1);
    
    %-- prepare for loop
    input_mat_vec = reshape( input_mat, D * D, N);
    res_vec       = zeros(sum(pattern_for_upper_vec), N);
    
    parfor ii = 1 : N
        mat_i                            = input_mat(:,:,ii);
        vec_i                            = mat_i(:);
        vec_i(pattern_for_factor_vec==1) = vec_i(pattern_for_factor_vec==1) * sqrt(2);
        vec_i_upper                      = vec_i( pattern_for_upper_vec==1 ) ;
        res_vec(:,ii)                    = vec_i_upper;
    end
end

