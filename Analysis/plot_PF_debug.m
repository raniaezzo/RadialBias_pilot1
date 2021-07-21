function plot_PF(numCond, figuresdir, conditions, bootsummary, b_iter)

% extract subjectname
parts = strsplit(figuresdir, '/'); subjname = parts{end-1};

if numCond==1
    colors = ['b'];
    n1='radialout'
elseif numCond==4
    colors = ['c','b','r','m'];
    n1='outward';n2='inward';n3='tangleft';n4='tangright';
end

figure
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96])
sz = 100;
ax = gca; 
PF = @PAL_CumulativeNormal;

disp(conditions)

for si=1:length(conditions)
    new_summary = []; cnt=1;
    for fn = fieldnames(conditions{si})'
        if strcmp(fn{1}, 'rownames')
            new_summary.(fn{1}) = conditions{si}.(fn{1});
        else
            if cnt==1
                temp_init = zeros(size(conditions{si}.(fn{1})));
                temp = conditions{si}.(fn{1});
                temp(3,:) = zeros(1,length(conditions{si}.(fn{1})(1,:)));
                cnt=cnt+1;
            else
                temp(1,:) = conditions{si}.(fn{1})(1,:);
                temp(2,:) = conditions{si}.(fn{1})(2,:);
                temp(3,:) = zeros(1,length(conditions{si}.(fn{1})(1,:)));
                temp(4,:) = zeros(1,length(conditions{si}.(fn{1})(4,:))); % same
            end
            temp_init = [temp_init + temp];
        end
        
    end
    new_summary.all_locations = temp_init;
    new_summary.all_locations(3,:) = new_summary.all_locations(2,:)./new_summary.all_locations(1,:);
    PC = new_summary.all_locations(3,:);
    
    [paramsValues,bootparams] = fit_PF(new_summary, [], []);
    
    params = paramsValues.all_locations;
    disp(params)
    
    % plot PF 
    PropCorrectData = new_summary.all_locations(3,:);
    total_conditions = new_summary.all_locations(4,:);
    StimLevelsFine = [min(total_conditions):max((total_conditions) - min(total_conditions))./1000:max(total_conditions)];
    Fit = PF(params, StimLevelsFine);
    plot(StimLevelsFine, Fit, colors(si),'linewidth', 2)
    xlabel('added tilt (deg)')
    ylabel('clockwise response')
    hold on
    
    scatter(total_conditions, PC, sz, 'MarkerEdgeColor',colors(si), 'MarkerFaceColor',colors(si))
    hold on
    alpha(.3)
    %legend('outward','inward','tangleft', 'tangright', 'Location','Northwest')
    title(sprintf('%s All Data', subjname))
    ax.FontSize = 40;
end
f=get(gca,'Children');
if numCond==4
    legend([f(2),f(4),f(6),f(8)],n1,n2,n3,n4, 'Location','Northwest')
elseif numCond==1
    legend(f(2),n1, 'Location','Northwest')
end
saveas(gcf,sprintf('%s/pngs/%s_PF_Alldata_%sconds.png',figuresdir,subjname, num2str(numCond)))
saveas(gcf,sprintf('%s/figs/%s_PF_Alldata_%sconds.fig',figuresdir,subjname, num2str(numCond)))
saveas(gcf,sprintf('%s/bmps/%s_PF_Alldata_%sconds.bmp',figuresdir,subjname, num2str(numCond)))
end