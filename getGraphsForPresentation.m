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

 %% show tsne
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
    set(gca,'xtick',[])
    set(gca,'ytick',[])
    if ii == num_chanels_to_show
        xlabel('time', 'FontSize',44);
    end
end

%% show all waves in one plot
figure()
plot(Events{1}(100:350,:))

%% show a permutation of the waves

%-- get a specific event and substract the mean
x = Events{1};
x = x - mean(x);
%-- create permutation matrix
[length,~] = size(x);
p = eye(length);
p = p(randperm(length), :);
%-- create permutation
permutation = p*x;
%-- show permutation


figure()
subplot(2,1,1)
plot(x)
set(gca,'xtick',[])
set(gca,'ytick',[])
title("Original",'FontSize',22)

subplot(2,1,2)
plot(permutation)
set(gca,'xtick',[])
set(gca,'ytick',[])
title("Permutation", 'FontSize',22)
xlable("time", 'FontSize',22)

%-- show cov
cov_permutation = (permutation')*(permutation);
cov             = x'*x;


figure()
colormap(jet);
pcolor(cov);
title("Covarience Of Signals", 'FontSize',22)

%% show cov matrix
cov = covFromCellArrayOfEvents({Events{1}});
figure()
colormap(jet);
pcolor(cov);
colorbar;
%imshow(cov,[])


%% show class in time

%- separate the classes
ccEvents={};
ccEvents{1} = {};
ccEvents{2} = {};
ccEvents{3} = {};
ccEvents{4} = {};
for ii=1:length(Events)
    ccEvents{vClass(ii)}{end+1} = Events{ii};
end    

%-show

figure()

num_of_chanel_to_show = 5;
num_exp_to_show = 5;
colormap jet;
cmap=colormap;
tmp_cmap = [cmap(10,:);cmap(33,:);cmap(45,:);cmap(50,:)];


for ii = 1:4
    Plot_color=tmp_cmap(ii,:);
    tmp = ccEvents{ii};
    for jj=1:num_exp_to_show   
        subplot(4,num_exp_to_show,(ii-1)*num_exp_to_show + jj);
        tmp2 = tmp{jj};
        %tmp2 = mean(tmp2,2);
        tmp2 = tmp2(:,num_of_chanel_to_show);
        plot(tmp2, 'Color', Plot_color);
    end
%     if ii == 4
%         xlabel('time', 'FontSize',22);
%     end
%     if ii == 1
%         title("expiriment: " + num2str(num_of_exp_to_show));
%     end
end

%% show cov mat of image and permutation

N=100;
y = 1:N;

figure();
subplot(2,1,1);
bar(y,y);
ylabel('value');
xlabel('time');

hold on;
subplot(2,1,2);
new_idx = randperm(N)
bar(y(new_idx));
ylabel('value');
xlabel('time');


%% show all waves and cov with waves
w = 100;
tmp = Events{1} - mean(Events{1},1);
Events_waves = addTimeWindowChanels({tmp}, w);


figure()

num_chanels_to_show = 5;
colormap jet;
cmap=colormap;
tmp_cmap = [cmap(10,:);cmap(20,:);cmap(60,:);cmap(45,:);cmap(50,:)];
%tmp_cmap= cmap;

idx=[1,2,24,31,32];
tmp_ii = 1; 
for ii = idx
    %tmp_color = mod(ii*10,64);
    Plot_color=tmp_cmap(tmp_ii,:);   
    subplot(num_chanels_to_show,1,tmp_ii);
    plot(Events_waves{1}(:,ii), 'Color', Plot_color,'LineWidth',2);
    set(gca,'xtick',[])
    set(gca,'ytick',[])
    if tmp_ii == num_chanels_to_show
        xlabel('time', 'FontSize',44);
    end
    tmp_ii
    tmp_ii = tmp_ii + 1;
end

wave_cov = Events_waves{1}'*Events_waves{1};
figure()
colormap(jet);
pcolor(wave_cov);

