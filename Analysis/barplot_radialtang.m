function barplot_radialtang(subjectinfo)

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
            'analyzeddata_all_loc_6fits_abs.mat');
        %subjectdata = fullfile(pwd,subjectinfo(si).name,'RelativeMotion',...
        %    'analyzeddata_4fits_absmean.mat');
        subjectci = fullfile(pwd,subjectinfo(si).name,'RelativeMotion',...
            'bootci_all_loc.mat');
        %subjectci = fullfile(pwd,subjectinfo(si).name,'RelativeMotion',...
        %    'bootci.mat');

        load(subjectdata)
        load(subjectci)
        
        paramlist(si,:) = [params_radial.all_loc(pi), params_tang.all_loc(pi)];
        %paramlist(si,:) = [params_radial.loc_270(pi), params_tang.loc_270(pi)];
        %lowerrorlist(si,:) = [bootci_radial.loc_270(1,pi,2), bootci_tang.loc_270(1,pi,2)];
        %uperrorlist(si,:) = [bootci_radial.loc_270(2,pi,2), bootci_tang.loc_270(2,pi,2)];
        
    
    end
    
    final_lowbound = paramlist-lowerrorlist;
    final_upbound = uperrorlist-paramlist;
    
    paramdiff = paramlist(:,1) - paramlist(:,2);
    mean_paramdiff = mean(paramdiff);
    error_paramdiff = std(paramdiff)./sqrt(length(subjectinfo));
    
%     figure
%     e1 = errorbar(1:length(subjectinfo)', paramlist(:,1), final_lowbound(:,1), final_upbound(:,1), 'LineStyle','none');
%     hold on
%     plot(1:length(subjectinfo)', paramlist(:,1), 'b.', 'MarkerSize',20)
%     hold on
%     e2 = errorbar(1:length(subjectinfo)', paramlist(:,2), final_lowbound(:,2), final_upbound(:,2), 'LineStyle','none');
%     hold on
%     plot(1:length(subjectinfo)', paramlist(:,2), 'r.', 'MarkerSize',20)
%     hold on
%     xticks(1:length(subjectinfo))
%     xticklabels({'S1','S2','S3','S4','S5'})
%     xlim([0,6])
%     ylim([0, 1.6])
%     yticks([0, 0.4, 0.8, 1.2, 1.6])
%     set(gca,'DefaultLineLineWidth',10, 'FontSize', 14)
%     hold off
%     e1.LineWidth = 3; e2.LineWidth = 3;
%     e1.Color = 'b'; e2.Color = 'r';
%     title(params(pi));
    
    colorarray = [[1 0 0]; [0 1 0]; [0 1 1]; [1 1 0]; [1 0 1]];
    figure
    x = [1,1.5, 2];
    y = [mean(paramlist), mean_paramdiff];
    clr = [26 133 255; 212 17 89 ; 255 255 255]/255;
    b = bar(x, y, 0.5, 'facecolor', 'flat', 'LineWidth',1.5);
    b.CData = clr;
    error = [std(paramlist)./sqrt(length(subjectinfo)), error_paramdiff];
    hold on
    scatter(repmat(x(1), 5,1),paramlist(:,1), 40, colorarray, 'filled', 'MarkerEdgeColor',[0 0 0], 'MarkerEdgeAlpha',.5, 'MarkerFaceAlpha',.5)
    hold on
    scatter(repmat(x(2), 5,1),paramlist(:,2), 40, colorarray, 'filled', 'MarkerEdgeColor',[0 0 0], 'MarkerEdgeAlpha',.5, 'MarkerFaceAlpha',.5)
    hold on
    scatter(repmat(x(3), 5,1),paramdiff, 40, colorarray, 'filled', 'MarkerEdgeColor',[0 0 0], 'MarkerEdgeAlpha',.5, 'MarkerFaceAlpha',.5)
    hold on
    errorbar(x, y,error, '.', 'Color','k','LineWidth',2)
    hold on
    %xlim([0.5 2.5])
    xlim([0.75 2.25])
    %ylim([0 0.78])
    ylim([-0.1 0.8])
    yticks([-0.1 0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8])
    yticklabels({[], 0, [], 0.2, [], 0.4, [], 0.6, [] 0.8})
    %xticks([1 1.5])
    set(gca,'xticklabel',{'radial','tangential', 'diff'}, 'FontSize', 30)
    %set(gca,'YTick',[0 0.2 0.4 0.6 0.8]);
    set(gca,'XTick',[1 1.5, 2]);
    %set(gca,'XTick',[1 1.5]);
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