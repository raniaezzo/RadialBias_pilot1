function [my_key]=keyConfig
% ----------------------------------------------------------------------
% [my_key]=keyConfig
% ----------------------------------------------------------------------
% Goal of the function :
% Unify key names and return a structure containing each key names.
% ----------------------------------------------------------------------
% Input(s) :
% none
% ----------------------------------------------------------------------
% Output(s):
% my_key : structure containing all keyboard names.
% ----------------------------------------------------------------------

KbName('UnifyKeyNames');
my_key.escape       = KbName('ESCAPE');
my_key.space        = KbName('Space');
my_key.rightShift   = KbName('RightArrow'); %('RightShift');
my_key.leftShift    = KbName('LeftArrow'); %('LeftShift');

end