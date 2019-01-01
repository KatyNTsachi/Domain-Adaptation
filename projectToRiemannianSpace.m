function [ret_p] = projectToRiemannianSpace(p,s)
    %p is the point in which we create the tangent plane
    %s is the projection of the point from the riemannian plane
    %return p = ExpMap_P(s)
    
    %prepare for loop
    p_pow_half       = p^(0.5);
    p_minus_pow_half = p^(-0.5);
    
    %is it list of mat or just one?
    if size(size(s),2)==3
        ret_p          = nan( size(s) );
        num_of_matrics = size(s,3);
    else
        ret_p          = zeros( size(s) );
        num_of_matrics = 0;
    end
    
    if num_of_matrics~=0
        parfor ii=1:num_of_matrics
            tmp_s        = squeeze( s(:,:,ii) );
            in_exp       = p_minus_pow_half*tmp_s*p_minus_pow_half;
            exp_mat      = expm(in_exp);
            ret_p(:,:,ii) = p_pow_half*exp_mat*p_pow_half;
        end
    
    else
        in_exp     = p_minus_pow_half*s*p_minus_pow_half;
        exp_mat    = expm(in_exp);
        ret_p(:,:) = p_pow_half*exp_mat*p_pow_half;
    end

end
