function [] = calcAndShowCov(data, title_to_show)
%CALCANDSHOWCOV Summary of this function goes here
%   Detailed explanation goes here
%% show cov matrix
cov = covFromCellArrayOfEvents({data});
figure();
colormap(jet);
hImg = pcolor(cov);
set(gca,'YDir','reverse' );
set(gca, 'XAxisLocation', 'top')
colorbar;
title(title_to_show);

end

