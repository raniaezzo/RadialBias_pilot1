function [resMat]=runSingleTrial(scr,const,expDes,my_key,t)
% ----------------------------------------------------------------------
% [resMat] = runSingleTrial(scr,const,expDes,my_key,t)
% ----------------------------------------------------------------------
% Goal of the function :
% Main file of the experiment. Draw each sequence and return results.
% ----------------------------------------------------------------------
% Input(s) :
% scr : window pointer.
% const : struct containing all the constant configurations.
% expDes : struct containing all the variable design configurations.
% my_key : keyboard keys names.
% t : experiment meter.
% ----------------------------------------------------------------------
% Output(s):
% resMat(1) : experimental results
%          => = 1 : first interval
%          => = 2 : second interval
%          => = -1 : Voluntary brake 
% resMat(2) : Reaction time
% ----------------------------------------------------------------------

while KbCheck; end
FlushEvents('KeyDown');

% TO DO
% add expDes params to the experiment for 4 paradigms (gratings, plaids,
% etc., and add gaussian temporal envelope, also define the interval of the "standard" grating)

%% Main loop

for tframes = 1:const.numFrm_Tot
    Screen('FillRect',scr.main,const.colBG);

    %% First interval
    % T1
    if tframes >= const.numFrm_T1_start && tframes <= const.numFrm_T1_end
        my_fixation(scr,const,const.black);
    end
    
    % T2
    if tframes == const.numFrm_T2_start
        my_sound(1); % isi
    end
    
    % T3
    %if tframes >= const.numFrm_T3_start && tframes <= const.numFrm_T3_end
    if tframes == const.numFrm_T3_start
        my_stim(scr,const,const.black, tframes, const.numFrm_T3_end);
    end

    %% Second interval
    % T4
    if tframes >= const.numFrm_T4_start && tframes <= const.numFrm_T4_end
        my_fixation(scr,const,const.black);
    end
    
    % T5
    if tframes >= const.numFrm_T5_start && tframes <= const.numFrm_T5_end
        % isi
    end
    
    % T6
    %if tframes >= const.numFrm_T6_start && tframes <= const.numFrm_T6_end
    if tframes == const.numFrm_T6_start
        my_stim(scr,const,const.black, tframes, const.numFrm_T6_end);
    end
    
    vbl = Screen('Flip',scr.main);

end

% Answer screen
[key_press,tRT]=getAnswer(scr,const,my_key);
tRT = tRT - vbl;

if key_press.rightShift == 1
    resMat = [2,tRT];
elseif key_press.leftShift == 1
    resMat = [1,tRT];
elseif key_press.space == 1
    resMat = [-1,tRT];
elseif key_press.escape == 1
    overDone;
end
    
end