%%

% works but not optimal
mainfigure = figure();
p = nsidedpoly(1000, 'Center', [0 0], 'Radius', 7);
plot(p, 'FaceColor', 'none')
ylim([-10 10])
xlim([-10 10])
axis equal
for li=1:length(cartesian_locationdegrees)
    loclabel=cartesian_locationlabels{li};
    locdegrees=cartesian_locationdegrees{li};
    slope_mag = [];
    for i=1:length(cartesian_directions)
        dirlabel=cartesian_directionlabels{i};
        dirtheta=cartesian_directions{i};
        condition = T_example(dirlabel,loclabel); slope_mag = [slope_mag condition{1,1}(2)];
    end
end

[x, y] = pol2cart(deg2rad(cell2mat(cartesian_directions)),slope_mag);
axes('Position',[.3 .3 .2 .2])
box on

max_lim = 2;  % axes must be the same across locations
x_fake=[0 max_lim 0 -max_lim]; 
y_fake=[max_lim 0 -max_lim 0]; 
h_fake=compass(x_fake,y_fake); 
hold on; 
compass(x,y) % get rid of all tics
labels = findall(gca,'type','text');
lines = findall(gca,'Type','line'); %,'LineStyle',':'); % gcf or gca?
hold on
compass(x,y)
set(labels,'visible','off');
set(h_fake,'Visible','off');
set(lines,'Visible','off');

box off






%%

figure
th=linspace(0,2*pi,50);
r=7;
%polarplot(th, r+zeros(size(th)), 'k--', 'LineWidth', 1);
h = polarplot(thetaloc, 7, '.k');
h.MarkerSize=15;
%condition = T_example('leftwards',label); slope_mag = condition{1,1}(2);
hold on
polarplot([thetaloc; thetaloc]*pi/180, [7; 7-slope_mag], 'r', 'LineWidth', 2);
hold on
% will not work for oblique locations..
polarplot([thetaloc]*pi/180, [7-slope_mag], 'r', 'LineWidth', 2);
ax = gca;
rlim([3 10])
thetatickformat('degrees')
thetaticks(0:45:315)
thetaticklabels = (0:90:270);
rticklabels('manual')
ax.RTick = [];
hold on

%%

% compass 


%%

%polarplot(thetaloc, 7-slope_mag);
%polar([0; 0]*pi/180, [0; 1]*54)
%polarplot([thetaloc; thetaloc]*pi/180, [7; 7-slope_mag], 'r', 'LineWidth', 2);
polar([thetaloc; thetaloc]*pi/180, [7; 7-slope_mag]);
ax = gca;
rlim([4 9])
thetatickformat('degrees')
thetaticks(0:45:315)
thetaticklabels = (0:90:270);
rticklabels('manual')
ax.RTick = [];
hold on

%%

figure
h = polar(thetaloc, 7, '.k');
h.MarkerSize=15;
hold on
[X,Y] = pol2cart(thetaloc,7-slope_mag);
quiver(7,thetaloc,-slope_mag,-Y,1.05,'Color','k')


