function [cm] = vaDeg2cm (vaDeg,scr)
% ----------------------------------------------------------------------
% [cm] = vaDeg2cm (vaDeg,dist)
% ----------------------------------------------------------------------
% Goal of the function :
% Convert visual angle (degree) in cm
% ----------------------------------------------------------------------
% Input(s) :
% vaDeg = size in visual angle (degree)             ex : deg = 2.0
% scr  = screen configuration : scr.dist(cm)        ex : scr.dist = 60
% ----------------------------------------------------------------------
% Output(s):
% cm    = size in cm                                ex : cm = 12
% ----------------------------------------------------------------------
% Function created by Martin SZINTE (martin.szinte@gmail.com)
% Last update : 08 / 01 / 2014
% Project : Yeshurun98
% Version : -
% ----------------------------------------------------------------------

%cm = (2*scr.dist*tan(0.5*pi/180))*vaDeg; 
% fixed based on https://courses.washington.edu/matlab1/matlab/angle2pix.m
cm = 2*scr.dist*tan(pi*vaDeg/(2*180));
end