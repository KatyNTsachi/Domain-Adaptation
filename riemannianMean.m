function [P] = riemannianMean(group_cov,step,epsilon,max_num_of_iter)
    d = 2*epsilon;
    j=0;
    [N,~,n] = size(group_cov);
    P = mean(group_cov,1);
    P=squeeze(P);
    %S = projectToTangentSpace(P,group_cov);
    while d>epsilon && j<max_num_of_iter
        %delta = sum(S,1);
        %delta = squeeze(delta);
        %delta = 2*(delta - N*P);
        
        S = projectToTangentSpace(P,group_cov);
        S_mean = mean(S,1);
        S_mean=squeeze(S_mean);
        P = projectToRiemannianSpace(P,S_mean);
        
        tmp_dist=calcDistanceBetweenOneCovAndLotOfCov(P,group_cov);
        j=j
        tmp_dist=sum(tmp_dist)
        
        d = det(P*P');
        %P=P-step*delta;
        j=j+1;
    end
end

