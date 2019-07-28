function [c_data_with_const_fetures] = addWaveletsChanels(c_data, w)
    
    %w size of windows
    windows_in_time = [];
    [N,D]           = size( c_data{1} );
    
    %-- create extra features
    ii = 1;
    while(true)
        tmp    = zeros(N,1);
        if mod(w,2)==0
            start  = (w/2)*(ii-1)+1;
            finish = (w/2)*(ii)+(w/2); 
        else
            start  = ( (w-1)/2 + 1 )*(ii-1) + 1;
            finish = ( (w-1)/2 + 1 )*(ii) + ((w-1)/2);
        end
        if start > N
            break;
        end
        if finish > N
            finish = N;
        end
        tmp(start:finish) = 2*N/(finish-start);
        windows_in_time   = [windows_in_time, tmp];
        ii = ii + 1;
    end
    
    %-- put extra features in each cell
    c_data_with_const_fetures{length(c_data)}=[];
    for ii = 1:length(c_data)
        c_data_with_const_fetures{ii} = [c_data{ii},windows_in_time];
    end
end

