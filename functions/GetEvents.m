function [Events, vClass] = GetEvents(subject, day)

%     load BPF.mat;
    dirPath = '..\..\Dataset\';
%    dirPath = 'C:\Users\Oryair\Desktop\Workarea\BCI\BCICIV_2a_gdf\';
    
    if day == 1
        fileName    = ['A0', num2str(subject), 'T.gdf'];
        [mEEG, H]   = sload([dirPath, fileName]);
        mEEG        = mEEG(:,1:22); %-- reomving EOG, (EEG only)
        
        vClass = H.Classlabel; %-- class...
        vTrig  = H.TRIG;
    else
        fileName = ['A0', num2str(subject), 'E.gdf'];
        load([dirPath, fileName(1:end-3), 'mat']);
        
        [mEEG, H] = sload([dirPath, fileName]);
        mEEG      = mEEG(:,1:22); %-- reomving EOG, (EEG only)
        vClass    = classlabel;
        vTrig     = H.TRIG;
    end

    Fs  = 250;
    Ts  = 1 / Fs;
    vT  = 0 : Ts : 7; vT(end) = [];
    
    nFull    = length(vT);
    startIdx = find(vT == 3);
    endIdx   = find(vT == 6) - 1;

    vBPF = fir1(300, 2 / Fs * [8, 80]);
    
    vNanIdx         = isnan(sum(mEEG,2));
    mEEG(vNanIdx,:) = 0;
%     mEEG            = conv2(mEEG, BPF', 'same');
    mEEG            = conv2(mEEG, vBPF', 'same');
    
    for ii = 1 : 288
        mEvent = mEEG(vTrig(ii) : (vTrig(ii) + nFull - 1),:);
        mEvent = mEvent(startIdx : endIdx, :);
%         mEvent = mEvent ./ std(mEvent, [], 2);
        Events{ii} = mEvent;
    
    end
end