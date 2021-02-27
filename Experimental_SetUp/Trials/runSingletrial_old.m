% temp

% polar angle location (for now, 1 eccentricity)
loc_target = expDes.expMat(t, 3); % this is the first exp variable
motiondir_target = expDes.expMat(t, 4); % this is the second exp variable
test_target = expDes.expMat(t,5); % this is the counterclockwise vs clockwise shift
angle_abs = expDes.expMat(t,6); % angle

% motiondir_target = 3; % just for debugging % get rid of

if (loc_target == 1) || (loc_target == 3)   % loc 1 = lower right, loc 2 = upper left
    xDist = const.gaborDist_xpix;
    yDist = const.gaborDist_ypix;
    if motiondir_target == 1 
        orientation = 45;  % is actually 135 deg gratational coordinates
        motionsign = -1;
        abs_motiondir = 0; % to calculate abs motion dir (grav coord)
    elseif motiondir_target == 2 
        orientation = 45;
        motionsign = 1;
        abs_motiondir = 180;
    elseif motiondir_target == 3 
        orientation = 135;
        motionsign = 1;
        abs_motiondir = 0;
    elseif motiondir_target == 4 
        orientation = 135;
        motionsign = -1;
        abs_motiondir = 180; 
    end
elseif (loc_target == 2) || (loc_target == 4) % get rid of this section (due to recent changes)
    xDist = -(const.gaborDist_xpix);
    yDist = -(const.gaborDist_ypix);
    if motiondir_target == 1 %counterclock tang motion
        orientation = 45;
        motionsign = -1; %1; 
        abs_motiondir = 0; %180;
    elseif motiondir_target == 2 % clockwise tang motion
        orientation = 45;
        motionsign = 1; %-1;
        abs_motiondir = 180; %0;
    elseif motiondir_target == 3 % radial inwards
        orientation = 135;
        motionsign = 1; %-1;
        abs_motiondir = 0; %180;
    elseif motiondir_target == 4 % radial outwards
        orientation = 135;
        motionsign = -1; %1;
        abs_motiondir = 180; %0;
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
disp('location')
disp(loc_target)
disp('motiondir (reference type)')
disp(motiondir_target)
disp('standard (in terms of direction)')
standard = orientation; % orienation of 0 is vertical (+90); this value = motion direction
disp(standard)
disp('direction (updated w/ tilt)')