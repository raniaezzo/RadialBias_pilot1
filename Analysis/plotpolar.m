function plotpolar(paramsetting, subjname, params_radialout, ...
        params_radialin, params_tangleft, params_tangright, mapdegree)
    
    if strcmp(paramsetting, 'bias')
        paramidx = 1;
    elseif strcmp(paramsetting, 'sensitivity')
        paramidx = 2;
    end
    
    figure
    Axis = gca; % current axes
    
    main_conditions = {params_radialout,params_radialin,params_tangleft,params_tangright};
    colors = ['g','b','r','m'];
    possiblethetas_deg = linspace(0,315,8); % [0 45 90 135 180 225 270 315];
    
    for i=1:length(main_conditions) % conditions
        theta = []; rho = [];
        for fn = fieldnames(main_conditions{i})' % locations
            %disp(fn{1})
            theta = [theta deg2rad(mapdegree(fn{1}))];
            rho = [rho main_conditions{i}.(fn{1})(paramidx)];
        end
        [theta,idx] = sort(theta); % order theta from least two greatest
        rho = rho(idx);
        % insert empty [] for data not yet collected -- clean this up later
        possiblethetas_rad = deg2rad(possiblethetas_deg);
        emtyidx = ismember(num2str(possiblethetas_rad'), num2str(theta'), 'rows')';
        emtyidx = double(emtyidx); emtyidx(~emtyidx)=nan;
        newtheta = emtyidx.*possiblethetas_rad; theta = newtheta; 
        % actually, I can just do this:
        theta = possiblethetas_rad;
        cnt = 1;
        for pp=1:length(emtyidx)
            if isnan(emtyidx(pp))
                continue
            else
               emtyidx(pp) = rho(cnt);
               cnt = cnt+1;
            end
        end
        new_rho = emtyidx; rho = new_rho;
            
        if strcmp(paramsetting, 'bias')
            rho = abs(rho);
        end
        %if strcmp(paramsetting, 'sensitivity')
        %    rho = 1./rho; % compute 1/sigma 
        %end
        disp(theta)
        disp(rho)
        polarscatter(theta, rho, colors(i))
        hold on
        if length(theta) > 2
            polarplot([theta theta(1)], [rho rho(1)], colors(i));
            hold on
        end
        thetaticks(possiblethetas_deg);
    end
    
    % change 'slope' to 'sensitivity' when computing 1/sigma
    titlename = sprintf('%s Polar Plot: %s',subjname, paramsetting);
    title(titlename, 'FontSize', 14)
    L1 = polarplot(nan, nan, 'color', colors(1));
    L2 = polarplot(nan, nan, 'color', colors(2));
    L3 = polarplot(nan, nan, 'color', colors(3));
    L4 = polarplot(nan, nan, 'color', colors(4));
    legend([L1, L2, L3,L4], {'radialout', 'radialin','tangleft','tangright'})
    
end