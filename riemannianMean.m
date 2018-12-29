function [P] = riemannianMean(group_cov,step,epsilon,max_num_of_iter)
    d = 2*epsilon;
    j=0;
    [~,n,N] = size(group_cov);
    P = mean(group_cov,3);

    while d>epsilon && j<max_num_of_iter
        S = projectToTangentSpace(P,group_cov);
        S_mean = mean(S,3);
        P = projectToRiemannianSpace(P,S_mean);
        tmp_dist=calcDistanceBetweenOneCovAndLotOfCov(P,group_cov);
        d = det(P*P');
        
        %debug print
        %j=j
        %tmp_dist=sum(tmp_dist)
        
        j=j+1;
    end
end

