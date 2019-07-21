function [Events, vClass] = getCVEPEvents(subject, session)
    
    path    = "../../DATASET/dataset_CVEP/";

    path_X = path + "subject" + num2str(subject) + "_session" + num2str(session) + ".mat";
    
    tmp_Events = load(path_X);
    vClass     = tmp_Events.data_y;
    tmp_Events = tmp_Events.data_x;
      
    %remove mean 
    tmp_Events = tmp_Events - mean(tmp_Events, 3);
    
    %two classes
    vClass = (vClass >= 1 & vClass <= 15) + 1;
    
    % put each event in cell
    Events = {};

    for ii = 1 : size(tmp_Events,1)
        
        Events{ii} = squeeze( tmp_Events(ii, :, :) )';
        
    end
end

