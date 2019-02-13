function [ c_combine_data, c_description ] = combineFeatures( c_short_classifier )

    tmp            = [];
    idx            = 1;
    c_combine_data = {};
    c_description  = {};

    for ii = 1 : length(c_short_classifier)

            for jj = ii+1 : length(c_short_classifier)

                c_combine_data{idx} = [ c_short_classifier{ii}; c_short_classifier{jj} ];
                c_description{idx}  = idx;
                idx                 = idx + 1;

            end
    end

    for ii = 1 : length(c_short_classifier)

        for jj = ii+1 : length(c_short_classifier)

            for kk = jj + 1 : length(c_short_classifier)

                c_combine_data{idx} = [ c_short_classifier{ii}; c_short_classifier{jj};c_short_classifier{kk} ];
                c_description{idx}  = idx;
                idx                 = idx + 1;

            end 

        end

    end
    for ii = 1 : length(c_short_classifier)

        for jj = ii+1 : length(c_short_classifier)

            for kk = jj + 1 : length(c_short_classifier)

                for ll = kk + 1 : length(c_short_classifier)
                    
                    c_combine_data{idx} = [ c_short_classifier{ii}; c_short_classifier{jj}; c_short_classifier{kk}; c_short_classifier{ll} ];
                    c_description{idx}  = idx;
                    idx                 = idx + 1;
                    
                end 

            end 

        end

    end
    
    for ii = 1 : length(c_short_classifier)

        for jj = ii+1 : length(c_short_classifier)

            for kk = jj + 1 : length(c_short_classifier)

                for ll = kk + 1 : length(c_short_classifier)
                    
                    for mm = ll + 1 : length(c_short_classifier)
                        
                        c_combine_data{idx} = [ c_short_classifier{ii}; c_short_classifier{jj}; c_short_classifier{kk}; c_short_classifier{ll}; c_short_classifier{mm} ];
                        c_description{idx}  = idx;
                        idx                 = idx + 1;
                        
                    end
                end 

            end 

        end

    end

end

 