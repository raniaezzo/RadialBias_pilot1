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

n_data = length(angle);
%fake = polarplot(angle,max(avg+error)*ones(1,n_data), color); set(fake,'Visible','off'); hold on; 
fake = polarplot(angle,max(avg+error_ub)*ones(1,n_data), color); set(fake,'Visible','off'); hold on; 
polarplot(angle,avg,horzcat('-s',color));
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
    polarplot(angle(ni)*ones(1,3),[error_lb(ni), avg(ni), error_ub(ni)],color,'LineWidth',1);
    end
end
hold on
% first plot the min circle
th = linspace(0,2*pi,50);
r = min;
%disp('min')
%disp(r)
polarplot(th,r+zeros(size(th)),'k--','LineWidth',2)
hold off
