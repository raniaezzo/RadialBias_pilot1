function [resMat, xUpdate_tilt]=runSingleTrial(scr,const,expDes,my_key,t)
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

% polar angle location (for now, 1 eccentricity)
loc_target = expDes.expMat(t, 3); % this is the first exp variable e.g. [1,2,3,4]
%motiondir_target = expDes.expMat(t, 4); % this is the second exp variable
%(instead reading directly from params below)
test_target = expDes.expMat(t,5); % this is the counterclockwise vs clockwise shift
angle_abs = expDes.expMat(t,6); % angle

orientation = const.params.motiondirection; % feed into orientation for gabor (real orientation actually -90)

if loc_target == 1  % loc 1 = lower right, loc 2 = upper left
    xDist = const.gaborDist_xpix;
    yDist = const.gaborDist_ypix;  
elseif loc_target == 2
    xDist = -(const.gaborDist_xpix);
    yDist = -(const.gaborDist_ypix);
elseif loc_target == 3
    xDist = -(const.gaborDist_xpix);
    yDist = (const.gaborDist_ypix);  
elseif loc_target == 4
    xDist = (const.gaborDist_xpix);
    yDist = -(const.gaborDist_ypix);
elseif loc_target == 5 % added here and below for cardinal
    xDist = 0;
    yDist = -(const.gaborDist_ypix);
elseif loc_target == 6
    xDist = 0;
    yDist = (const.gaborDist_ypix);
elseif loc_target == 7
    xDist = -(const.gaborDist_xpix);
    yDist = 0;
elseif loc_target == 8
    xDist = (const.gaborDist_xpix);
    yDist = 0;
end

% update the added tilt based on the staircase or just use constant (for
% cond w/o staircase)

if test_target == 1
    clockwise_target = 1;
elseif test_target == 2
    clockwise_target = -1;
end

% take value of staircase and add (+ or -) angle shift for clockwise /
% counterclockwise motion [note: orientation and motion cc value is the same]
standard = orientation; % orienation of 0 is vertical (+90); this value = motion direction
if const.use_staircase
    orientation = orientation + (const.stairs.xCurrent * clockwise_target); 
    %save staircase values
    stairValues(t, :) = [const.stairs.xCurrent];
else
    orientation = orientation + (angle_abs * clockwise_target);
end

disp('location')
disp(loc_target)
disp('standard direction (0 is 9oclock motion, 90 is 12oclock, etc)')
disp(standard)
disp('direction (updated w/ tilt)')
disp(orientation)

if orientation > standard
    disp('clockwise')
    clockwise = 1;
else
    disp('counterclockwise')
    clockwise = 0;
end


%% Main loop

for tframes = 1:const.numFrm_Tot
    Screen('FillRect',scr.main,const.colBG);

    %% First interval
    % T1
    if tframes >= const.numFrm_T1_start && tframes <= const.numFrm_T1_end
        my_fixation(scr,const,const.black);
    end
    
    % T2
    %if tframes == const.numFrm_T2_start
    if tframes >= const.numFrm_T2_start && tframes <= const.numFrm_T2_end
        %my_sound(const); % do not use sound (replace w/ feedback)
    end
    
    % T3
    %if tframes >= const.numFrm_T3_start && tframes <= const.numFrm_T3_end
    if tframes == const.numFrm_T3_start
        my_stim(scr,const,const.black, tframes, const.numFrm_T3_end,xDist,yDist, orientation, t);
    end

    vbl = Screen('Flip',scr.main);

%end

% Answer screen
    if tframes >= const.numFrm_T3_end
        [key_press,tRT]=getAnswer(scr,const,my_key);
        tRT = tRT - vbl;
    end

end

OUT_stand_direction = flipangle(standard);
OUT_test_direction = flipangle(orientation);
OUT_stand_orientation = mod(OUT_stand_direction+90, 180);
OUT_test_orientation = mod(OUT_test_direction+90, 180);

% HACK to make analysis code simpler (can fix later)
if OUT_stand_direction == 0 % make counterclockwise for 0 e.g. -5 instead of 355
    OUT_test_direction = (360-OUT_test_direction)*-1;
end

if key_press.rightShift == 1
    % evaluate correct/incorrect
    if clockwise == 1 %clockwise_target == 1 % when stimulus is clockwise relative to standard
        correct = 1;
    else
        correct = 0;
    end
    resMat = [OUT_stand_orientation, OUT_test_orientation, OUT_stand_direction, OUT_test_direction, clockwise, 2,tRT, correct]; % was just 2, tRT before
elseif key_press.leftShift == 1
    % evaluate correct/incorrect
    if clockwise == 0 %clockwise_target == -1 % when stimulus is clockwise relative to standard
        correct = 1;
    else
        correct = 0;
    end
    resMat = [OUT_stand_orientation, OUT_test_orientation, OUT_stand_direction, OUT_test_direction, clockwise, 1,tRT, correct];
elseif key_press.space == 1  % pause
    correct = NaN;
    resMat = [OUT_stand_orientation, OUT_test_orientation, OUT_stand_direction, OUT_test_direction, clockwise, -1,tRT, correct];
elseif key_press.escape == 1
    correct = NaN;
    resMat = [OUT_stand_orientation, OUT_test_orientation, OUT_stand_direction, OUT_test_direction, clockwise, NaN,tRT, correct];
    %overDone;
end


if (key_press.rightShift == 1) || (key_press.leftShift == 1)
    %if correct == 0
    %    my_sound(const) % no longer using
    %end
    if correct == 0
        makeBeep(.1,400)
    elseif correct == 1
        makeBeep(.1,800)
    end
    disp('Correct = ')
    disp(correct)

    % adjust staircase level
    if const.use_staircase
        % for now just assume all are correct (just to check code)
        const.stairs = usePalamedesStaircase(const.stairs, correct); 
        disp('Palamedes output')
        disp(const.stairs)
        disp('Adjusted tilt to add')
        disp(const.stairs.xCurrent)
        xUpdate_tilt = const.stairs.xCurrent; % added new tilt
        const.stairvec = [const.stairvec, const.stairs]; 
    else
        %xUpdate_tilt = const.stairs.xCurrent; % use current if not staircased
        %constant_stimuli = ; %[1, 2, 2.5, 3, 5, 6, 8];
        xUpdate_tilt = NaN; %randsample(constant_stimuli,1);
    end
    disp('~~~~~~~~~~~~~~~ end of trial ~~~~~~~~~~~~~~')
elseif key_press.space == 1
    xUpdate_tilt = NaN;
    disp('~~~~~~~~~~~~~~~ requested break ~~~~~~~~~~~~~~')
elseif key_press.escape == 1
    xUpdate_tilt = NaN;
    %overDone;
    disp('~~~~~~~~~~~~~~~ aborted trial ~~~~~~~~~~~~~~')
end



end