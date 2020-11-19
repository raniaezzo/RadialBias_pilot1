function my_fixationCross(scr,const,color)
% ----------------------------------------------------------------------
% my_fixationCross(scr,const,color)
% ----------------------------------------------------------------------
% Goal of the function :
% Draw a fixation cross in the center of the screen
% ----------------------------------------------------------------------
% Input(s) :
% scr = Window Pointer                              ex : w
% color = color of the circle in RBG or RGBA        ex : color = [0 0 0]
% const = structure containing constant configurations.
% ----------------------------------------------------------------------
% Output(s):
% ----------------------------------------------------------------------

% Get the centre coordinate of the window
[x, y] = RectCenter(scr.rect);

% Draw the fixation point
Screen('DrawDots', scr.main, [x y], const.fixation_xdiam, color, [], 2); % size is the diameter of each dot in pixels (default is 1)

end