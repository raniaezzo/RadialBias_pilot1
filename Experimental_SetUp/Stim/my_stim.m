function my_stim(scr,const,color,tframes, endframe, xDist, yDist, orientation, trialnumber)
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
moviepath = sprintf('%s/Movies/%i',pwd, trialnumber);
gray = const.gray(1);
white = const.white(1);

% Get the centre coordinate of the window
[x, y] = RectCenter(scr.rect);
xCenter = x;
yCenter = y;

angle = orientation; % [0 is vertical]
speed = 8; % deg/s
sf = 1; % cyc/deg
f = sf*const.gaborSF_xpix; % spatial frequency (cycles per pixel)
cyclespersecond = sf*speed; % temporal frequency

drawmask = 1; 
gratingsize = const.gaborDim_xpix; %400

movieDurationSecs=const.T3;   % Abort demo after N seconds.
inc=white-gray;

% Define Half-Size of the grating image.
texsize=gratingsize / 2;
filterparam = mean(texsize)/2; % I created this temporarily, figure out how to measure this
% in terms of sigma

%[w screenRect]=Screen('OpenWindow',screenNumber, gray); %already defined?

% was here

% First we compute pixels per cycle, rounded up to full pixels, as we
% need this to create a grating of proper size below:
p=ceil(1/f);
    
% Also need frequency in radians:
fr=f*2*pi;
    
% This is the visible size of the grating. It is twice the half-width
% of the texture plus one pixel to make sure it has an odd number of
% pixels and is therefore symmetric around the center of the texture:
visiblesize=2*texsize+1;
   
% Need 2 * texsize + p columns, i.e. the visible size
% of the grating extended by the length of 1 period (repetition) of the
% sine-wave in pixels 'p':
x = meshgrid(-texsize:texsize + p, 1);

% Compute actual cosine grating:
grating=gray + inc*cos(fr*x);
contrast = 0.7;

% Store 1-D single row grating in texture:
gratingtex=Screen('MakeTexture', scr.main, grating);

mask=ones(2*texsize+1, 2*texsize+1, 2) * gray;
[x,y]=meshgrid(-1*texsize:1*texsize,-1*texsize:1*texsize);
mask(:, :, 2)= round(white * (1 - exp(-((x/filterparam).^2)-((y/filterparam).^2)))); 
masktex=Screen('MakeTexture', scr.main, mask);

% Query maximum useable priorityLevel on this system:
priorityLevel=MaxPriority(scr.main);

%dstRect=[0 0 visiblesize visiblesize];
%dstRect=CenterRect(dstRect, scr.rect); % change the location
xDist = xCenter+xDist-(visiblesize/2); % center + (+- distance added in pixels)
yDist = yCenter+yDist-(visiblesize/2);  % check with -(vis part.. 
dstRect=[xDist yDist visiblesize+xDist visiblesize+yDist];

% Query duration of one monitor refresh interval:
ifi=Screen('GetFlipInterval', scr.main);

%waitframes = 1 means: Redraw every monitor refresh
waitframes = 1;

% Translate frames into seconds for screen update interval:
waitduration = waitframes * ifi;
    
% Recompute p, this time without the ceil() operation from above.
% Otherwise we will get wrong drift speed due to rounding errors!
p=1/f;  % pixels/cycle  

% Translate requested speed of the grating (in cycles per second) into
% a shift value in "pixels per frame", for given waitduration: This is
% the amount of pixels to shift our srcRect "aperture" in horizontal
% directionat each redraw:
shiftperframe= cyclespersecond * p * waitduration;

% Perform initial Flip to sync us to the VBL and for getting an initial
% VBL-Timestamp as timing baseline for our redraw loop:
vbl=Screen('Flip', scr.main);

% We run at most 'movieDurationSecs' seconds if user doesn't abort via keypress.
vblendtime = vbl + movieDurationSecs;
i=0;

movieframe_n = 1;
    
% Animationloop:
while vbl < vblendtime
    % Shift the grating by "shiftperframe" pixels per frame:
    % the mod'ulo operation makes sure that our "aperture" will snap
    % back to the beginning of the grating, once the border is reached.
    % Fractional values of 'xoffset' are fine here. The GPU will
    % perform proper interpolation of color values in the grating
    % texture image to draw a grating that corresponds as closely as
    % technical possible to that fractional 'xoffset'. GPU's use
    % bilinear interpolation whose accuracy depends on the GPU at hand.
    % Consumer ATI hardware usually resolves 1/64 of a pixel, whereas
    % consumer NVidia hardware usually resolves 1/256 of a pixel. You
    % can run the script "DriftTexturePrecisionTest" to test your
    % hardware...
    xoffset = mod(i*shiftperframe,p);
    i=i+1;
        
    % Define shifted srcRect that cuts out the properly shifted rectangular
    % area from the texture: We cut out the range 0 to visiblesize in
    % the vertical direction although the texture is only 1 pixel in
    % height! This works because the hardware will automatically
    % replicate pixels in one dimension if we exceed the real borders
    % of the stored texture. This allows us to save storage space here,
    % as our 2-D grating is essentially only defined in 1-D:
    srcRect=[xoffset 0 xoffset + visiblesize visiblesize];
       
    % Draw the fixation point
    Screen('DrawDots', scr.main, [xCenter; yCenter], const.fixation_xdiam, color, [], 2);
    
    % Draw grating texture, rotated by "angle": % this was prior settings (1 line
    % below)
    %alpha = 0.5 or 1 (0-1 ocontrast)
    Screen('DrawTexture', scr.main, gratingtex, srcRect, dstRect, angle, [],  0.5);
    
    %if drawmask==1
    % Draw gaussian mask over grating: 
    Screen('DrawTexture', scr.main, masktex, [0 0 visiblesize visiblesize], dstRect, angle);
    %Screen('DrawTexture', scr.main, masktex, srcRect, dstRect, angle);
    %end

    % Flip 'waitframes' monitor refresh intervals after last redraw.
    % Providing this 'when' timestamp allows for optimal timing
    % precision in stimulus onset, a stable animation framerate and at
    % the same time allows the built-in "skipped frames" detector to
    % work optimally and report skipped frames due to hardware
    % overload:
    vbl = Screen('Flip', scr.main, vbl + (waitframes - 0.5) * ifi);
    
%     % added for debugging
%     Screen('DrawDots', scr.main, [xLoc; yLoc], const.fixation_xdiam, color, [], 2);
%     Screen('DrawDots', scr.main, [-xLoc; -yLoc], const.fixation_xdiam, color, [], 2); 
    
    % if PUT BACK, changes needed to runTrials.m
     %if movieframe_n == 1  % save first frame of each movie (not the rest for speed)
     %    rect = [];
     %    % added to save movie clip
     %    M = Screen('GetImage', scr.main,rect,[],0,1);
     %    imwrite(M,[moviepath, '/Image_',num2str(movieframe_n),'.png']);
     %    movieframe_n = movieframe_n + 1;
     %end

    % Abort demo if any key is pressed:
    if KbCheck
        break;
    end
end

end
