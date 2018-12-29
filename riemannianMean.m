function [P] = riemannianMean(group_cov,step,epsilon,max_num_of_iter)
    d = 2*epsilon;
    j=0;
    [~,~,n] = size(group_cov);
    P = ones(n);
    delta = ones(n);
    S = projectToTangentSpace(P,group_cov);
    while d>epsilon && j<max_num_of_iter
        j=j+1;
        delta = step*(2*(S-P));
    end
end

