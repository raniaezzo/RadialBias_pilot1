function plotbar(figuresdir, mean_acrossloc, locvalues, ci_acrossloc, organization)

plotname = strjoin(string(organization),'_');
% extract subjectname
pathparts = strsplit(figuresdir,filesep); 
subjname = pathparts{7};

param_name = {'bias','sensitivity'};
param = 2;
colorarray = {[1 0 0]; [0 1 0]; [0 1 1]; [1 1 0]; [1 0 1]; [0.5 0.5 0.5]; [0.75 0 1]; [0.75 1 0]};

[~, datapoints] = size(locvalues{1,1});
figure
    
L_error = []; U_error = [];
for ci=1:length(organization)
    % %% KEEP THIS!!!!
    %L_error = [L_error ci_acrossloc{ci,1}(1,param,2)];
    %U_error = [U_error ci_acrossloc{ci,1}(2,param,2)];
    
    % std instead
    L_error = [L_error std(locvalues{ci}(param,:))./2];
    U_error = [U_error std(locvalues{ci}(param,:))./2];
end

% compute error of the difference
if length(organization) == 2
    differencebar = 1;
    paramdiff = locvalues{1}(param,:) - locvalues{2}(param,:);
    mean_paramdiff = mean(paramdiff);
    error_paramdiff = std(paramdiff)./sqrt(datapoints);
    org_names = organization; org_names{1,3} = 'diff';
    
    L_error = [L_error -error_paramdiff/2];
    U_error = [U_error error_paramdiff/2];
    
    y=[mean_acrossloc(:,param)', mean_paramdiff];
    x = [1,1.5, 2];
    set(gca,'XTick',[1 1.5, 2]);
    xlim([0.75 2.25])
else
    y = [mean_acrossloc(:,param)'];
    x = [1, 1.5, 2, 2.5];
    set(gca,'XTick',[1, 1.5, 2, 2.5]);
    org_names = organization;
    xlim([0.75 3])
end

    clr = [26 133 255; 212 17 89 ; 255 255 255]/255;
    b = bar(x, y, 0.5, 'facecolor', 'flat', 'LineWidth',1.5);
    b.CData = clr;
    
    %error = [std(paramlist)./sqrt(length(subjectinfo)), error_paramdiff];
    hold on
    scatter(repmat(x(1), datapoints,1),locvalues{1}(param,:), 40, colorarray{1}, 'filled', 'MarkerEdgeColor',[0 0 0], 'MarkerEdgeAlpha',.5, 'MarkerFaceAlpha',.5)
    hold on
    scatter(repmat(x(2), datapoints,1),locvalues{2}(param,:), 40, colorarray{2}, 'filled', 'MarkerEdgeColor',[0 0 0], 'MarkerEdgeAlpha',.5, 'MarkerFaceAlpha',.5)
    hold on
    if length(organization) == 2
        scatter(repmat(x(3), datapoints,1),paramdiff, 40, colorarray{3}, 'filled', 'MarkerEdgeColor',[0 0 0], 'MarkerEdgeAlpha',.5, 'MarkerFaceAlpha',.5)
    end
    hold on
    %errorbar(x, y,error, '.', 'Color','k','LineWidth',2)
    errorbar(x, y,L_error, U_error, '.', 'Color','k','LineWidth',2)
    hold on
    %ylim([-0.1 0.8])
    yticks([-0.1 0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8])
    yticklabels({[], 0, [], 0.2, [], 0.4, [], 0.6, [] 0.8})
    org_names_edited = ['',string(org_names), ''];
    set(gca,'xticklabel',org_names_edited, 'FontSize', 30)
    h=get(gca,'yaxis');
    set(h, 'FontSize', 30);


    saveas(gcf,sprintf('%s/pngs/%s_BP_%s_%s.png',figuresdir,subjname, ...
        plotname, param_name{param}))
    saveas(gcf,sprintf('%s/figs/%s_BP_%s_%s.fig',figuresdir,subjname, ...
        plotname, param_name{param}))
    saveas(gcf,sprintf('%s/pdfs/%s_BP_%s_%s.pdf',figuresdir,subjname, ...
        plotname, param_name{param}))
    
end