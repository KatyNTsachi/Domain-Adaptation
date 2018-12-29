function [P] = riemannianMean(group_cov,step,epsilon,max_num_of_iter)
    d = 2*epsilon;
    j=0;
    [N,~,n] = size(group_cov);
    P = 0.1*rand(n,n);
    S = projectToTangentSpace(P,group_cov);
    while d>epsilon && j<max_num_of_iter
        delta = sum(S,1);
        delta = squeeze(delta);
        delta = 2*(delta - N*P);
        
        d = sum(delta,'all');
        P=P-step*delta;
        j=j+1;
    end
end

