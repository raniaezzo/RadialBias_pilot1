function plot_VP(subjname,figuresdir,analysiscond) % vector plot

subjectdata = fullfile(pwd,subjname,'RelativeMotion','analyzeddata.mat');
load(subjectdata);
plotname = 'VP';
    
T_example = [struct2table(params_upwards); struct2table(params_downwards); ...
    struct2table(params_leftwards); struct2table(params_rightwards)];
T_example.Properties.RowNames = {'upwards'; 'downwards';'leftwards'; 'rightwards'};
cartesian_locationdegrees = {270, 0, 90, 180};
cartesian_directions = cartesian_locationdegrees; % loc & direction are same
cartesian_locationlabels = strcat('loc_',cellfun(@num2str,cartesian_locationdegrees,'un',0));
cartesian_directionlabels = {'rightwards','upwards','leftwards','downwards'};

figure
% Plot a circle.
angles = linspace(0, 2*pi, 9); % 720 is the total number of points
radius = 7;
xCenter = 0;
yCenter = 0;
x = radius * cos(angles) + xCenter; 
y = radius * sin(angles) + yCenter;
% Plot circle.
%plot(x, y, 'b-', 'LineWidth', 2);
% Plot center.
%hold on;
plot(xCenter, yCenter, 'k+', 'LineWidth', 2, 'MarkerSize', 12);
hold on
%grid on;
xlabel('X', 'FontSize', 16);
ylabel('Y', 'FontSize', 16);
% Now get random locations along the circle.
s1 = 9; % Number of random points to get.
randomIndexes = randperm(length(angles), s1);
xRandom = x(randomIndexes);
yRandom = y(randomIndexes);
plot(xRandom, yRandom, 'k.', 'LineWidth', 2, 'MarkerSize', 12);
xlim([-10 10])
ylim([-10 10])
axis square;
hold on

for li=1:length(cartesian_locationdegrees)
    loclabel=cartesian_locationlabels{li};
    locdegrees=cartesian_locationdegrees{li};
    %loccart=pol2cart(deg2rad(180),radius);
    if locdegrees == 0
        X=radius; Y=0;
    elseif locdegrees == 90
        X=0; Y=radius;
    elseif locdegrees == 180
        X=-radius; Y=0;
    elseif locdegrees == 270
        X=0; Y=-radius;
    end
    %slope_mag = [];
    for i=1:length(cartesian_directions)
        dirlabel=cartesian_directionlabels{i};
        dirtheta=cartesian_directions{i};
        condition = T_example(dirlabel,loclabel); 
        slope_mag = condition{1,1}(2); % just for reference (mag)
        if strcmp(dirlabel,'downwards')
            U=0; V=-slope_mag; colorselect = 'm';
        elseif strcmp(dirlabel,'upwards')
            U=0; V=slope_mag; colorselect = 'r';
        elseif strcmp(dirlabel,'rightwards')
            U=slope_mag; V=0; colorselect = [0, 0.75, 0.75];
        elseif strcmp(dirlabel,'leftwards')
            U=-slope_mag; V=0; colorselect = 'b';
        end
        q = quiver(X,Y,U,V);
        q.ShowArrowHead = 'on';
        q.LineWidth = 2;
        q.MaxHeadSize = 2;
        q.Color = colorselect;
        hold on
    end
end

T_example = [struct2table(params_upperleftwards); struct2table(params_upperrightwards); ...
    struct2table(params_lowerleftwards); struct2table(params_lowerrightwards)];
T_example.Properties.RowNames = {'upperleftwards'; 'upperrightwards';'lowerleftwards'; 'lowerrightwards'};
oblique_locationdegrees = {315,135,225,45};
oblique_directions = oblique_locationdegrees; % loc & direction are same
oblique_locationlabels = strcat('loc_',cellfun(@num2str,oblique_locationdegrees,'un',0));
oblique_directionlabels = {'lowerrightwards','upperleftwards','lowerleftwards','upperrightwards'};

for li=1:length(oblique_locationdegrees)
    loclabel=oblique_locationlabels{li};
    locdegrees=oblique_locationdegrees{li};
    %loccart=pol2cart(deg2rad(180),radius);
    if locdegrees == 45
        X=sqrt((radius^2)/2); Y=sqrt((radius^2)/2);
    elseif locdegrees == 135
        X=-sqrt((radius^2)/2); Y=sqrt((radius^2)/2);
    elseif locdegrees == 225
        X=-sqrt((radius^2)/2); Y=-sqrt((radius^2)/2);
    elseif locdegrees == 315
        X=sqrt((radius^2)/2); Y=-sqrt((radius^2)/2);
    end
    for i=1:length(oblique_directions)
        dirlabel=oblique_directionlabels{i};
        dirtheta=oblique_directions{i};
        condition = T_example(dirlabel,loclabel); 
        slope_mag = condition{1,1}(2); % just for reference (mag)
        if strcmp(dirlabel,'upperrightwards')
            U=sqrt((slope_mag^2)/2); V=sqrt((slope_mag^2)/2); colorselect = 'g';
        elseif strcmp(dirlabel,'upperleftwards')
            U=-sqrt((slope_mag^2)/2); V=sqrt((slope_mag^2)/2); colorselect = [0.8500, 0.3250, 0.0980];
        elseif strcmp(dirlabel,'lowerrightwards')
            U=sqrt((slope_mag^2)/2); V=-sqrt((slope_mag^2)/2); colorselect = [0.9290, 0.6940, 0.1250];
        elseif strcmp(dirlabel,'lowerleftwards')
            U=-sqrt((slope_mag^2)/2); V=-sqrt((slope_mag^2)/2); colorselect = [0.4660, 0.6740, 0.1880];
        end
        q = quiver(X,Y,U,V);
        q.ShowArrowHead = 'on';
        q.LineWidth = 2;
        q.MaxHeadSize = 2;
        q.Color = colorselect;
        hold on
    end
end
title('Sensitivity of motion directions per location', 'Fontsize', 14)
set(gca,'xtick',[])
set(gca,'xticklabel',[])
set(gca,'ytick',[])
set(gca,'yticklabel',[])
hold off

saveas(gcf,sprintf('%s/pngs/%s_%s_Alldata_4conds_%s.png',figuresdir,subjname, ...
    plotname,analysiscond))

end
