function fit_PF(cond_dirs, b_iter)

    for ci=1:length(cond_dirs)
        load(fullfile(cond_dirs{ci},'summarytable'));
        load(fullfile(cond_dirs{ci},'summarybootstraps'));

        summarymatrix = table2array(summarytable);
        
        if any(isnan(summarymatrix), 'all')
            paramsValues = nan(1,4);
            save(fullfile(cond_dirs{ci},'params'),'paramsValues')
            save(fullfile(cond_dirs{ci},'abs_params'),'paramsValues')
        else
        
            total_conditions = table2array(summarytable({'AddedTilt'},:));
            numTrials = table2array(summarytable({'NumTrials'},:));
            clockResp = table2array(summarytable({'AnsClockwise'},:));

            numLevels = length(total_conditions);
            PF = @PAL_CumulativeNormal; %@PAL_Logistic; %
            bool_paramsFree = [1 1 0 0];
            searchGrid.alpha = [min(total_conditions):0.01:max(total_conditions)];
            searchGrid.beta = [0:0.01:48]; %maybe need to change?
            searchGrid.gamma = 0;
            searchGrid.lambda = 0;

            NumPos = clockResp;
            OutOfNum = numTrials;
            PC1 = clockResp./numTrials;

            %[paramsValues LL exitflag] = PAL_PFML_Fit(total_conditions,NumPos, ...
            %OutOfNum,searchGrid,bool_paramsFree, PF);

            NumNeg = OutOfNum - NumPos;
            [uEst, varEst] = FitCumNormYN_cg(total_conditions, NumPos, ...
                        NumNeg);
            paramsValues = [uEst, 1/sqrt(varEst), 0, 0];
            save(fullfile(cond_dirs{ci},'params'),'paramsValues')

            paramsValues = abs(paramsValues);
            save(fullfile(cond_dirs{ci},'abs_params'),'paramsValues')
        end

        if ~(b_iter == 0)
            
            if any(isnan(summarybootstraps), 'all')
                bootParamValues = nan(1,4);
                save(fullfile(cond_dirs{ci},'params_boot'),'bootParamValues')
                save(fullfile(cond_dirs{ci},'abs_params_boot'),'bootParamValues')
            else
            
                tic;
                disp(sprintf('bootstrapping %s times...',num2str(b_iter)))
                bootParamValues = nan(b_iter,length(paramsValues));
                for bi=1:b_iter
                    NumPos = summarybootstraps(bi,:);
                    NumNeg = OutOfNum - NumPos;
                    [uEst, varEst] = FitCumNormYN_cg(total_conditions, NumPos, ...
                        NumNeg);
                    paramsValues = [uEst, 1/sqrt(varEst), 0, 0];
                    %[paramsValues LL exitflag] = PAL_PFML_Fit(total_conditions,NumPos, ...
                    %OutOfNum,searchGrid,bool_paramsFree, PF);
                    bootParamValues(bi,:) = paramsValues;
                end
                disp('elapsed time = ')
                toc
                
                save(fullfile(cond_dirs{ci},'params_boot'),'bootParamValues')

                bootParamValues = abs(bootParamValues);
                save(fullfile(cond_dirs{ci},'abs_params_boot'),'bootParamValues')
            end

        end
    end
end