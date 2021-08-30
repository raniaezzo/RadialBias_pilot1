function barplot_upperlower(subjectinfo)

% TO DO: check the bias CIs, something doesn't seem right
% maybe has to do with compute_ci with distribution of abs values?
% already checked sensitivity, and reflects what is on polarplot (but w/
% 68CI)

params = {'bias','sensitivity'};

for pi=1:length(params)
    pi=2;
    disp(pi)
    paramlist = NaN(length(subjectinfo), 2); % 2 for radial/tangential
    lowerrorlist = NaN(length(subjectinfo), 2);
    uperrorlist = NaN(length(subjectinfo), 2);
    for si=1:length(subjectinfo)
        % create subject directory
        subjectdata = fullfile(pwd,subjectinfo(si).name,'RelativeMotion',...
            'analyzeddata_upperlower_6fits_abs.mat');

        load(subjectdata)
        
        paramlist(si,:) = [params_lower.all_loc(pi), params_upper.all_loc(pi)];
        
    
    end
    
    [error_paramdiff, output_data] = withinSubjError(paramlist,1);
    %paramdiff = paramlist(:,1) - paramlist(:,2);
    %mean_paramdiff = mean(paramdiff);
    %error_paramdiff = std(paramdiff)./sqrt(length(subjectinfo));
    
    colorarray = [[1 0 0]; [0 1 0]; [0 1 1]; [1 1 0]; [1 0 1]];
    figure
    x = [1,1.5, 2];
    y = [mean(paramlist), mean_paramdiff];
    %clr = [26 133 255; 212 17 89]/255;
    clr = [255 190 106; 64 176 166; 255 255 255]/255;
    %clr2 = [0 0 0; 0 0 0; 0 0 0]/255;
    b = bar(x, y, 0.5, 'facecolor', 'flat', 'LineWidth',1.5);
    b.CData = clr;
    %b.EdgeColor = [0 0 0]/255;
    error = [std(paramlist)./sqrt(length(subjectinfo)), error_paramdiff];
    hold on
    scatter(repmat(x(1), 5,1),paramlist(:,1), 40, colorarray, 'filled', 'MarkerEdgeColor',[0 0 0], 'MarkerEdgeAlpha',.5, 'MarkerFaceAlpha',.5)
    hold on
    scatter(repmat(x(2), 5,1),paramlist(:,2), 40, colorarray, 'filled', 'MarkerEdgeColor',[0 0 0], 'MarkerEdgeAlpha',.5, 'MarkerFaceAlpha',.5)
    hold on
    scatter(repmat(x(3), 5,1),paramdiff, 40, colorarray, 'filled', 'MarkerEdgeColor',[0 0 0], 'MarkerEdgeAlpha',.5, 'MarkerFaceAlpha',.5)
    hold on
    errorbar(x, y, error, '.', 'Color','k','LineWidth',2)
    hold on
    %xlim([0.5 2.5])
    xlim([0.75 2.25])
    ylim([-0.1 0.8])
    yticks([-0.1 0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8])
    yticklabels({[], 0, [], 0.2, [], 0.4, [], 0.6, [] 0.8})
    set(gca,'xticklabel',{'lower VF','upper VF', 'diff'}, 'FontSize', 30)
    %set(gca,'yticklabel',{0, 0.2, 0.4, 0.6 0.8}, 'FontSize', 30)
    %set(gca,'YTick',[0 0.2 0.4 0.6 0.8]);
    set(gca,'XTick',[1 1.5, 2]);
    %yticks([0 0.2 0.4 0.6])
    h=get(gca,'yaxis');
    set(h, 'FontSize', 30);
    %title(strcat('mean', params(pi)));
    
end



% model_series = [10 40 50 60; 20 50 60 70; 30 60 80 90]; 
% model_error = [1 4 8 6; 2 5 9 12; 3 6 10 13]; 
% b = bar(model_series, 'grouped');
% hold on
% % Calculate the number of groups and number of bars in each group
% [ngroups,nbars] = size(model_series);
% % Get the x coordinate of the bars
% x = nan(nbars, ngroups);
% for i = 1:nbars
%     x(i,:) = b(i).XEndPoints;
% end
% % Plot the errorbars
% errorbar(x',model_series,model_error,'k','linestyle','none');
% hold off

end