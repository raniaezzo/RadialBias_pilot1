function [value] = flipangle(angles)
% ----------------------------------------------------------------------
% [value] = flipangle(angles)
% ----------------------------------------------------------------------
% Goal of the function :
% Convert angle needed for Psychtoolbox to interpretable angle ( value )
% ----------------------------------------------------------------------
% Input(s) :
% angles    = angle (deg) used in my_stim input        ex : 0 (left motion)
%                                                      ex : = 90 (upward)
%                                                      ex : = 180 (right)
%                                                      ex : = 270 (down)
%             Note that although used in Psychtoolbox as orientation,
%             this function converts it to motion direction.
%             In Psychtoolbox 0 degree angle is vertical line,
%             so normally we could use this value as the saved variable for
%             motion direction (which is orthogonal to orienation +-90).
%             But due to the properties of the motion direction of the grating, 
%             only vertical axis could be saved as motion direction accurately.
%             All other values were flipped along vertical axis (e.g. only 90 and 
%             0 degrees orientation in Psychtoolbox corresponds to actual 
%             motion direction. Other values to the right and left of this needed 
%             to be flipped which is what this function does.
% ----------------------------------------------------------------------
% Output(s):
% [value]  = in degrees                             ex : = 180
%                                                   ex : = 90
%                                                   ex : = 0
%                                                   ex : = 270
% ----------------------------------------------------------------------
% Function created by Rania EZZO (rania.ezzo@nyu.edu)
% Last update : 02 / 11 / 2021
% Project : RadialBias_pilot1
% Version : -
% ----------------------------------------------------------------------
    % example of standard angles (other values between 0 and 30 can be
    % used). Negative values x are treated as 360-x.
    % 0 5 40 45 50 85 90 95 130 135 140 175 180 185 220 225 230 265 270 275 310 315 320 -5

    value = [];
    for i=1:length(angles)
        number = angles(i);
        if number<0
            number = 360+number;
        end
        if (180 > number) && (number > 90)
            dist = abs(number - 90);
            number = 90-dist;
        elseif (270 > number) && (number > 180)
            dist = abs(number - 180);
            number = 360-dist;
        elseif (90 > number) && (number > 0)
            dist = abs(number - 90);
            number = 90+dist;
        elseif (360 > number) && (number > 270)
            dist = abs(number - 270);
            number = 270-dist;
        elseif number == 180
            number = 0;
        elseif number == 0
            number = 180;
        end
        value = [value number];
    end

end