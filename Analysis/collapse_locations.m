function [params, total_conditions, PC] = collapse_locations(si, conditions)

new_summary = []; cnt=1;
for fn = fieldnames(conditions{si})'
    if strcmp(fn{1}, 'rownames')
        new_summary.(fn{1}) = conditions{si}.(fn{1});
    else
        if cnt==1
            temp_init = zeros(size(conditions{si}.(fn{1})));
            temp = conditions{si}.(fn{1});
            temp(3,:) = zeros(1,length(conditions{si}.(fn{1})(1,:)));
            cnt=cnt+1;
        else
            temp(1,:) = conditions{si}.(fn{1})(1,:);
            temp(2,:) = conditions{si}.(fn{1})(2,:);
            temp(3,:) = zeros(1,length(conditions{si}.(fn{1})(1,:)));
            temp(4,:) = zeros(1,length(conditions{si}.(fn{1})(4,:))); % same
        end
        temp_init = [temp_init + temp];
    end

end
new_summary.all_locations = temp_init;
new_summary.all_locations(3,:) = new_summary.all_locations(2,:)./new_summary.all_locations(1,:);
PC = new_summary.all_locations(3,:);

[paramsValues,bootparams] = fit_PF(new_summary, [], []);

params = paramsValues.all_locations;

% plot PF 
PropCorrectData = new_summary.all_locations(3,:);
total_conditions = new_summary.all_locations(4,:);


end
