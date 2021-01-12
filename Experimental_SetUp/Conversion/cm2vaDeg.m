function [vaDeg] =cm2vaDeg (cm,scr)
% ----------------------------------------------------------------------
% [vaDeg] = cm2vaDeg(cm,scr)
% ----------------------------------------------------------------------
% Goal of the function :
% Convert cm in visual angle (degree)
% ----------------------------------------------------------------------
% Input(s) :
% cm = size in cm                                   ex : cm = 2.0 target
% (40 cm wide)
% scr  = screen configuration : scr.dist(cm)        ex : scr.dist = 60 (90)
% ----------------------------------------------------------------------
% Output(s):
% vaDeg = size in visual angle (degree)             ex : vaDeg = 2.5
% ----------------------------------------------------------------------
% Function created by Martin SZINTE (martin.szinte@gmail.com)
% Last update : 08 / 01 / 2014
% Project : Yeshurun98
% Version : -
% ----------------------------------------------------------------------

%vaDeg = cm./(2*scr.dist*tan(0.5*pi/180)); % fix this?

% checked with https://courses.washington.edu/matlab1/matlab/pix2angle.m
vaDeg = 2*180*atan(cm./(2*scr.dist))/pi;
end
