function [res_vec] = symetric2VecWithoutDiag( input_symetric_tensor )
    %input  - input_symetric_tensor
    %output - upper triangle of the mat as vector
    %         and normalize
    
    D  = size(input_symetric_tensor, 1);
    N  = size(input_symetric_tensor, 3);
     
    %we want to extract the upper triangle pattern
    ones_size_of_input     = ones(D, D);
    pattern_for_upper      = triu( ones_size_of_input );

    %we want to extract the factor
    pattern_for_factor     = triu( ones_size_of_input, 1 );
    
    %prepare for loop
    res_vec = nan( sum( pattern_for_upper, 'all' ), N );
     
    parfor ii=1:N
        mat_i                        = input_symetric_tensor(:, :, ii);
        mat_i(pattern_for_factor==1) = mat_i( pattern_for_factor==1 ) * sqrt(2);
        res_vec(:,ii)                = mat_i( pattern_for_upper==1 );
    end
end

