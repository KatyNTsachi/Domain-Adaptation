function [corEvents] = partialCorrelationFromCellArrayOfEvents( Events )
    %partialCorrelation calc just the upper tirangle 
    %EventsMat = cell2mat(Events);

    chanels_num = size(Events{1}, 2);
    corEvents   = nan(chanels_num, chanels_num, length( Events ) );

    parfor nn = 1 : length(Events)
        corr_i                     = corrcoef(Events{nn});
        corEvents(:, :, nn)        = corr_i;
        corr_i_inv                 = inv( corr_i );
        diag_vec                   = sqrt(diag(corr_i_inv));
        dominator_mat              = diag_vec * diag_vec';
        corEvents(:, :, nn)        = - corr_i_inv( :, : ) ./ dominator_mat;
    end
    
end

