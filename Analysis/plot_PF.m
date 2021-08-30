function plot_PF(numCond, figuresdir, conditions, computed_params)

PF = @PAL_CumulativeNormal;
paramNames = {'bias','sensitivity'};
paramValues = {'bias','slope'};

% extract subjectname
pathparts = strsplit(figuresdir, '/'); subjname = pathparts{end-2};

newblue = [26 133 255]/255;
newblue2 = [0 90 181]/255;
newred = [212 17 89]/255;
newred2 = [230 97 0]/255;
if numCond==2
    colors = {newblue2,newred};
    n1='radial';n2='tangential';
    condLabels = {n1,n2};
elseif numCond==4
    colors = {newblue,newblue2,newred,newred2}; %['c','b','r','m'];
    n1='outward';n2='inward';n3='tangleft';n4='tangright';
    condLabels = {n1,n2,n3,n4};
end

% add loop for each location + collapsed
distinct_locs = [];
for si=1:length(conditions)
    distinct_locs = [distinct_locs fieldnames(conditions{si})];
end
distinct_locs = unique(cellfun(@num2str,distinct_locs,'uni',0));
distinct_locs(ismember(distinct_locs,'rownames')) = {'Alldata'};
save_params = nan(length(conditions), 4);
    
for li=1:length(distinct_locs)
    %li = 5; % remove later
    loc_title = distinct_locs{li};

    sz = 100;
    figure(li)
    set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96])
    ax = gca; 

    %disp(conditions)

    for si=1:length(conditions)
    
        if strcmp(distinct_locs{li},'Alldata')
            [params, total_conditions, PC] = collapse_locations(si, conditions);
            save_params(si,:) = params;
        else
            params = computed_params{si}.(distinct_locs{li});
            total_conditions = conditions{si}.(distinct_locs{li})(4,:);
            PC = conditions{si}.(distinct_locs{li})(3,:);
        end

     %if si==2 % remove later
     %   	continue
     %elseif si==4
     %    continue
     %else
        StimLevelsFine = [min(total_conditions):max((total_conditions) - min(total_conditions))./1000:max(total_conditions)];
        Fit = PF(params, StimLevelsFine);
        plot(ax, StimLevelsFine, Fit, 'Color', colors{si},'linewidth', 2)
        xlabel('added tilt (deg)')
        ylabel('clockwise response')
        hold on

        scatter(ax, total_conditions, PC, sz, 'MarkerEdgeColor',colors{si}, 'MarkerFaceColor',colors{si})
        hold on
        alpha(.3)
        %legend('outward','inward','tangleft', 'tangright', 'Location','Northwest')
        locationtitle = regexprep(distinct_locs{li},'_','','emptymatch');
        title(sprintf('%s %s', subjname, locationtitle))
        ax.FontSize = 40;
        sz = sz-25;
     %end
    end
    figure(li)
    %f=get(gca,'Children');
    if numCond==4
        %legend([f(2),f(4),f(6),f(8)],n1,n2,n3,n4, 'Location','Northwest')
        L1 = plot(ax, nan, nan, 'color', colors{1},'LineWidth', 2.5);
        L2 = plot(ax, nan, nan, 'color', colors{2},'LineWidth', 2.5);
        L3 = plot(ax, nan, nan, 'color', colors{3},'LineWidth', 2.5);
        L4 = plot(ax, nan, nan, 'color', colors{4},'LineWidth', 2.5);
        %legend([L1, L2, L3,L4],n1,n2,n3,n4, 'Location','Northwest')
        legend([L1, L2, L3,L4],condLabels{1},condLabels{2},condLabels{3}, ...
            condLabels{4}, 'Location','Northwest')
        
    elseif numCond==2
        %legend([f(2),f(4)],n1,n2, 'Location','Northwest')
        L1 = plot(ax, nan, nan, 'color', colors{1},'LineWidth', 2.5);
        L2 = plot(ax, nan, nan, 'color', colors{2},'LineWidth', 2.5);
        %legend([L1, L2],n1,n2, 'Location','Northwest')
        legend([L1, L2],condLabels{1},condLabels{2}, 'Location','Northwest')
    end
    
    saveas(gcf,sprintf('%s/pngs/%s_PF_%s_%sconds.png',figuresdir,subjname, locationtitle, num2str(numCond)))
    saveas(gcf,sprintf('%s/figs/%s_PF_%s_%sconds.fig',figuresdir,subjname, locationtitle, num2str(numCond)))
    saveas(gcf,sprintf('%s/bmps/%s_PF_%s_%sconds.bmp',figuresdir,subjname, locationtitle, num2str(numCond)))
    hold off
    
    % THIS RECOMPUTES ALL LOCATION, WITH 1 PF (NOT A MEAN SENSITIVITY
    % METHOD ACROSS 4-6 PFs)
    if strcmp(distinct_locs{li},'Alldata')
        % make bar plots
        for pi=1:2 % slope and bias
            figure
            n_means = save_params(:, pi)';
            n_sets = 1:length(n_means);
            bar(n_sets,n_means)
            title(paramNames{pi})
            ylabel(sprintf('Mean %s (%s)', paramValues{pi}, distinct_locs{li}))
            set(gca,'xticklabel',condLabels)
            set(gca,'FontSize', 14);
            saveas(gcf,sprintf('%s/pngs/%s_BP_%s_%sAlllocations_%sconds.png',figuresdir,subjname, paramNames{pi}, locationtitle, num2str(numCond)))
            saveas(gcf,sprintf('%s/figs/%s_BP_%s_%sAlllocations_%sconds.fig',figuresdir,subjname, paramNames{pi}, locationtitle, num2str(numCond)))
            saveas(gcf,sprintf('%s/bmps/%s_BP_%s_%sAlllocations_%sconds.bmp',figuresdir,subjname, paramNames{pi}, locationtitle, num2str(numCond)))
        end
    end
    
end
close all;
end