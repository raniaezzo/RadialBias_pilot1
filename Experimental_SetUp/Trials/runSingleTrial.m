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
loc_target = expDes.expMat(t, 3); % this is the first exp variable
motiondir_target = expDes.expMat(t, 4); % this is the second exp variable
test_target = expDes.expMat(t,5); % this is the counterclockwise vs clockwise shift

% motiondir_target = 3; % just for debugging % get rid of

if loc_target == 1   % loc 1 = lower right, loc 2 = upper left
    xDist = const.gaborDist_xpix;
    yDist = const.gaborDist_ypix;
    if motiondir_target == 1 %counterclock tang motion
        orientation = 45;  % is actually 135 deg gratational coordinates
        motionsign = -1;
        abs_motiondir = 0; % to calculate abs motion dir (grav coord)
    elseif motiondir_target == 2 % clockwise tang motion
        orientation = 45;
        motionsign = 1;
        abs_motiondir = 180;
    elseif motiondir_target == 3 % radial inwards
        orientation = 135;
        motionsign = 1;
        abs_motiondir = 0;
    elseif motiondir_target == 4 % radial outwards
        orientation = 135;
        motionsign = -1;
        abs_motiondir = 180; 
    end
elseif loc_target == 2
    xDist = -(const.gaborDist_xpix);
    yDist = -(const.gaborDist_ypix);
    if motiondir_target == 1 %counterclock tang motion
        orientation = 45;
        motionsign = 1; 
        abs_motiondir = 180;
    elseif motiondir_target == 2 % clockwise tang motion
        orientation = 45;
        motionsign = -1;
        abs_motiondir = 0;
    elseif motiondir_target == 3 % radial inwards
        orientation = 135;
        motionsign = -1;
        abs_motiondir = 180;
    elseif motiondir_target == 4 % radial outwards
        orientation = 135;
        motionsign = 1;
        abs_motiondir = 0;
    end
else % center if code # is not defined
    xDist = 0;
    yDist = 0;
    orientation = 90; % other
    motionsign = 1;
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
disp('standard (in terms of orientation)')
standard = orientation;
disp(standard)
orientation = orientation + (const.stairs.xCurrent * clockwise_target); 
disp('location')
disp(loc_target)
disp('motiondir (in/out)')
disp(motiondir_target)
disp('orientation (updated w/ tilt)')
disp(orientation)

if orientation > standard
    disp('counterclockwise')
    clockwise = 0;
else
    disp('clockwise')
    clockwise = 1;
end

%save staircase values
stairValues(t, :) = [const.stairs.xCurrent];


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
    %if tframes >= const.numFrm_T2_start && tframes <= const.numFrm_T2_end
        %my_sound(1); % isi
        my_sound(const);
    end
    
    % T3
    %if tframes >= const.numFrm_T3_start && tframes <= const.numFrm_T3_end
    if tframes == const.numFrm_T3_start
        my_stim(scr,const,const.black, tframes, const.numFrm_T3_end,xDist,yDist, orientation, motionsign);
    end

    vbl = Screen('Flip',scr.main);

end

% Answer screen
[key_press,tRT]=getAnswer(scr,const,my_key);
tRT = tRT - vbl;

if key_press.rightShift == 1
    % evaluate correct/incorrect
    if clockwise == 1 %clockwise_target == 1 % when stimulus is clockwise relative to standard
        correct = 1;
    else
        correct = 0;
    end
    % orientation+90 gives static orientation of grating (0=90 deg)
    % standard+90 gives static orientation of internal grating (0=90 deg)
    % orientation*motionsign absolute motion direction (in degrees) --
    % orthogonal to orientation (direction)
    resMat = [standard+90, orientation+90, standard+abs_motiondir, orientation+abs_motiondir, clockwise, 2,tRT, correct]; % was just 2, tRT before
elseif key_press.leftShift == 1
    % evaluate correct/incorrect
    if clockwise == 0 %clockwise_target == -1 % when stimulus is clockwise relative to standard
        correct = 1;
    else
        correct = 0;
    end
    resMat = [standard+90, orientation+90, standard+abs_motiondir, orientation+abs_motiondir, clockwise, 1,tRT, correct];
elseif key_press.space == 1
    correct = 0;
    resMat = [standard+90, orientation+90, standard+abs_motiondir, orientation+abs_motiondir, clockwise, -1,tRT, correct];
elseif key_press.escape == 1
    overDone;
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
    xUpdate_tilt = const.stairs.xCurrent; % use current if not staircased
end

disp('~~~~~~~~~~~~~~~ end of trial ~~~~~~~~~~~~~~')

end