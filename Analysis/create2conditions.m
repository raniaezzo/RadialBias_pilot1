function [summary_radial, summary_tang, bootsummary_radial, ...
    bootsummary_tang] = create2conditions(summary_radialout, ...
    summary_radialin, summary_tangleft, summary_tangright, ...
    bootsummary_radialout, bootsummary_radialin, bootsummary_tangleft, ...
    bootsummary_tangright)
   
    % bootstrap was done separately per location
    % Q: is it okay to add results from bootstrap of separate conditions?
    % Would this over-or underestimate the CIs?
    
    summary_radial = []; bootsummary_radial = [];
    summary_tang = []; bootsummary_tang = [];
    
    % radial
    A = fieldnames(summary_radialout)'; B = fieldnames(summary_radialin)';
    combined = union(A,B);
    for fn = combined
        if strcmp(fn{1}, 'rownames')
            summary_radial.(fn{1}) = summary_radialout.(fn{1});
        elseif isfield(summary_radialin, fn{1}) && isfield(summary_radialout, fn{1})
            NumTrials = summary_radialout.(fn{1})(1,:)+summary_radialin.(fn{1})(1,:);
            NumClockAns = summary_radialout.(fn{1})(2,:)+summary_radialin.(fn{1})(2,:);
            PercClock = NumClockAns./NumTrials;
            TiltVals = summary_radialout.(fn{1})(4,:); % same
            summary_radial.(fn{1}) = [NumTrials;NumClockAns;PercClock;TiltVals];
            bootsummary_radial.(fn{1}) = bootsummary_radialout.(fn{1})+bootsummary_radialin.(fn{1});
        elseif isfield(summary_radialin, fn{1})
            summary_radial.(fn{1}) = summary_radialin.(fn{1});
            bootsummary_radial.(fn{1}) = bootsummary_radialin.(fn{1});
        elseif isfield(summary_radialout, fn{1})
            summary_radial.(fn{1}) = summary_radialout.(fn{1});
            bootsummary_radial.(fn{1}) = bootsummary_radialout.(fn{1});
        end
    end
    
    % tang
    A = fieldnames(summary_tangleft)'; B = fieldnames(summary_tangright)';
    combined = union(A,B);
    for fn = combined
        if strcmp(fn{1}, 'rownames')
            summary_tang.(fn{1}) = summary_tangleft.(fn{1});
        elseif isfield(summary_tangright, fn{1}) && isfield(summary_tangleft, fn{1})
            NumTrials = summary_tangleft.(fn{1})(1,:)+summary_tangright.(fn{1})(1,:);
            NumClockAns = summary_tangleft.(fn{1})(2,:)+summary_tangright.(fn{1})(2,:);
            PercClock = NumClockAns./NumTrials;
            TiltVals = summary_tangleft.(fn{1})(4,:); % same
            summary_tang.(fn{1}) = [NumTrials;NumClockAns;PercClock;TiltVals];
            bootsummary_tang.(fn{1}) = bootsummary_tangleft.(fn{1})+bootsummary_tangright.(fn{1});
        elseif isfield(summary_tangright, fn{1})
            summary_tang.(fn{1}) = summary_tangright.(fn{1});
            bootsummary_tang.(fn{1}) = bootsummary_tangright.(fn{1});
        elseif isfield(summary_tangleft, fn{1})
            summary_tang.(fn{1}) = summary_tangleft.(fn{1});
            bootsummary_tang.(fn{1}) = bootsummary_tangleft.(fn{1});
        end
    end
    
end