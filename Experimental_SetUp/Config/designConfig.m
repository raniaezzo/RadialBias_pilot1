function [expDes]=designConfig(const)
% ----------------------------------------------------------------------
% [expDes]=designConfig(const)
% ----------------------------------------------------------------------
% Goal of the function :
% Compute an experimental randomised matrix containing all variable data
% used in the experiment.
% ----------------------------------------------------------------------
% Input(s) :
% const : struct containing all constant configurations.
% ----------------------------------------------------------------------
% Output(s):
% expDes : struct containg all variable data randomised.
% ----------------------------------------------------------------------

%% Experimental variables 

% Var 1 : Polar angle locations [2 modalitie(s)] % at any/one eccentricity
expDes.oneV =[1:2]';
    % polar angle = 45 deg
    % polar angle = 225 deg
    % ** can also change to 135 and 315 for another subject

% Var 2 : Motion/Orientation references [4 modalities - 1]
expDes.twoV = [1:2]';  % [1:4]';  to include radial & tangential
   
% Var 3 : CounterClockwise / Clockwise
expDes.threeV = [1:2]';

% unused
% Var 3 : Target interval [2 modalitie(s)]
%expDes.threeV = [1;2];
%expDes.threeV = [1];
    %  1 = 1st interval
    %  2 = 2nd interval

% unused
% Var 4 : Experimental condition [4 modalitie(s)]
%expDes.fourV = [1:2]';
expDes.fourV = [1]'; % drifting gratings only (also code for plaids)
    %  1 = Drifting gratings
    %  2 = Stationary plaids
    %  3 = Drifting plaids
    %  4 = Drifting plaids (w/ shifts)



%% Experimental configuration :
expDes.var1_list = expDes.oneV;
expDes.nb_var1= numel(expDes.var1_list); % count distict types
expDes.var2_list = expDes.twoV;
expDes.nb_var2= numel(expDes.var2_list);
expDes.var3_list = expDes.threeV;
expDes.nb_var3= numel(expDes.var3_list);
expDes.var4_list = expDes.fourV;
expDes.nb_var4= numel(expDes.var4_list);

%expDes.random1_list = expDes.oneR;
%expDes.nb_random1= numel(expDes.random1_list);

expDes.nb_var  = 2; %expDes.nb_var  = 3;
expDes.nb_rand = 1;

expDes.nb_repeat = 4; % changed this from 1
%expDes.nb_trials = expDes.nb_var1 * expDes.nb_var2 * expDes.nb_var3 * expDes.nb_var4 * expDes.nb_repeat;
expDes.nb_trials = expDes.nb_var1 * expDes.nb_var2 * expDes.nb_var3 * expDes.nb_repeat;

expDes.timePauseMin = 15;
expDes.timePause = expDes.timePauseMin*60;

%% Experimental loop
trialMat = zeros(expDes.nb_trials,expDes.nb_var);
ii = 0;
for iv1=1:expDes.nb_var1
    for iv2=1:expDes.nb_var2
        for iv3=1:expDes.nb_var3
            for rr= 1:expDes.nb_repeat
                ii = ii + 1;
                trialMat(ii, 1) = iv1;
                trialMat(ii, 2) = iv2;
                trialMat(ii, 3) = iv3;
            end
        end
    end
end

rand('state',sum(100*clock));
trialMat = trialMat(randperm(expDes.nb_trials),:);
for t_trial = 1:expDes.nb_trials
    
    rand_var1 = expDes.var1_list(trialMat(t_trial,1),:);
    rand_var2 = expDes.var2_list(trialMat(t_trial,2),:);
    rand_var3 = expDes.var3_list(trialMat(t_trial,3),:);
    
    %randVal1 = randperm(expDes.nb_random1); rand_random1 = expDes.oneR(randVal1(1));
    
    %while rand_random1 == rand_var1
    %    randRandom1 = randperm(expDes.nb_random1);
    %    rand_random1 = randRandom1(1);
    %end
    
    expDes.j = t_trial;
    %expDes.expMat(expDes.j,:)= [const.fromBlock,t_trial,rand_var1,rand_var2,rand_var3,rand_random1];
    expDes.expMat(expDes.j,:)= [const.fromBlock,t_trial,rand_var1,rand_var2,rand_var3]; %,rand_random1];
end


%% Saving procedure :

% .mat file
save(const.design_fileMat,'expDes');

end
