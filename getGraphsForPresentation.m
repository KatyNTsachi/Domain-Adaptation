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
                                                                   funcs, funcs_names );

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
[length_var,~] = size(x);
p = eye(length_var);
p = p(randperm(length_var), :);
%-- create permutation
permutation = p*x;
%-- show permutation


figure()
subplot(2,1,1)
plot(x(1:100,:))
set(gca,'xtick',[])
set(gca,'ytick',[])
title("X",'FontSize',22)

subplot(2,1,2)
plot(permutation(1:100,:))
set(gca,'xtick',[])
set(gca,'ytick',[])
title("P", 'FontSize',22)
xlabel("time", 'FontSize',22)

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
hImg = pcolor(cov);
set(gca,'YDir','reverse' );
set(hAxes,'YDir','reverse')
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


figure();

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
figure();


colormap(jet);


pcolor(wave_cov);
set(gca,'YDir','reverse' );
set(hAxes,'YDir','reverse');

%% - first dataset-mean
day               = 3;
subject           = 1;
[Events, vClass]  = getERPEvents( subject, day );
% [Events, vClass] = getERPEvents(subject, sess);

Events_with_mean = addAverage(Events, vClass);
m = Events_with_mean{1}(:,17:32);
f = figure();
plot( m );
set(gca,'xtick',[], 'FontSize', 40)
% set(gca,'ytick',[])
title('Average of target', 'FontSize', 50);
% title('Average of target', 'FontSize', 32);
xlabel('time', 'FontSize', 40);
xlim ([1 513]);

%% - seccond dataset
day               = 1;
subject           = 8;
[Events, vClass]  = GetEvents( subject, day );
% [Events, vClass] = getERPEvents(subject, sess);

Events_with_mean = addAverage(Events, vClass);
m = Events_with_mean{1}(:,23:44);
f = figure();
plot( m );
set(gca,'xtick',[], 'FontSize', 40)
% set(gca,'ytick',[])
% title('Average of target', 'FontSize', 50);
title('Average of Non-target', 'FontSize', 50);

xlabel('time', 'FontSize', 40);
xlim ([1 513]);


%% show TSNE of one session with mean
% -get events 1 
subject1 = 16;
sess1    = 1;

epsilon = 0.01;
max_iter = 100;

[Events1, vClass1]  = getERPEvents(subject1, sess1);
% Events1             = addDiffrenceAverage(Events1, vClass1);
% Events1             = addPCAAverage(Events1);

cov1                = covFromCellArrayOfEvents(Events1);
% mean_of_cov1 = riemannianMean(cov1, epsilon, max_iter);

% cov_transformed = covFromCellArrayOfEvents(Events1_transformed);

