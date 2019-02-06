function [c_spectorm] = getSTFTEvents(Events, vClass)
    N = length(Events);
    num_of_chanals = size(Events{1},2);
    F_Events{N} = [];
    F_Events = Events;
%     parfor ii = 1 : N
%         F_Events{ii} = abs( fft( Events{ii} ) );
% % %     end
% %     for ii = 1 : N
% %         figure()
% %         num_of_chanals_to_show = 1
% %         for jj = 1 : num_of_chanals_to_show
% %             %subplot(num_of_chanals_to_show,1,jj);
% %             title(num2str(vClass(ii)));
% %             plot(F_Events{ii}(:, jj));
% %             hold on;
% %         end
% %     end
    time_samples = Events{1};
    windows_size  = 50;
    
    for ii=1:N
        m_spectrom = [];
        time_samples = Events{ii};
        for jj=1:22
            tmp_time_vec   = time_samples(:,jj);
            tmp            = abs(spectrogram( tmp_time_vec, windows_size));
            tmp( int32(0.7*size(tmp,1)) : end, : ) = [] ;
            m_spectrom(:,jj) = tmp(:);
            %[a,tmp_spec]   = max(tmp, [], 2);
            %m_spectrom     = [m_spectrom, tmp_spec];
        end 
        c_spectorm{ii} = m_spectrom;
    end
end


