function [Events] = splitInTime(Events, window_size)
    %SPLITINTIME Summary of this function goes here
    %   Detailed explanation goes here
   
    for ii = 1:length(Events)
        Events{ii} = reshape(Events{ii}, window_size, []);
    end
end

