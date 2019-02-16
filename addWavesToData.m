function [ c_data_for_classifier, c_description_for_data ] = addWavesToData(    c_data_for_classifier, c_description_for_data,...
                                                                                c_data_to_add_waves  , c_data_to_add_waves_description,...
                                                                                num_of_waves )
    
 
    for ii = 1 : length(c_data_to_add_waves)
        data_i     = c_data_to_add_waves{ii};
        events_num = length(data_i);

        %-- substract mean of original events
        c_data_zero_mean = {};
        for jj = 1: events_num
            c_data_zero_mean{jj} = data_i{jj} - mean(data_i{jj});
        end

        %-- add window in time features
        c_data_zero_mean_with_waves = addTimeWindowChanels( c_data_zero_mean, num_of_waves );

        %-- calc covarience
        chanels_num = size(c_data_zero_mean_with_waves{1}, 2);
        covEvents   = nan(chanels_num, chanels_num, events_num);
        covEvents = [];
        for nn = 1 : events_num
            covEvents(:,:,nn) = c_data_zero_mean_with_waves{nn}'*c_data_zero_mean_with_waves{nn};  
        end

        c_data_for_classifier{ length(c_data_for_classifier) + 1 }   = prepareForClassification( covEvents );
        c_description_for_data{ length(c_description_for_data) + 1 } = c_data_to_add_waves_description{ii};
    end

end