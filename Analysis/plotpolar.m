function plotpolar(numCond, paramsetting, analysiscond,figuresdir, main_conditions, ...
    mapdegree, ci_values)
    
    withbars = 0;
    if withbars == 0
        plotname = 'LP'; % line plot
    else
        plotname = 'BP'; % bar plot
    end
    
    conf_interval = 95;

    if numCond == 4
        colors = ['c','b','r','m'];
        if strcmp(analysiscond, 'relative')
            condNames = {'radialout', 'radialin','tangleft','tangright'};
        elseif strcmp(analysiscond, 'absolute')
            condNames = {'upwards', 'downwards','leftwards','rightwards'};
        end
    elseif numCond == 2
        colors = ['b','r'];
        condNames = {'radial','tangential'};
    end
    
    if conf_interval == 95
        select_idx = 1;
    elseif conf_interval == 68
        select_idx = 2;
    end
    
    % extract subjectname
    parts = strsplit(figuresdir, '/'); subjname = parts{end-2};
    possibleLocs = 8;
    addedconst= 1.5; % added const to min
    %main_conditions = {params_radialout,params_radialin,params_tangleft,params_tangright};
    %ci_values = {bootci_radialout,bootci_radialin,bootci_tangleft,bootci_tangright};
    
    if strcmp(paramsetting, 'bias')
        paramidx = 1;
        % calculate min (bias value - 95% error) across all conditions - const across
        % plot a circle on polar plot
        minlist_bias = [];
        for i=1:length(main_conditions)
            for fn = fieldnames(main_conditions{i})'
                % (1,1,select_index) refers to (lowerbound, biasparam, 95ci)
                select_idx = 1; % always set to 95 for max range
                biaswerror = main_conditions{i}.(fn{1})(:,1)+ ci_values{i}.(fn{1})(1,1,select_idx);
                minlimit_bias = min(biaswerror);
                minlist_bias = [minlist_bias minlimit_bias];
            end
        end
        set_min = abs(min(minlist_bias)-addedconst);
    elseif strcmp(paramsetting, 'sensitivity')
        paramidx = 2;
        set_min = 0;
    end
    
    figure
    
    % initialize for cartesian plot
    theta_saved = nan(8,length(main_conditions)); rho_saved = theta_saved;
    ci_95_lb_saved = theta_saved; ci_95_ub_saved = theta_saved;
    ci_68_lb_saved = theta_saved; ci_68_ub_saved = theta_saved;
    
    possiblethetas_deg = linspace(0,315,8);
    rtick_array = cell(1,length(main_conditions));
    for i=1:length(main_conditions) % conditions   
        theta = []; rho = []; ci_95_lb = []; ci_68_lb = []; ci_95_ub = []; ci_68_ub = [];
        for fn = fieldnames(main_conditions{i})' % locations
            %disp(fn{1})
            theta = [theta deg2rad(mapdegree(fn{1}))];
            rho = [rho main_conditions{i}.(fn{1})(paramidx)];
            ci_95_lb = [ci_95_lb ci_values{i}.(fn{1})(1, paramidx, 1)];
            ci_95_ub = [ci_95_ub ci_values{i}.(fn{1})(2, paramidx, 1)];
            ci_68_lb = [ci_68_lb ci_values{i}.(fn{1})(1, paramidx, 2)];
            ci_68_ub = [ci_68_ub ci_values{i}.(fn{1})(2, paramidx, 2)];
        end
        rho = rho+set_min; % will be +0 for sensitivity
        ci_95_lb = ci_95_lb+set_min; ci_95_ub = ci_95_ub+set_min; 
        ci_68_lb = ci_68_lb+set_min; ci_68_ub = ci_68_ub+set_min;
        
        [theta,idx] = sort(theta); % order theta from least to greatest
        rho = rho(idx); ci_95_lb = ci_95_lb(idx); ci_68_lb = ci_68_lb(idx);
        ci_95_ub = ci_95_ub(idx); ci_68_ub = ci_68_ub(idx);
       
        % insert empty [] for data not yet collected -- clean this up later
        possiblethetas_rad = deg2rad(possiblethetas_deg);
        emtyidx = ismember(num2str(possiblethetas_rad'), num2str(theta'), 'rows')';
        emtyidx = double(emtyidx); emtyidx(~emtyidx)=nan;

        theta = possiblethetas_rad;
        cnt = 1; new_rho = emtyidx; new_ci_95_lb = emtyidx; new_ci_68_lb = emtyidx;
        new_ci_95_ub = emtyidx; new_ci_68_ub = emtyidx;
        for pp=1:length(emtyidx)
            if isnan(emtyidx(pp))
                continue
            else
               new_rho(pp) = rho(cnt); new_ci_95_lb(pp) = ci_95_lb(cnt);
               new_ci_68_lb(pp) = ci_68_lb(cnt); new_ci_95_ub(pp) = ci_95_ub(cnt);
               new_ci_68_ub(pp) = ci_68_ub(cnt);
               cnt = cnt+1;
            end
        end
        rho = new_rho; ci_95_lb = new_ci_95_lb; ci_68_lb = new_ci_68_lb; 
        ci_95_ub = new_ci_95_ub; ci_68_ub = new_ci_68_ub; 
            
        if strcmp(paramsetting, 'bias')
            rho_saved(:,i) = rho-set_min;
            ci_95_lb_saved(:,i) = ci_95_lb-set_min; 
            ci_95_ub_saved(:,i) = ci_95_ub-set_min;
            ci_68_lb_saved(:,i) = ci_68_lb-set_min; 
            ci_68_ub_saved(:,i) = ci_68_ub-set_min;
        elseif strcmp(paramsetting, 'sensitivity')
            rho_saved(:,i) = rho;
            ci_95_lb_saved(:,i) = ci_95_lb; 
            ci_95_ub_saved(:,i) = ci_95_ub;
            ci_68_lb_saved(:,i) = ci_68_lb; 
            ci_68_ub_saved(:,i) = ci_68_ub;
        end
        theta_saved(:,i) = theta;

        % adding (1) to make full circle
        polarwitherrorbar([theta theta(1)], [rho rho(1)], ...
                [ci_95_lb ci_95_lb(1)], [ci_95_ub ci_95_ub(1)], set_min, colors(i));
        hold on
    end
    
    rticks = get(gca,'RLim');
    thetaticks(possiblethetas_deg);
    %rticks = get(gca,'rtick');
    if strcmp(paramsetting, 'sensitivity')
        up = max(ceil(rticks)); down = min(floor(rticks));
        rticks_redefined = [down:0.5:up];
        set(gca,'RTick',rticks_redefined)
    elseif strcmp(paramsetting, 'bias')
        in = rticks-set_min; %up = max(ceil(in * 4) / 4); down = min(floor(in * 4) / 4);
        up = max(ceil(in)); down = min(floor(in));
        rticks_redefined = [down:0.5:up] + set_min;
        set(gca,'RTick',rticks_redefined)
        %rohlabels = arrayfun(@(x) sprintf('%.1f', x-set_min), rticks_redefined, 'un', 0);
        rohlabels = arrayfun(@(x)  x-set_min, rticks_redefined, 'un', 0);
        rohlabelsmat = cell2mat(rohlabels);
        % only print whole numbers
        tempind = ismember(rohlabelsmat, rohlabelsmat(round(rohlabelsmat(:)) == (rohlabelsmat(:))));
        tempind = rohlabelsmat.*tempind; out=~~(rem(tempind,2).*tempind/2); tempind= out.*tempind;
        % tempind has zeros where emptys should be, now convert to cell
        tempind = arrayfun(@(x) sprintf('%.0f', x), tempind, 'un', 0);
        rohlabels3 = strrep(tempind,'-0', '');
        rohlabels4 = strrep(rohlabels3,'0', ''); 
        set(gca,'rticklabel',rohlabels4)
        text(0,0,{'clockwise'},'HorizontalAlignment','center','VerticalAlignment','top')
    end
    hold on
    titlename = sprintf('%s Polar Plot: %s',subjname, paramsetting);
    title(titlename, 'FontSize', 14)
    if numCond==4
        L1 = polarplot(nan, nan, 'color', colors(1));
        L2 = polarplot(nan, nan, 'color', colors(2));
        L3 = polarplot(nan, nan, 'color', colors(3));
        L4 = polarplot(nan, nan, 'color', colors(4));
        legend([L1, L2, L3,L4], condNames)
    elseif numCond==2
        L1 = polarplot(nan, nan, 'color', colors(1));
        L2 = polarplot(nan, nan, 'color', colors(2));
        legend([L1, L2], condNames)
    end
    hold off
    
    saveas(gcf,sprintf('%s/pngs/%s_PP_%s_Alldata_%sconds_%s.png',figuresdir,subjname, paramsetting,num2str(numCond), analysiscond))
    saveas(gcf,sprintf('%s/figs/%s_PP_%s_Alldata_%sconds_%s.fig',figuresdir,subjname, paramsetting,num2str(numCond), analysiscond))
    saveas(gcf,sprintf('%s/bmps/%s_PP_%s_Alldata_%sconds_%s.bmp',figuresdir,subjname, paramsetting,num2str(numCond), analysiscond))
    
    figure
    b = bar(rho_saved, 'grouped');
    if withbars == 1
        hold on
    end
    % Calculate the number of groups and number of bars in each group
    [ngroups,nbars] = size(rho_saved);
    % Get the x coordinate of the bars
    x = nan(nbars, ngroups);
    for i = 1:nbars
        b(i).FaceColor = colors(i);
        x(i,:) = b(i).XEndPoints;
    end
    x_forplot = x';
    
    for ci=1:nbars
        plot(x_forplot(:,ci),rho_saved(:,ci), sprintf('%so-',colors(ci)), 'LineWidth', 2, ...
            'MarkerSize',5, 'MarkerEdgeColor',colors(ci),'MarkerFaceColor',colors(ci))
        hold on
    end
    
    % Plot the errorbars
    errorbar(x_forplot,rho_saved,rho_saved-ci_95_lb_saved,ci_95_ub_saved-rho_saved,'k','linestyle','none');
    hold on
    errorbar(x_forplot,rho_saved,rho_saved-ci_68_lb_saved,ci_68_ub_saved-rho_saved,'g','linestyle','none');
    titlename = sprintf('%s Bar Plot: %s',subjname, paramsetting);
    title(titlename, 'FontSize', 14)
    if withbars == 1
        xticklabels({possiblethetas_deg})
    elseif withbars == 0
        xticklabels({[] possiblethetas_deg})
    end
    xlabel('Location (Degrees)', 'FontSize', 12)
    hold on
    
    groupNum = ngroups;
    groupsize = nbars;
    if nbars <= 2
        combinations = [1 2]; % workaround
        rounds = 1;
    else
        combinations = nchoosek(1:nbars, nbars-2);
        rounds = length(combinations);
    end
    
    if withbars == 1
    for i=1:groupNum
        new_y = rho_saved(i,:); new_matrix = new_y(combinations);
        new_ub_95 = ci_95_ub_saved(i,:); new_ub_95 = new_ub_95(combinations);
        new_lb_95 = ci_95_lb_saved(i,:); new_lb_95 = new_lb_95(combinations);
        new_ub_68 = ci_68_ub_saved(i,:); new_ub_68 = new_ub_68(combinations);
        new_lb_68 = ci_68_lb_saved(i,:); new_lb_68 = new_lb_68(combinations);
        M = max(new_matrix, [], 'all');        
        globalmax_ci = max(new_ub_95, [], 'all');
        jitter = 0.2;
        
        for ci=1:rounds
            
            % 95 CI
            ci_upperbounds = [new_ub_95(ci,1), new_ub_95(ci,2)];
            [greater_ci_val, greater_ci_idx] = max(ci_upperbounds);
            [smaller_ci_val, smaller_ci_idx] = min(ci_upperbounds);
            greater_ci_min = new_lb_95(ci,greater_ci_idx); % get lower bound
            smaller_ci_max = new_ub_95(ci,smaller_ci_idx); % get upper bound
            
            % 68
            ci_upperbounds_68 = [new_ub_68(ci,1), new_ub_68(ci,2)];
            [greater_ci_val_68, greater_ci_idx_68] = max(ci_upperbounds_68);
            [smaller_ci_val_68, smaller_ci_idx_68] = min(ci_upperbounds_68);
            greater_ci_min_68 = new_lb_68(ci,greater_ci_idx_68); % get lower bound
            smaller_ci_max_68 = new_ub_68(ci,smaller_ci_idx_68); % get upper bound
            

            if greater_ci_min > smaller_ci_max
                ctr2 = bsxfun(@plus, b(combinations(ci,1)).XData, [b(combinations(ci,1)).XOffset]');
                ctr3 = bsxfun(@plus, b(combinations(ci,2)).XData, [b(combinations(ci,2)).XOffset]');
                hold on
                % using the largest value of greatest range CI to place
                % star
                plot([ctr2(i) ctr3(i)], [1 1]*(globalmax_ci+jitter), '-k', 'LineWidth',1)
                plot(mean([ctr2(i) ctr3(i)]), (globalmax_ci+jitter), '*k')
                jitter = jitter+0.12;
            elseif greater_ci_min_68 > smaller_ci_max_68
                ctr2 = bsxfun(@plus, b(combinations(ci,1)).XData, [b(combinations(ci,1)).XOffset]');
                ctr3 = bsxfun(@plus, b(combinations(ci,2)).XData, [b(combinations(ci,2)).XOffset]');
                hold on
                % using the largest value of greatest range CI to place
                % star
                plot([ctr2(i) ctr3(i)], [1 1]*(globalmax_ci+jitter), '-g', 'LineWidth',1)
                plot(mean([ctr2(i) ctr3(i)]), (globalmax_ci+jitter), '*g') %greater_ci_val
                jitter = jitter+0.17;
            end
        end
    end
    end
    
    % increase ylim slightly
    yl = ylim; yl = [yl(1)*1, yl(2)*1.2];
    ylim(yl)
    if strcmp(paramsetting, 'bias')
        ylabel('bias (alpha)')
    elseif strcmp(paramsetting, 'sensitivity')
        ylabel('slope (1/sigma)')
    end
    
    legend(condNames, 'Location','Northwest')
    hLegend = findobj(gcf, 'Type', 'Legend'); % [0.1446 0.7881 0.1375 0.1179]
    
    % inset
    if numCond == 4
        positionvalues = hLegend.Position+[.22, 0.02 -.05 -.05];
    elseif numCond == 2
        positionvalues = hLegend.Position+[.20, -0.03 0 0]; %[.20, -0.05 .02 .02];
    end
    if withbars == 0
        positionvalues = positionvalues + [-0.05 0 0 0];
    end
    
    axes('Position',positionvalues); %[.2 .2 .05 .05])
    box on
    tvalues = [0 90 180 270];
    tvalues = deg2rad(tvalues);
    polarplot(tvalues, tvalues*0);
    thetatickformat('degrees')
    thetaticks(0:90:315)
    thetaticklabels = (0:90:270);
    rticklabels('manual')
    
    hold off
    
    saveas(gcf,sprintf('%s/pngs/%s_%s_%s_Alldata_%sconds_%s.png',figuresdir,subjname,plotname, paramsetting,num2str(numCond),analysiscond))
    saveas(gcf,sprintf('%s/figs/%s_%s_%s_Alldata_%sconds_%s.fig',figuresdir,subjname,plotname, paramsetting,num2str(numCond),analysiscond))
    saveas(gcf,sprintf('%s/bmps/%s_%s_%s_Alldata_%sconds_%s.bmp',figuresdir,subjname,plotname, paramsetting,num2str(numCond),analysiscond))
    
end