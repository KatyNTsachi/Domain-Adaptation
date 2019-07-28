close all
clear
addpath("./functions")

%% prepare for calc 
day               = 1;
subject           = 8;
[Events, vClass]  = GetEvents( subject, day );

%% - add waves
%% extend data rectangular wave

                               
c_data_for_classifier_with_wavelets = covWIthConstFeatures( Events );
% figure();
% plot(c_data_for_classifier_with_wavelets{1});

%% - show cov
cov_res = covFromCellArrayOfEvents(c_data_for_classifier_with_wavelets);

figure()
colormap(jet);
hImg = pcolor(cov_res(:, :, 1));
set(gca,'YDir','reverse' );
colorbar;
title('Cov with Wavelets');
%% - show waves
num_chanels_to_show = 5;
colormap jet;
cmap=colormap;
tmp_cmap = [cmap(10,:);cmap(20,:);cmap(60,:);cmap(45,:);cmap(50,:)];
%tmp_cmap= cmap;

idx=[1,2,28,25,26];

tmp_ii = 1; 
for ii = idx
    %tmp_color = mod(ii*10,64);
    Plot_color=tmp_cmap(mod(tmp_ii,5) + 1,:);   
    subplot(num_chanels_to_show,1,tmp_ii);
    plot(c_data_for_classifier_with_wavelets{1}(:,ii), 'Color', Plot_color,'LineWidth',2);
    set(gca,'xtick',[])
    set(gca,'ytick',[])
    if tmp_ii == num_chanels_to_show
        xlabel('time', 'FontSize',44);
    end
    tmp_ii = tmp_ii + 1;
end



%% doing covariance correlation and partial correlation
c_data_for_classifier  = {};
c_description_for_data = {};

funcs       = { @covFromCellArrayOfEvents};
funcs_names = { "Covariance"             };



events_names    = { 
                    "on time series",...
                    "wavelets"      ,...
                  };

events_cell     = { 
                    Events                             ,...
                    c_data_for_classifier_with_wavelets,...
                  };



%set base functions
all_base_functions = ["linear"];

%extract the features
[c_data_for_classifier, c_description_for_data] = extractFeatures( events_cell, events_names,...
                                                                   funcs, funcs_names );

                                                               


%% calc svm
table_to_show = [];
table_to_show = calcSvmLossTnV( c_data_for_classifier , vClass,...
                                c_description_for_data, table_to_show);

