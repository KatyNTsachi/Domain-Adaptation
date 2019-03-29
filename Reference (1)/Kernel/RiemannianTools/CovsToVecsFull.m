function LogCovs = CovsToVecsFull(Covs, mMean)

    if nargin == 2
        mRiemannianMean = mMean;
    else
        mRiemannianMean = RiemannianMean(cat(3, Covs{:}));
    end
    
    mCSR            = mRiemannianMean^(-1/2);
    
    K       = size(Covs, 3);
    D       = size(Covs, 1);
    LogCovs = Covs;
    
    for kk = 1 : K
        LogCovs{kk} = logm(mCSR * Covs{kk} * mCSR);
    end
       
end