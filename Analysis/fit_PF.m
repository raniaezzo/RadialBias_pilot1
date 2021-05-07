function [params,bootparams] = fit_PF(summary, bootsummary, b_iter)

    for fn = fieldnames(summary)'
        disp(fn{1})
        if strcmp(fn{1}, 'rownames')
            continue
        else
            params.(fn{1}) = summary.(fn{1});

            Index_addedTilt = find(strcmp([summary.rownames], 'AddedTilt'));
            total_conditions = summary.(fn{1})(Index_addedTilt,:);
            Index_numTrials = find(strcmp([summary.rownames], 'NumTrials'));
            numTrials = summary.(fn{1})(Index_numTrials,:);
            Index_clockResp = find(strcmp([summary.rownames], 'AnsClockwise'));
            clockResp = summary.(fn{1})(Index_clockResp,:);

            numLevels = length(total_conditions);
            PF = @PAL_CumulativeNormal; %@PAL_Logistic; %
            bool_paramsFree = [1 1 0 0];
            searchGrid.alpha = [min(total_conditions):0.01:max(total_conditions)];
            searchGrid.beta = [0:0.01:30]; %maybe need to change?
            searchGrid.gamma = 0;
            searchGrid.lambda = 0;

            NumPos = clockResp;
            OutOfNum = numTrials;
            PC1 = clockResp./numTrials;

            [paramsValues LL exitflag] = PAL_PFML_Fit(total_conditions,NumPos, ...
            OutOfNum,searchGrid,bool_paramsFree, PF);
            %disp(paramsValues)
            % save alpha and beta values to new struct
            params.(fn{1}) = paramsValues;
            
            if ~isempty(bootsummary) || b_iter == 0
                disp(sprintf('bootstrapping %s times...',num2str(b_iter)))
                bootparams.(fn{1}) = bootsummary.(fn{1});
                bootParamValues = nan(b_iter,length(paramsValues));
                for bi=1:b_iter
                    NumPos = bootsummary.(fn{1})(bi,:);
                    disp(NumPos)
                    [paramsValues LL exitflag] = PAL_PFML_Fit(total_conditions,NumPos, ...
                    OutOfNum,searchGrid,bool_paramsFree, PF);
                    bootParamValues(bi,:) = paramsValues;
                end
                bootparams.(fn{1}) = bootParamValues;
            else
                bootparams.(fn{1}) = [];
            end
        end
    end
end