function [ret_p] = projectToRiemannianSpace(P,S_array)
    %p is the point in which we create the tangent plane
    %s is the projection of the point from the riemannian plane
    %return p = ExpMap_P(s)
    
    %%prepare for loop
    p_pow_half       = P^(1/2);
    p_minus_pow_half = P^(-1/2);
    num_of_matrics   = size(S_array,3);
    ret_p            = nan( size(S_array) );
    
    %%
    parfor ii=1:num_of_matrics
        tmp_s         = S_array(:,:,ii);
        in_exp        = p_minus_pow_half*tmp_s*p_minus_pow_half;
        exp_mat       = expm(in_exp);
        ret_p(:,:,ii) = p_pow_half*exp_mat*p_pow_half;
    end

end
