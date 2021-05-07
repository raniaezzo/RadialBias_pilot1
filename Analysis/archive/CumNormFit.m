%function paramsValues = CumNormFit(total_conditions,NumPos, ...
%            OutOfNum,searchGrid,bool_paramsFree, PF)
        
    numConds = 1; %for now
        
    % Experimental conditions
    titleAngles = total_conditions;
    numLevels = length(total_conditions);
    numTrialsPerL = mean(OutOfNum); % 20 per level (mean = 20)
    
    % set params mu, sigma semi-arbitrarily for starting point
    mu = mean(searchGrid.alpha); % start around 0;
    sigma = mean(searchGrid.beta)*0.3; % slope
    
    % assume lapse & guess rate = 0
    gamma = searchGrid.gamma;
    lambda = searchGrid.lambda;
    
    % cumNorm
    P_tilde = @(x,p) gamma*lambda + (1-lambda).*normcdf(x, p(1), p(2));
    % are these correct?
    nR = NumPos;
    nT_perL = numTrialsPerL;
    
    options = optimoptions(@fmincon, 'MaxIterations', ...
         1e5, 'Display','off');
    nLogL = @(NR, NT, p) -sum(NR.*log(P_tilde(titleAngles,[p(1),p(2)])) + ...
    (NT-NR).*log(1-P_tilde(titleAngles,[p(1),p(2)])));
        
    lb_M2 = [min(searchGrid.alpha),min(searchGrid.alpha)];
    ub_M2 = [max(searchGrid.alpha),max(searchGrid.alpha)];
%     lb_M2 = [0.01];
%     ub_M2 = [2];
    init_M2 = rand*(ub_M2-lb_M2)+lb_M2;
    sign_mu = [-1,1]; %[-1,-1,1,1];
    % 2 free params (PSE, slope)
    M2_nLogL = @(p) sum(arrayfun(@(idx) nLogL(nR(idx,:), nT_perL, ...
        [p(1)*sign_mu(idx), p(2)]), 1:numConds)); 

    [estP_M2, min_NLL_M2] = fmincon(M2_nLogL, init_M2, [],[],[],[], ...
        lb_M2, ub_M2, [], options);
    
    %%
    % i think i need N conditions input to this function (for 1 location)
    figure
    sz = 100;
    scatter(titleAngles, nR(2,:)/nT_perL, sz, 'MarkerEdgeColor', [0 .5 .5], 'MarkerFaceColor',[0 .5 .5])
    hold on
    pcorrect_M2_a = P_tilde(titleAngles, [-estP_M2(1), estP_M2(2)]); 
    plot(titleAngles, pcorrect_M2_a, '--','Color',[0 0.4470 0.7410],'linewidth', 3)
    hold on
    pcorrect_M2_b = P_tilde(titleAngles, [-estP_M2(1), estP_M2(2)]); 
    plot(titleAngles, pcorrect_M2_b, '--','Color',[0 0.4470 0.7410],'linewidth', 3)

%end
        
        