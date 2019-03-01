function [c_spectorm] = getSTFTEventsWholeTime(Events, vClass)
    N = length(Events);
    num_of_chanals = size(Events{1},2);
    F_Events{N} = [];
    F_Events = Events;

    time_samples = Events{1};
    windows_size  = 10;
    kron_kernal = ones( windows_size, 1); 
    for ii=1:N
        m_spectrom = [];
        time_samples = Events{ii};
        for jj = 1 : size(time_samples, 2)
            tmp_time_vec   = time_samples(:,jj);
            tmp            = abs( spectrogram( tmp_time_vec, windows_size, 0 ) );
            tmp( int32( 0.7 * size(tmp,1) ) : end, : ) = [] ;
            tmp = tmp';
            tmp = kron( tmp, kron_kernal );
            m_spectrom = [ m_spectrom, tmp];
            %[a,tmp_spec]   = max(tmp, [], 2);
            %m_spectrom     = [m_spectrom, tmp_spec];
        end 
        c_spectorm{ii} = m_spectrom;
    end
end


