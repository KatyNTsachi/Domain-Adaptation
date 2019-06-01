function [] = showAllChannels(Event, s_title)
    num_chanels_to_show = size(Event, 2);
    figure();
    title(s_title);
    for ii = 1:num_chanels_to_show
        subplot(num_chanels_to_show,1,ii);
        plot(Event(:,ii));
        set(gca,'xtick',[]);
        set(gca,'ytick',[]);
        if ii == num_chanels_to_show
            xlabel('time', 'FontSize',44);
        end
        if ii == 1
            title(s_title, 'FontSize',44);
        end
    end
end

