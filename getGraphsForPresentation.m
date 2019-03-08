close all
clear
addpath("./functions/")

%% --prepare for calc 

day               = 1;
subject           = 8;
[Events, vClass]  = GetEvents( subject, day );
N                 = length(Events);

%% doing covariance correlation and partial correlation
c_data_for_classifier  = {};
c_description_for_data = {};

% funcs       = { @covFromCellArrayOfEvents, @correlationFromCellArrayOfEvents, @partialCorrelationFromCellArrayOfEvents };
% funcs_names = { "Covariance"             , "Correlation"                    , "Partial Correlation"  };
funcs       = { @covFromCellArrayOfEvents};
funcs_names = { "Covariance"             };

%events_names    = { "on split time series", "on split furier series", "on split stft series"};          
%events_cell     = { Events_split_time     , Fureiet_split_time      ,  STFTEvents_split_time};

events_names    = {" on time series "};          
events_cell     = { Events           };


%set base functions
% all_base_functions = ["linear", "gaussian", "polynomial"];
all_base_functions = ["linear"];

%extract the features
[c_data_for_classifier, c_description_for_data] = extractFeatures( events_cell, events_names,...
                                                                   funcs, funcs_names, vClass );

 %% ahow tsne
showTSNE(  c_data_for_classifier, vClass, c_description_for_data );

%% show all waves seperatly

figure()

num_chanels_to_show = 5;
colormap jet;
cmap=colormap;
tmp_cmap = [cmap(10,:);cmap(20,:);cmap(33,:);cmap(45,:);cmap(50,:)];


for ii = 1:num_chanels_to_show
    %tmp_color = mod(ii*10,64);
    Plot_color=tmp_cmap(ii,:);   
    subplot(num_chanels_to_show,1,ii);
    plot(Events{1}(:,ii), 'Color', Plot_color);
    if ii == num_chanels_to_show
        xlabel('time', 'FontSize',22);
    end
end

%% show all waves in one plot
figure()
plot(Events{1}(100:350,:))

%% show cov matrix
cov = covFromCellArrayOfEvents({Events{1}});
figure()
colormap(jet);
pcolor(cov);
colorbar;
%imshow(cov,[])

