function [Events, vClass] = getERPEventsSpeller(subject)
    
    path    = "../../DATASET/new_dataset3/";

    path_X = path        + 'A0' + num2str(subject) + ".mat";
    path_y = path + "y_" + 'A0' + num2str(subject) + ".mat";
    
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