tmp_cov = cov1;
flattened_cov = prepareForClassification(tmp_cov, false);
tsne_points = tsne(flattened_cov');
% tsne_points = pca(flattened_cov,'NumComponents', 2);

vClass_one = vClass1;


figure();
scatter( tsne_points(vClass_one == 1, 1), tsne_points(vClass_one == 1, 2), 500, 'r', 'filled', 'MarkerEdgeColor', 'k' );
hold on;
scatter( tsne_points(vClass_one == 2, 1), tsne_points(vClass_one == 2, 2), 500, 'y', 'filled', 'MarkerEdgeColor', 'k' );

legend( 'subject 1 non-target',...
        'subject 1 target'    ,...
        'FontSize'            ,...
        25);
title('TSNE - one session','FontSize', 30 );
% title('PCA','FontSize', 30 );

set(gca,'xtick',[]);

set(gca,'ytick',[]);
axis off


%% show PCA of two sessions
% -get events 1 
subject1 = 1;
sess1    = 1;
subject2 = 1;
sess2    = 2;

epsilon = 0.01;
max_iter = 100;

[Events1, vClass1]  = getERPEvents(subject1, sess1);
% -get events 2
[Events2, vClass2]  = getERPEvents(subject2, sess2);
% Events2             = addPCAAverage(Events2);
[~, Events2]        = addDiffrenceAverageOldDataTest(Events1, Events2, vClass1);
% Events2             = addDiffrenceAverage(Events2,vClass2);
% [Events1, Events2]         = addPCAAverageOldDataTest(Events1, Events2);


% [~, Events2]         = addPCAAverageOldDataTest(Events1, Events2);
% Events1             = addPCAAverage(Events1);
Events1             = addDiffrenceAverage(Events1, vClass1);

cov1                = covFromCellArrayOfEvents(Events1);
mean_of_cov1        = riemannianMean(cov1, epsilon, max_iter);



cov2 = covFromCellArrayOfEvents(Events2);
mean_of_cov2 = riemannianMean(cov2, epsilon, max_iter);

% % -transorm events 1 to events 2
% T = ( mean_of_cov2 * ( (mean_of_cov1)^(-1) ) ) ^ (1 / 2);
% Events1_transformed = {};
% for ii = 1 : length(Events1)
%     Events1_transformed{ii} = (T * Events1{ii}')';
% end

% cov_transformed = covFromCellArrayOfEvents(Events1_transformed);


% before
tmp_cov = cat(3, cov1, cov2);
flattened_cov = prepareForClassification(tmp_cov, false);
tsne_points = tsne(flattened_cov');
% tsne_points = pca(flattened_cov, 'NumComponents', 2);

vClass_one = zeros(size(flattened_cov, 2), 1);
vClass_one = cat(1, vClass1, vClass2 + 2 );
class_1 = 1;
class_2 = 2;

figure();
scatter( tsne_points(vClass_one == 1, 1), tsne_points(vClass_one == 1, 2), 500, 'r', 'filled', 'MarkerEdgeColor', 'k' );
hold on;
scatter( tsne_points(vClass_one == 2, 1), tsne_points(vClass_one == 2, 2), 500, 'y', 'filled', 'MarkerEdgeColor', 'k' );
hold on;
scatter( tsne_points(vClass_one == 3, 1), tsne_points(vClass_one == 3, 2), 500, 'b', 'filled', 'MarkerEdgeColor', 'k' );
hold on;
scatter( tsne_points(vClass_one == 4, 1), tsne_points(vClass_one == 4, 2), 500, 'g', 'filled', 'MarkerEdgeColor', 'k' );

legend( 'subject 1 non-target',...
        'subject 1 target'    ,...
        'subject 2 non-target',...
        'subject 2 target'    ,...
        'FontSize'            ,...
        20);
title('TSNE - different sessions train mean','FontSize', 36 );
set(gca,'xtick',[]);
set(gca,'ytick',[]);
axis off

%                 %after
%                 tmp_cov = cat(3, cov_transformed, cov2);
%                 flattened_cov = prepareForClassification(tmp_cov);
%                 tsne_points = tsne(flattened_cov');
%                 vClass_one = zeros(size(flattened_cov, 2), 1);
%                 vClass_one(1:size(cov2,3)) = 1;
%                 class_1 = 1;
%                 class_2 = 2;
% 
%                 figure();
%                 scatter( tsne_points(vClass_one == 1, 1), tsne_points(vClass_one == 1, 2), 30, 'r', 'filled', 'MarkerEdgeColor', 'k' );
%                 hold on;
%                 scatter( tsne_points(vClass_one ~= 1, 1), tsne_points(vClass_one ~= 1, 2), 30, 'b', 'filled', 'MarkerEdgeColor', 'k' );


%% show shannels with average
subject1 = 15;
sess1    = 1;

[Events, vClass]  = getERPEvents(subject1, sess1);

NUM = 4;
Events = addAverage(Events, vClass);
data = Events{1};
figure();

for ii = 1:NUM
    subplot(2*NUM, 1, ii);
    plot(data(:,ii), 'b');
    hold on;
    set(gca,'xtick',[]);
    set(gca,'ytick',[]);
    xlim([1 513]);
    if ii == 1
        title('Channels with mean', 'FontSize',32);
    end
%     axis off
end
for ii = 1:NUM
    subplot(2*NUM, 1, ii+NUM);
    plot(data(:,ii+16), 'r');
    set(gca,'xtick',[]);
    set(gca,'ytick',[]);
    xlim([1 513]);
%     if ii == 1
%         title('ERP channels', 'FontSize',25);
%     end
%     axis off
end
% legend('original', 'average');
xlabel('time', 'FontSize', 30);
%% PCA
subject1 = 1;
sess1    = 1;

[Events, vClass]  = getERPEvents(subject1, sess1);

NUM = 10;
Events_mean = addAverage(Events, vClass);
Events = addPCAAverage(Events);

figure();
for ii = 1:NUM
    subplot(NUM, 1, ii);
    plot(Events{ii}(:,1));
    set(gca,'xtick',[]);
    set(gca,'ytick',[]);
%     axis off
end
xlabel('time', 'FontSize',25);

figure();
plot(Events{ii}(:,17));
xlabel('time', 'FontSize',25);
xlim([1 513]);
set(gca,'xtick',[]);
% set(gca,'ytick',[]);


figure();
plot(Events_mean{ii}(:,17));
xlabel('time', 'FontSize',25);
xlim([1 513]);
set(gca,'xtick',[]);


%% - problem with pca
x1 = randn(700, 1);
x2 = x1*1 + randn(700, 1);
x = [x1, x2];
figure();
scatter(x(:,1), x(:,2), 100, 'r', 'filled', 'MarkerEdgeColor', 'k');
xlim([-10, 10]);
ylim([-10, 10]);
set(gca,'xtick',[]);
set(gca,'ytick',[]);
axis off

