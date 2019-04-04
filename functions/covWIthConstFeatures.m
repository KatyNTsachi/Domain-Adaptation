function [ c_data_for_classifier, c_description_for_data ] = covWIthConstFeatures(  c_data_to_add_waves  , c_data_to_add_waves_description,...
                                                                                    addConstFeaturesFunc ,params )
                                                                                
    idx = 1;
    
    for param = params
        for ii = 1 : length(c_data_to_add_waves)
            
            data_i     = c_data_to_add_waves{ii};
            events_num = length(data_i);

            %-- check if exists
            file_name = c_data_to_add_waves_description{ii}+"_"+func2str(addConstFeaturesFunc)+num2str(param); 
            file_path = "../data/" + file_name ;

            %-- if exists, load
            if exist( file_path + ".mat", 'file' )

                tmp = load(  file_path + ".mat" );
                res = tmp.res; 

            %-- if not, calc and save
            else
            %if true
            

                %-- substract mean of original events
                c_data_zero_mean = {};

                for jj = 1: events_num

                    c_data_zero_mean{jj} = data_i{jj} - mean(data_i{jj});

                end

                %-- add window in time features
                c_data_zero_mean_with_waves = addConstFeaturesFunc( c_data_zero_mean, param );

                %-- calc covarience
                chanels_num = size(c_data_zero_mean_with_waves{1}, 2);
                covEvents   = nan(chanels_num, chanels_num, events_num);
                covEvents = [];

                for nn = 1 : events_num

                    covEvents(:,:,nn) = c_data_zero_mean_with_waves{nn}'*c_data_zero_mean_with_waves{nn};  

                end
                
                            %-- show covarience
                figure()
                title(func2str(addConstFeaturesFunc));
                cov1 = covEvents(:,:,1);
                colormap(jet);
                ph = pcolor(cov1);
                ph.ZData = cov1;
                colorbar;
                % 

                res = prepareForClassification( covEvents );
                save( file_path + ".mat", 'res' );

            end

            %-- add to return cell array
            c_data_for_classifier{ idx }  = res;
            c_description_for_data{ idx } = file_name;
            idx = idx + 1;


            
        end
    end
end