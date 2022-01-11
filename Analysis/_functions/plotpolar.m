function plotpolar(numCond, paramsetting, analysiscond,figuresdir, main_conditions, ...
    mapdegree, ci_values, organization)
    
    condNames = organization;

    newblue = [26 133 255]/255;
    newblue2 = [0 90 181]/255;
    newred = [212 17 89]/255; % put back
    newred2 = [230 97 0]/255;
    newgreen = [0 123 0]/255;
    newgreen2 = [0 255 0]/255;
    green_polarangles = [0.4660, 0.6740, 0.1880];
    purple = [0.5542    0.2797    0.7059];
    teal = [89 168 143]/255; 
    %[0.3478    0.6616    0.5592];
    withbars = 0;
    
    if withbars == 0
        plotname = 'LP'; % line plot
    else
        plotname = 'BP'; % bar plot
    end
    
    conf_interval = 68;

    if strcmp(cell2mat(organization),'radialtang')
        colors = {newblue2,newred};
    elseif strcmp(cell2mat(organization),'radial_inradial_outtang_righttang_left')
        colors = {newblue,newblue2,newred,newred2};
    elseif strcmp(cell2mat(organization), ...
        'upwardsdownwardsleftwardsrightwardslowerleftwardslowerrightwardsupperleftwardsupperrightwards')
        colors = {[0, 0, 1],[0, 0.75, 0.75],[0.8500, 0.3250, 0.0980],[1, 0, 0], ...
            [0.4660, 0.6740, 0.1880],[0, 0.5, 0],[0.4940, 0.1840, 0.5560],[0.75, 0, 0.75]};
    elseif strcmp(cell2mat(organization),'cardinaloblique')
        colors = {newgreen, newgreen2};
        %colors = {purple teal};
    elseif strcmp(cell2mat(organization),'radial orientationtang orientation')
        colors = {newred, newblue2};
    else
        colors = {newgreen2};
        %condNames = {'switched cond'};    
    end
    
    if conf_interval == 95
        select_idx = 1;
    elseif conf_interval == 68
        select_idx = 2;
    end
    
    % extract subjectname
    pathparts = strsplit(figuresdir,filesep); 
    subjname = pathparts{7};
    
    possibleLocs = 8;
    addedconst= 1.5; % added const to min
    %main_conditions = {params_radialout,params_radialin,params_tangleft,params_tangright};
    %ci_values = {bootci_radialout,bootci_radialin,bootci_tangleft,bootci_tangright};
    
    if strcmp(paramsetting, 'z-score bias') || strcmp(paramsetting, 'bias')
        % before was [1,0] but now I calculated abs beforehand
        absv = [0]; % run 2 iterations (absolute value,regular)
        paramidx = 1;
        % calculate min (bias value - 95% error) across all conditions - const across
        % plot a circle on polar plot
        if strcmp(paramsetting, 'z-score bias')
            minlist_bias = [];
            for i=1:length(main_conditions)
                for fn = fieldnames(main_conditions{i})'
                    % (1,1,select_index) refers to (lowerbound, biasparam, 95ci)
                    select_idx = 2; % (changing from: always set to 95 for max range)
                    biaswerror = main_conditions{i}.(fn{1})(:,paramidx)+ ci_values{i}.(fn{1})(1,paramidx,select_idx);
                    minlimit_bias = min(biaswerror);
                    minlist_bias = [minlist_bias minlimit_bias];
                end
            end
            set_min = abs(min(minlist_bias)-addedconst);
        elseif strcmp(paramsetting, 'bias')
            %set_min = 0;
            set_min = -0.4;
        end
    elseif strcmp(paramsetting, 'sensitivity') || strcmp(paramsetting, 'z-score sensitivity')
        absv = [0];
        paramidx = 2;
        if strcmp(paramsetting, 'sensitivity')
            set_min = 0;
        elseif strcmp(paramsetting, 'z-score sensitivity')
            minlist_sensitivity = [];
            for i=1:length(main_conditions)
                for fn = fieldnames(main_conditions{i})'
                    % (1,1,select_index) refers to (lowerbound, sensitivityparam, 95ci)
                    select_idx = 1; % always set to 95 for max range
                    sensitivitywerror = main_conditions{i}.(fn{1})(:,paramidx)+ ci_values{i}.(fn{1})(1,paramidx,select_idx);
                    minlimit_sensitivity = min(sensitivitywerror);
                    minlist_sensitivity = [minlist_sensitivity minlimit_sensitivity];
                end
            end
            set_min = abs(min(minlist_sensitivity)-addedconst);
        end
    end
    
    figure
    
    % initialize for cartesian plot
    theta_saved = nan(8,length(main_conditions)); rho_saved = theta_saved;
    ci_95_lb_saved = theta_saved; ci_95_ub_saved = theta_saved;
    ci_68_lb_saved = theta_saved; ci_68_ub_saved = theta_saved;
    
    possiblethetas_deg = linspace(0,315,8);
    rtick_array = cell(1,length(main_conditions));
    for aa=1:length(absv)
        abscond = absv(aa);
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

            if strcmp(paramsetting, 'bias') || strcmp(paramsetting, 'z-score bias') || strcmp(paramsetting, 'z-score sensitivity')
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

            % ommit any NaN values (for absolute value plot)
            %fullmatrix = [theta; rho; ci_95_lb; ci_95_ub];
            fullmatrix = [theta; rho; ci_68_lb; ci_68_ub];
            fullmatrix(:,any(isnan(fullmatrix), 1)) = [];
            if any(isempty(fullmatrix), 'all')
                return % no data for this condition
            end
            fullmatrix = [fullmatrix, fullmatrix(:,1)]; % to connect last point
            
            % adding (1) to make full circle
            if abscond == 0 % if absv == 0
                polarwitherrorbar(fullmatrix(1,:),fullmatrix(2,:),fullmatrix(3,:), ...
                    fullmatrix(4,:), set_min, colors{i});
                hold on
            elseif abscond == 1 % if absv == 1
                fixed_rho = [rho rho(1)]-set_min;
                rho_poskeep = (fixed_rho > 0).*fixed_rho;
                fixed_rho(fixed_rho > 0) = 0;
                index_neg = (fixed_rho < 0); % neg values indices
                index_pos = (fixed_rho == 0); % neg values indices
                % switch upper and lower bounds
                ci_68_lb_temp_neg = (set_min-[ci_68_ub ci_68_ub(1)]+set_min).*index_neg;
                ci_68_ub_temp_neg = (set_min-[ci_68_lb ci_68_lb(1)]+set_min).*index_neg;
                ci_68_lb_temp_pos = ([ci_68_ub ci_68_ub(1)]).*index_pos;
                ci_68_ub_temp_pos = ([ci_68_lb ci_68_lb(1)]).*index_pos;
                ci_68_lb_temp = ci_68_lb_temp_neg+ci_68_lb_temp_pos;
                ci_68_ub_temp = ci_68_ub_temp_neg+ci_68_ub_temp_pos;
                fixed_rho = (fixed_rho*-1) + rho_poskeep;
                fixed_rho = fixed_rho+set_min;
                polarwitherrorbar([theta theta(1)], fixed_rho, ...
                    ci_68_lb_temp, ci_68_ub_temp, set_min, colors{i});
                hold on
            end
        end
    
    if strcmp(subjname, 'BB') && strcmp(paramsetting, 'sensitivity')
        custom_polarmax = 2; custom_barmax = 3;
    elseif strcmp(subjname, 'BB') && strcmp(paramsetting, 'bias')
        custom_polarmax = 4.5; custom_barmax = 5;
    elseif strcmp(subjname, 'WB') && strcmp(paramsetting, 'sensitivity')
        custom_polarmax = 2; custom_barmax = 3;
    elseif strcmp(subjname, 'WB') && strcmp(paramsetting, 'bias')
        custom_polarmax = 4.5; custom_barmax = 5;
    elseif strcmp(subjname, 'FH') && strcmp(paramsetting, 'sensitivity')
        custom_polarmax = 1; custom_barmax = 1.5;
    elseif strcmp(subjname, 'FH') && strcmp(paramsetting, 'bias')
        custom_polarmax = 6.5; custom_barmax = 8.5;
    elseif strcmp(subjname, 'HF') && strcmp(paramsetting, 'sensitivity')
        custom_polarmax = 1; custom_barmax = 1.5;
    elseif strcmp(subjname, 'HF') && strcmp(paramsetting, 'bias')
        custom_polarmax = 6.5; custom_barmax = 8.5;
    elseif strcmp(subjname, 'NH') && strcmp(paramsetting, 'sensitivity')
        custom_polarmax = 0.5; custom_barmax = 0.5;
    elseif strcmp(subjname, 'NH') && strcmp(paramsetting, 'bias')
        custom_polarmax = 18; custom_barmax = 25;
    elseif strcmp(subjname, 'PW') && strcmp(paramsetting, 'sensitivity')
        custom_polarmax = 1; custom_barmax = 1.5;
    elseif strcmp(subjname, 'PW') && strcmp(paramsetting, 'bias')
        custom_polarmax = 4; custom_barmax = 5.5;
    elseif strcmp(subjname, 'RE') && strcmp(paramsetting, 'sensitivity')
        custom_polarmax = 2; custom_barmax = 2.3;
    elseif strcmp(subjname, 'RE') && strcmp(paramsetting, 'bias')
        custom_polarmax = 2.5; custom_barmax = 3;
    elseif strcmp(subjname, 'ER') && strcmp(paramsetting, 'sensitivity')
        custom_polarmax = 2; custom_barmax = 2.3;
    elseif strcmp(subjname, 'ER') && strcmp(paramsetting, 'bias')
        custom_polarmax = 2.5; custom_barmax = 3;
    elseif strcmp(subjname, 'ME') && strcmp(paramsetting, 'sensitivity')
        custom_polarmax = 1; custom_barmax = 2.3;
    elseif strcmp(subjname, 'ME') && strcmp(paramsetting, 'bias')
        custom_polarmax = 2.5; custom_barmax = 3;
    elseif strcmp(subjname, 'SX') && strcmp(paramsetting, 'sensitivity')
        custom_polarmax = 0.8; custom_barmax = 1;
    elseif strcmp(subjname, 'SX') && strcmp(paramsetting, 'bias')
        custom_polarmax = 2.5; custom_barmax = 3;
    elseif strcmp(subjname, 'ALLSUBJ') && strcmp(paramsetting, 'sensitivity')
        custom_polarmax = 1; custom_barmax = 1.5;
    elseif strcmp(subjname, 'ALLSUBJ') && strcmp(paramsetting, 'bias')
        custom_polarmax = 4; custom_barmax = 5.5;
    elseif strcmp(subjname, 'RE_switch') && strcmp(paramsetting, 'sensitivity')
        custom_polarmax = 1.5; custom_barmax = 2;
    elseif strcmp(subjname, 'RE_switch') && strcmp(paramsetting, 'bias')
        custom_polarmax = 4; custom_barmax = 5.5;
    elseif strcmp(paramsetting, 'z-score sensitivity') || strcmp(paramsetting, 'z-score bias')
        custom_polarmax = []; custom_barmax = [];
    elseif strcmp(subjname, 'sasaki_figures') && strcmp(paramsetting, 'bias')
        custom_polarmax = 35; custom_barmax = 35;
    end
        
    
    rticks = get(gca,'RLim');
    if isempty(custom_polarmax)
        custom_polarmax = rticks(2);
    end
    rlim([rticks(1) custom_polarmax])
    thetaticks(possiblethetas_deg);
    %rticks = get(gca,'rtick');
    if strcmp(paramsetting, 'sensitivity')
        up = max(ceil(rticks)); down = min(floor(rticks));
        rticks_redefined = [down:0.5:custom_polarmax];
        set(gca,'RTick',rticks_redefined, 'fontsize',20)
    elseif strcmp(paramsetting, 'bias') || strcmp(paramsetting, 'z-score bias') || strcmp(paramsetting, 'z-score sensitivity')
        in = rticks-set_min; %up = max(ceil(in * 4) / 4); down = min(floor(in * 4) / 4);
        up = max(ceil(in)); down = min(floor(in));
        rticks_redefined = [down:0.5:custom_polarmax] + set_min;
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
        %if (abscond ~= 1) && ~(strcmp(paramsetting, 'z-score sensitivity'))
        if abscond ~= 0
            text(0,0,{'clockwise'},'HorizontalAlignment','center','VerticalAlignment','top')
        end
    end
    %rticklabels({})
    ax = gca; ax.GridAlpha = 1;
    hold on
    if abscond == 1
        titlename = sprintf('%s Polar Plot: %s (abs)',subjname, paramsetting);
    else
        %titlename = sprintf('%s Polar Plot: %s',subjname, paramsetting);
        titlename = sprintf('%s Polar Plot: %s',subjname, paramsetting);
    end
    title(titlename, 'FontSize', 14)
    if numCond==8
        L1 = polarplot(nan, nan, 'color', colors{1});
        L2 = polarplot(nan, nan, 'color', colors{2});
        L3 = polarplot(nan, nan, 'color', colors{3});
        L4 = polarplot(nan, nan, 'color', colors{4});
        L5 = polarplot(nan, nan, 'color', colors{5});
        L6 = polarplot(nan, nan, 'color', colors{6});
        L7 = polarplot(nan, nan, 'color', colors{7});
        L8 = polarplot(nan, nan, 'color', colors{8});
        legend([L1, L2, L3,L4,L5,L6,L7,L8], condNames)
    elseif numCond==4
        L1 = polarplot(nan, nan, 'color', colors{1});
        L2 = polarplot(nan, nan, 'color', colors{2});
        L3 = polarplot(nan, nan, 'color', colors{3});
        L4 = polarplot(nan, nan, 'color', colors{4});
        legend([L1, L2, L3,L4], condNames)
    elseif numCond==2
        L1 = polarplot(nan, nan, 'color', colors{1});
        L2 = polarplot(nan, nan, 'color', colors{2});
        legend([L1, L2], condNames)
    elseif numCond==1 % remove later
        L1 = polarplot(nan, nan, 'color', colors{1});
        legend([L1], condNames)
    end
    
    hold off
    
    if abscond == 1
        saveas(gcf,sprintf('%s/pngs/%s_PP_%s_abs_Alldata_%sconds_%s.png',figuresdir,subjname, paramsetting,num2str(numCond), analysiscond))
        saveas(gcf,sprintf('%s/figs/%s_PP_%s_abs_Alldata_%sconds_%s.fig',figuresdir,subjname, paramsetting,num2str(numCond), analysiscond))
        saveas(gcf,sprintf('%s/pdfs/%s_PP_%s_abs_Alldata_%sconds_%s.pdf',figuresdir,subjname, paramsetting,num2str(numCond), analysiscond))
    else
        saveas(gcf,sprintf('%s/pngs/%s_PP_%s_Alldata_%sconds_%s.png',figuresdir,subjname, paramsetting,num2str(numCond), analysiscond))
        saveas(gcf,sprintf('%s/figs/%s_PP_%s_Alldata_%sconds_%s.fig',figuresdir,subjname, paramsetting,num2str(numCond), analysiscond))
        saveas(gcf,sprintf('%s/pdfs/%s_PP_%s_Alldata_%sconds_%s.pdf',figuresdir,subjname, paramsetting,num2str(numCond), analysiscond))        
    end
    end
    
    if strcmp(analysiscond, 'relative')
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
            b(i).FaceColor = colors{i};
            x(i,:) = b(i).XEndPoints;
        end
        x_forplot = x';

        for ci=1:nbars
            plot(x_forplot(:,ci),rho_saved(:,ci), 'o-','color',colors{ci}, 'LineWidth', 2, ...
                'MarkerSize',5, 'MarkerEdgeColor',colors{ci},'MarkerFaceColor',colors{ci})
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
        %yl = ylim; yl = [yl(1)*1, yl(2)*1.2];
        yl = ylim; 
        if isempty(custom_barmax)
            custom_barmax = yl(2)*1.2;
        end
        yl = [yl(1)*1, custom_barmax];
        ylim(yl)
        if strcmp(paramsetting, 'bias')
            ylabel('bias (alpha)')
        elseif strcmp(paramsetting, 'z-score bias')
            ylabel('bias (z-score)')
        elseif strcmp(paramsetting, 'sensitivity')
            ylabel('slope (1/sigma)')
        elseif strcmp(paramsetting, 'z-score sensitivity')
            ylabel('slope (z-score)')
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
        saveas(gcf,sprintf('%s/pdfs/%s_%s_%s_Alldata_%sconds_%s.pdf',figuresdir,subjname,plotname, paramsetting,num2str(numCond),analysiscond))
    end
    
    close all;
end