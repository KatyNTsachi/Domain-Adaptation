function [ret_p] = projectToTangentSpace(p,pi)
    %p is the point in which we create the tangent plane
    %pi the point on the riemannian plane
    %we return the projectToTangentSpace
    p_pow_half=mpower(p,0.5);
    p_minus_pow_half=mpower(p,-0.5);
    in_log=p_minus_pow_half*pi*p_minus_pow_half;
    log_mat=logm(in_log);
    ret_p=p_pow_half*log_mat*p_pow_half;
end