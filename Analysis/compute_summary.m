function [datasummary, rownames,bootsAns_levels] = ...
    compute_summary(select_data, b_iter) % bootsAns_levels to output

% out of 200 trials (this is specific location, and condition)
% e.g. 200 radial out trials in upper right loc
angle_adjustments = unique(select_data(:,6)); % this is 5

anglep_clockwans = [];
anglep_nTrials = [];
anglen_clockwans = [];
anglen_nTrials = [];

if b_iter > 0
    simulated_anglenClockAns = NaN(b_iter,length(angle_adjustments));
    simulated_anglepClockAns = NaN(b_iter,length(angle_adjustments));
end

for angle_idx=1:length(angle_adjustments)
    angle = angle_adjustments(angle_idx);
    level = select_data(select_data(:,6) == angle ,:);
    level_pc = sum(level(:,14))/length(level(:,14));

    % these are 20 trials each
    actual_clockwise_level = level(level(:,11) == 1,:); 
    actual_cclockwise_level = level(level(:,11) ~= 1,:);
    [c_row, ~] = size(actual_clockwise_level);
    [cc_row, ~] = size(actual_clockwise_level);
    
    anglep_nTrials = [anglep_nTrials size(actual_clockwise_level,1)];
    anglep_clockwans = [anglep_clockwans size(actual_clockwise_level(actual_clockwise_level(:,12) == 2,:),1)];
    anglen_nTrials = [anglen_nTrials size(actual_cclockwise_level,1)];
    anglen_clockwans = [anglen_clockwans size(actual_cclockwise_level(actual_cclockwise_level(:,12) == 2,:),1)];
    
    actual_clockwise_level_cans = actual_clockwise_level(:,12);
    actual_cclockwise_level_cans = actual_cclockwise_level(:,12);
    
    if b_iter > 0
        %simulated_clockBool = NaN(b_iter,c_row); % for 1 angle
        %simulated_cclockBool = NaN(b_iter,cc_row);
        % do counterclockwise values, clockwise values separately
        for i=1:b_iter
            % sample with replacement (default)
            % sum across columns of sampledata
            %disp(sum(datasample(actual_clockwise_level, c_row)))
            simc_clockcount = datasample(actual_clockwise_level_cans, c_row);
            simulated_anglepClockAns(i, angle_idx) = length(simc_clockcount(simc_clockcount == 2));
            simcc_clockcount = datasample(actual_cclockwise_level_cans, cc_row);
            simulated_anglenClockAns(i, angle_idx) = length(simcc_clockcount(simcc_clockcount == 2));
        end
        % save! and output function
    end 
end

nTrials_levels = [flip(anglen_nTrials) anglep_nTrials];
clockAns_levels = [flip(anglen_clockwans) anglep_clockwans];
perCorrect_levels = clockAns_levels ./ nTrials_levels;

tiltArray = [flip(angle_adjustments*-1); angle_adjustments]';

if b_iter > 0
    bootsAns_levels = [flip(simulated_anglenClockAns,2), simulated_anglepClockAns];
else
    bootsAns_levels = [];
end

datasummary = [nTrials_levels;clockAns_levels;perCorrect_levels;tiltArray];

rownames = {'NumTrials';'AnsClockwise';'PercAnsClockwise';'AddedTilt'};

end