function [] = polarwitherrorbar(angle,avg,error_lb,error_ub, min, color)
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The first two input variables ('angle' and 'avg') are same as the input 
% variables for a standard polar plot. The last input variable is the error
% value. Note that the length of the error-bar is twice the error value we
% feed to this function. 
% In order to make sure that the scale of the plot is big enough to
% accommodate all the error bars, i used a 'fake' polar plot and made it
% invisible. It is just a cheap trick. 
% The 'if loop' is for making sure that we dont have negative values  when
% an error value is substrated from its corresponding average value. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%color = [.5 0 .5];

set(gcf, 'renderer', 'painters')
n_data = length(angle);
%fake = polarplot(angle,max(avg+error)*ones(1,n_data), color); set(fake,'Visible','off'); hold on; 
fake = polarplot(angle,max(avg+error_ub)*ones(1,n_data), 'color',color); set(fake,'Visible','off'); hold on; 
hold on
for ni = 1 : n_data
    if isnan(avg(ni))
        continue
    else
        %if (avg(ni)-error_lb(ni)) < 0
        %    disp('Reaching negative')
        %    polarplot(angle(ni)*ones(1,3),[0, avg(ni), avg(ni)+error_lb(ni)],color,'LineWidth',1); 
        %elseif (avg(ni)-error_ub(ni)) < 0
        %    disp('Reaching negative')
        %    polarplot(angle(ni)*ones(1,3),[0, avg(ni), avg(ni)+error_ub(ni)],color,'LineWidth',1); 
        %else
        %    %polarplot(angle(ni)*ones(1,3),[avg(ni)-error(ni), avg(ni), avg(ni)+error(ni)],color);
        %    polarplot(angle(ni)*ones(1,3),[avg(ni)-error_lb(ni), avg(ni), avg(ni)+error_ub(ni)],color,'LineWidth',1);
        %end
    %polarplot(angle(ni)*ones(1,3),[error_lb(ni), avg(ni), avg(ni)+error_ub(ni)],color,'LineWidth',1);
    polarplot(angle(ni)*ones(1,3),[error_lb(ni), avg(ni), error_ub(ni)],'color',color,'LineWidth',4); %3);
    hold on
    end
end
p = polarplot(angle,avg,'-','color',color, 'LineWidth',4); %5); %3
hold on
p = polarplot(angle,avg,'-o','color',color, 'LineWidth',1.5); %1); %0.5
p.MarkerFaceColor = color; %color;
p.MarkerEdgeColor = 'w'; %'w';
p.MarkerSize = 8; %6
hold on
% first plot the min circle
th = linspace(0,2*pi,50);
r = min;
%disp('min')
%disp(r)
polarplot(th,r+zeros(size(th)),'k--','LineWidth',4) % put back (black %dashed line)
%polarplot(th,1+zeros(size(th)),'k--','LineWidth',4) % put back (black %dashed line)
hold off
