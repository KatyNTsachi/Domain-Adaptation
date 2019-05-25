function [Events, vClass] = getERPEvents(subject)
    
    path    = "../DATASET/new_dataset/data_training/subject_";

    path_X = path + num2str(subject) + "_X.npy";
    path_y = path + num2str(subject) + '_y.npy';

    tmp_Events = readNPY(path_X);
    vClass     = readNPY(path_y);

    % put each event in cell
    Events = {};
    for i=1:size(tmp_Events,1)
        Events{i} = squeeze( tmp_Events(i, :, :) )';
    end
end

