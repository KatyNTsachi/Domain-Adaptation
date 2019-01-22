function [corEvents] = partialCorrelationFromCellArrayOfEvents( Events )
    %partialCorrelation calc just the upper tirangle 
    %EventsMat = cell2mat(Events);

    chanels_num = size(Events{1}, 2);
    corEvents   = nan(chanels_num, chanels_num, length( Events ) );

    for nn = 1 : length(Events)
        corr_i              = corrcoef(Events{nn});
        corEvents(:, :, nn) = corr_i;
        corr_i_inv          = inv( corr_i );
        for row = 1 : chanels_num
           for column = 1 : chanels_num  
               corEvents(row, column, nn) = - corr_i_inv( row, column )/ sqrt( corr_i_inv(row,row) * corr_i_inv(column,column) );
           end
        end
    end
    
end

