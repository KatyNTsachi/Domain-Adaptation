function [Events, vClass] = getERPEvents(subject, session)
    
    path    = "../../DATASET/new_dataset2/";

    path_X = path        + num2str(subject) + "session_" + num2str(session) + ".mat";
    path_y = path + "y_" + num2str(subject) + "session_" + num2str(session) + ".mat";
    
    tmp_Events = load(path_X);
    vClass     = load(path_y);

    tmp_Events = tmp_Events.X;
    vClass     = vClass.y';
    vClass     = vClass + 1;
    
    % put each event in cell
    Events = {};
    for ii = 1:size(tmp_Events,1)
        Events{ii} = squeeze( tmp_Events(ii, :, :) )';
    end
end

