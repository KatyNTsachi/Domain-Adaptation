function [c_data_with_const_fetures] = addGaussianWindowCannels(  c_data,...
                                                                                        sigma)
    
    windows_in_time = [];
    miu             = 1:74:750; 
    [N,D]           = size( c_data{1} );
    
    %-- create extra features
    ii = 1;
    x  = (1:1:N)';
    for ii = 1:length(miu)
        tmp               = normpdf(x,miu(ii),sigma);
        windows_in_time   = [windows_in_time, tmp];
        ii = ii + 1;
    end
    
    %-- put extra features in each cell
    c_data_with_const_fetures{length(c_data)}=[];
    for ii = 1:length(c_data)
        c_data_with_const_fetures{ii} = [c_data{ii},windows_in_time];
    end
end

