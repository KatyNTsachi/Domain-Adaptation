function [ret_p] = projectToTangentSpace(P, P_arrray)
    %p is the point in which we create the tangent plane
    %pi the point on the riemannian manifold
    %return S_i = LogMap_P(Pi)

    %%prepare for loop
    p_pow_half       = P^(1/2);
    p_minus_pow_half = P^(-1/2);
    num_of_matrics   = size(P_arrray,3);
    ret_p            = nan( size(P_arrray) );
    
    %%
    for ii=1:num_of_matrics
        tmp_pi        = P_arrray(:,:,ii);
        in_log        = p_minus_pow_half * tmp_pi * p_minus_pow_half;
        log_mat       = logm(in_log);
        ret_p(:,:,ii) = p_pow_half * log_mat * p_pow_half;
    end
    
end
backup_M = table_to_show
save pca_results_CVEP_dataset table_to_show;

load 'pca_results_CVEP_dataset'
