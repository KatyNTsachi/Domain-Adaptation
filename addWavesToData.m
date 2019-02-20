function [ c_data_for_classifier, c_description_for_data ] = addWavesToData(    c_data_for_classifier, c_description_for_data,...
                                                                                c_data_to_add_waves  , c_data_to_add_waves_description,...
                                                                                waves_size )
    for wave_size = waves_size
        
        for ii = 1 : length(c_data_to_add_waves)

            data_i     = c_data_to_add_waves{ii};
            events_num = length(data_i);

            %-- check if exists
            file_name = c_data_to_add_waves_description{ii} + "wave size" + num2str(wave_size); 
            file_path = "../data/" + file_name ;

            %-- if exists, load
            if exist( file_path + ".mat", 'file' )

                tmp = load(  file_path + ".mat" );
                res = tmp.res; 

            %-- if not, calc and save
            else

                %-- substract mean of original events
                c_data_zero_mean = {};

                for jj = 1: events_num

                    c_data_zero_mean{jj} = data_i{jj} - mean(data_i{jj});

                end

                %-- add window in time features
                c_data_zero_mean_with_waves = addTimeWindowChanels( c_data_zero_mean, waves_size );

                %-- calc covarience
                chanels_num = size(c_data_zero_mean_with_waves{1}, 2);
                covEvents   = nan(chanels_num, chanels_num, events_num);
                covEvents = [];

                for nn = 1 : events_num

                    covEvents(:,:,nn) = c_data_zero_mean_with_waves{nn}'*c_data_zero_mean_with_waves{nn};  

                end

                res = prepareForClassification( covEvents );
                save( file_path + ".mat", 'res' );

            end

            %-- add to return cell array
            c_data_for_classifier{ length(c_data_for_classifier) + 1 }   = res;
            c_description_for_data{ length(c_description_for_data) + 1 } = c_data_to_add_waves_description{ii};

        end
    end
end