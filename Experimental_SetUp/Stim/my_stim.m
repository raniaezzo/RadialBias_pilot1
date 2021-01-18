function my_stim(scr,const,color,tframes, endframe, xDist, yDist, orientation, motionsign)
% ----------------------------------------------------------------------
% my_stim(scr,color,x,y,sideX,sideY)
% ----------------------------------------------------------------------
% Goal of the function :
% Draw the texture (gratings/plaid)
% ----------------------------------------------------------------------
% Input(s) :
% scr = Window Pointer                              ex : w
% color = color of the circle in RBG or RGBA        ex : color = [0 0 0]
% const = structure containing constant configurations.
% tframes = current frame
% endframe = frame to end the stimulus
% ----------------------------------------------------------------------
% Output(s):
% ----------------------------------------------------------------------

% Get the centre coordinate of the window
[x, y] = RectCenter(scr.rect);

% xCenter = scr.x_mid;
% yCenter = scr.y_mid;

% for fixation
xCenter = x;
yCenter = y;

% for annulus
xLoc = x+xDist;
yLoc = y+yDist;

% added
% Dimensions
gaborDimPix = const.gaborDim_xpix;

% Sigma of Gaussian
sigma = gaborDimPix / 6;

% Obvious Parameters
%orientation = 0; 
contrast = 1; %0.5;
aspectRatio = 1.0;

% Spatial Frequency (Cycles Per Pixel)
% One Cycle = Grey-Black-Grey-White-Grey i.e. One Black and One White Lobe
numCycles = const.gaborSF_xpix; % correction: pixels per cycle
freq = 1/numCycles;

% Build a procedural gabor texture
gabortex = CreateProceduralGabor(scr.main, gaborDimPix, gaborDimPix,...
    [], [0.5 0.5 0.5 0.0], 1, 0.5);

% Positions of the Gabors
%dim = 10;
x=0 ; y=0;

% Calculate the distance in "Gabor numbers" of each gabor from the center
% of the array
dist = sqrt(x.^2 + y.^2);
%dist = sqrt(xLoc.^2 + yLoc.^2);

% Cut out an inner annulus
innerDist = 0;
 
% Cut out an outer annulus
outerDist = 10;
x(dist >= outerDist) = nan;
y(dist >= outerDist) = nan;
%xLoc(dist >= outerDist) = nan;
%yLoc(dist >= outerDist) = nan;

% Center the annulus coordinates in the centre of the screen
%xPos = x .* gaborDimPix + xCenter;
%yPos = y .* gaborDimPix + yCenter;
xPos = x .* gaborDimPix + xLoc;
yPos = y .* gaborDimPix + yLoc;

% Count how many Gabors there are
nGabors = numel(xPos);

% Make the destination rectangles for all the Gabors in the array
baseRect = [0 0 gaborDimPix gaborDimPix];
allRects = nan(4, nGabors);
for i = 1:nGabors
    allRects(:, i) = CenterRectOnPointd(baseRect, xPos(i), yPos(i));
end

ifi = Screen('GetFlipInterval', scr.main);

% Drift speed for the 2D global motion
degPerSec = 360 * const.numCycles_deg * 4; % added the 4 for 4 deg/sec
degPerFrame =  degPerSec * ifi;

% Randomise the Gabor orientations and determine the drift speeds of each gabor.
% This is given by multiplying the global motion speed by the cosine
% difference between the global motion direction and the global motion.
% Here the global motion direction is 0. So it is just the cosine of the
% angle we use. We re-orientate the array when drawing

% try using this instead?
angle_options = [orientation]; %[45, 135, 225, 315]; %I think I only need 2 orientations 
randomIndex = randi(length(angle_options), 1);
gaborAngles = angle_options(randomIndex);
%%gaborAngles = rand(1, nGabors) .* 180 - 90;


degPerFrameGabors =  cosd(gaborAngles) .* degPerFrame;

% Randomise the phase of the Gabors and make a properties matrix. We could
% if we want have each Gabor with different properties in all dimensions.
% Not just orientation and drift rate as we are doing here.
% This is the power of using procedural textures

phaseLine = 360;          %rand(1, nGabors) .* 360;
propertiesMat = repmat([NaN, freq, sigma, contrast, aspectRatio, 0, 0, 0],...
    nGabors, 1);
propertiesMat(:, 1) = phaseLine';

% Perform initial flip to gray background and sync us to the retrace:
vbl = Screen('Flip', scr.main);

% Numer of frames to wait before re-drawing
waitframes = 1;

% Animation loop 
%while ~KbCheck
for i = tframes:endframe

        % Set the right blend function for drawing the gabors
        Screen('BlendFunction', scr.main, 'GL_ONE', 'GL_ZERO');

        % Batch draw all  of the Gabors to screen
%         Screen('DrawTextures', scr.main, gabortex, [], allRects, gaborAngles - 90,...
%             [], [], [], [], kPsychDontDoRotation, propertiesMat');
        Screen('DrawTextures', scr.main, gabortex, [], allRects, gaborAngles,...
            [], [], [], [], kPsychDontDoRotation, propertiesMat');

        % Change the blend function to draw an antialiased fixation point
        % in the centre of the array
        Screen('BlendFunction', scr.main, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');

        % Draw the fixation point
        Screen('DrawDots', scr.main, [xCenter; yCenter], const.fixation_xdiam, color, [], 2);
        
        % added for debugging
        Screen('DrawDots', scr.main, [xLoc; yLoc], const.fixation_xdiam, color, [], 2);
        Screen('DrawDots', scr.main, [-xLoc; -yLoc], const.fixation_xdiam, color, [], 2);        

        % Flip our drawing to the screen
        vbl = Screen('Flip', scr.main, vbl + (waitframes - 0.5) * ifi);

        % Increment the phase of our Gabors
        %phaseLine = phaseLine + degPerFrameGabors;
        phaseLine = phaseLine + (degPerFrameGabors)*motionsign; % determined dir of motion
        propertiesMat(:, 1) = phaseLine';

end

end
