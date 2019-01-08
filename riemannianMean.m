function P = riemannianMean(group_cov, epsilon, max_iter)

    P = mean(group_cov, 3);

    for jj = 1 : max_iter
        S        = projectToTangentSpace(P, group_cov);
        S_mean   = mean(S, 3);
        P        = projectToRiemannianSpace(P, S_mean);

        if norm(S_mean, 'fro') < epsilon
            break;
        end
    end
end

