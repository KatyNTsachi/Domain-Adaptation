function [ret_distance] = calcDistanceBetweenCovMat(mean, group_cov)
%calcDistanceBetweenCovMat calc distance between 
%one cov mat and a lot of cov mat    
%
%   input       
%               mean         - cov matrix
%               group_cov    - tensor of cov mat
%   output    
%               ret_distance - 1D array of distances between every mat from
%               the mean
    
    N            = size(group_cov, 3);
    ret_distance = nan(N, 1);
    
    parfor ii=1 : N
        Pi               = group_cov(:,:,ii);
        %in_log          = inv_mean*tmp_cov;
        eig_value        = eig(Pi, mean); %eig(in_log);
        ret_distance(ii) = norm(log(eig_value))
    end
    
end

