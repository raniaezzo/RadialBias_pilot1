    
% create param table for each location (re-arraging from struct)
T_example = [struct2table(params_radialin); struct2table(params_radialout); ...
    struct2table(params_tangright); struct2table(params_tangleft)];
T_example.Properties.RowNames = {'radialin'; 'radialout';'tangright'; 'tangleft'};
    


for i=1:length(locationlabels)
    label=locationlabels{i};
    thetaloc=locationdegrees{i};
end

condition = T_example('radialin',label); slope_mag = condition{1,1}(2);

    setangle = 0.4;
    setlength = 0.5;

    %%%Data %%%%
    %in radians (angle around 360)
    resultant_direction = deg2rad(thetaloc+180); 
    %resultant_direction = 0.5 + (1-0.5).*(thetaloc);
    % length of the vector
    resultant_length = slope_mag+7;
    
    %%%%arrow head %%%%
    % arrow head length relative to resultant_length
    arrowhead_length    = resultant_length/20; 
    % fills in the triangle
    num_arrowlines = 100;
    arrowhead_angle = deg2rad(30); % degrees
    
    %%%%arrow tip coordinates %%%%
    t1 = repmat(resultant_direction,1,num_arrowlines);
    r1 = repmat(resultant_length,1,num_arrowlines);
    
    %%%%arrow base coordinates %%%%
    b = arrowhead_length.*tan(linspace(0,arrowhead_angle,num_arrowlines/2));
    theta = atan(b./(resultant_length-arrowhead_length));
    pre_t2 = [theta, -theta];
    r2 = (resultant_length-arrowhead_length)./cos(pre_t2);
    t2 = t1(1)+pre_t2;
    
    %%%%plot %%%%
    figure(1)
    % [angle angle] [eccentricity eccentricity]
    polarplot([t1(1) t1(1)],[7 r1(1)-0.9*arrowhead_length],'r','linewidth',3)
    hold on
    polarplot([t1; t2],[r1; r2],'r')