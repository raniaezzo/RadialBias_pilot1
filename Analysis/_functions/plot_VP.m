function plot_VP(figuresdir,main_conditions, organization) % vector plot

pathparts = strsplit(figuresdir,filesep); 
subjname = pathparts{7};

plotname = 'VP';

T_example = [struct2table(main_conditions{1}); struct2table(main_conditions{2}); ...
    struct2table(main_conditions{3}); struct2table(main_conditions{4}); ...
    struct2table(main_conditions{5}); struct2table(main_conditions{6}); ...
    struct2table(main_conditions{7}); struct2table(main_conditions{8})];
T_example.Properties.RowNames = {organization{1:8}}';

cartesian_locationdegrees = {270, 0, 90, 180, 45, 135, 225, 315};
cartesian_directions = cartesian_locationdegrees; % loc & direction are same
cartesian_locationlabels = strcat('loc_',cellfun(@num2str,cartesian_locationdegrees,'un',0));
cartesian_directionlabels = {organization{1:8}};

figure
% Plot a circle.
angles = linspace(0, 2*pi, 9); % 720 is the total number of points
radius = 3; %7 % this value is for visualization only (could set to 7 to match ecc)
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
xlim([-5 5])
ylim([-5 5])
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
    elseif locdegrees == 45
        X=sqrt((radius^2)/2); Y=sqrt((radius^2)/2);
    elseif locdegrees == 135
        X=-sqrt((radius^2)/2); Y=sqrt((radius^2)/2);
    elseif locdegrees == 225
        X=-sqrt((radius^2)/2); Y=-sqrt((radius^2)/2);
    elseif locdegrees == 315
        X=sqrt((radius^2)/2); Y=-sqrt((radius^2)/2);
    end
    %slope_mag = [];
    for i=1:length(cartesian_directions)
        dirlabel=cartesian_directionlabels{i};
        dirtheta=cartesian_directions{i};
        condition = T_example(dirlabel,loclabel); 
        slope_mag = condition{1,1}(2); % just for reference (mag)
        if strcmp(dirlabel,'downwards')
            U=0; V=-slope_mag; colorselect = [0, 0.75, 0.75];
        elseif strcmp(dirlabel,'upwards')
            U=0; V=slope_mag; colorselect = [0, 0, 1];
        elseif strcmp(dirlabel,'rightwards')
            U=slope_mag; V=0; colorselect = [1, 0, 0];
        elseif strcmp(dirlabel,'leftwards')
            U=-slope_mag; V=0; colorselect = [0.8500, 0.3250, 0.0980];
        elseif strcmp(dirlabel,'upperrightwards')
            U=sqrt((slope_mag^2)/2); V=sqrt((slope_mag^2)/2); colorselect = [0.75, 0, 0.75];
        elseif strcmp(dirlabel,'upperleftwards')
            U=-sqrt((slope_mag^2)/2); V=sqrt((slope_mag^2)/2); colorselect = [0.4940, 0.1840, 0.5560];
        elseif strcmp(dirlabel,'lowerrightwards')
            U=sqrt((slope_mag^2)/2); V=-sqrt((slope_mag^2)/2); colorselect = [0, 0.5, 0];
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

title(sprintf('%s sensitivity as vector length', subjname), 'Fontsize', 14)
set(gca,'xtick',[])
set(gca,'xticklabel',[])
set(gca,'ytick',[])
set(gca,'yticklabel',[])
hold off

saveas(gcf,sprintf('%s/pngs/%s_%s_Alldata_4conds.png',figuresdir,subjname, ...
    plotname))
saveas(gcf,sprintf('%s/figs/%s_%s_Alldata_4conds.fig',figuresdir,subjname, ...
    plotname))
saveas(gcf,sprintf('%s/pdfs/%s_%s_Alldata_4conds.pdf',figuresdir,subjname, ...
    plotname))

close all;

end
