function [ret_p] = projectToRiemannianSpace(p,s)
    %p is the point in which we create the tangent plane
    %s is the projection of the point from the riemannian plane
    p_pow_half=mpower(p,0.5);
    p_minus_pow_half=mpower(p,-0.5);
    in_exp=p_minus_pow_half*s*p_minus_pow_half;
    exp_mat=expm(in_exp);
    ret_p=p_pow_half*exp_mat*p_pow_half;
end