function [const]=constConfig(scr,const)
% ----------------------------------------------------------------------
% [const]=constConfig(const)
% ----------------------------------------------------------------------
% Goal of the function :
% Compute all constant data of this experiment.
% ----------------------------------------------------------------------
% Input(s) :
% scr : window pointer
% const : struct containg previous constant configurations.
% ----------------------------------------------------------------------
% Output(s):
% const : struct containing all constant data.
% ----------------------------------------------------------------------

% Instructions
const.text_size = 20       ;
const.text_font = 'Helvetica';

% Color Configuration :
const.red =     [200,   0,   0];
const.green =   [  0, 200,   0];
const.blue =    [  0,   0, 200];
const.orange =  [255, 150,   0];
const.gray =    [127, 127, 127];
const.colBG =   [127, 127, 127];
const.white =   [255, 255, 255]; 
const.black =   [  0,   0,   0];

% Time
const.my_clock_ini = clock;

% Fixation settings
const.fixation_val = 0.5;  % diameter of the fixation (deg)
[const.fixation_xdiam,const.fixation_ydiam] = vaDeg2pix(const.fixation_val,scr); % diameter of the answer fixation (pix)

% grating spatial frequency
const.numCycles_deg = 2.5; % cycles per degree 
[numCycles_cm] =  vaDeg2cm(const.numCycles_deg,scr); % cycles per pixel (double check calc)
const.numCycles_cm = numCycles_cm;

const.gaborDim_deg = 4;
[gaborDim_xpix, gaborDim_ypix] =  vaDeg2pix(const.gaborDim_deg,scr);
const.gaborDim_xpix = round(gaborDim_xpix);
const.gaborDim_ypix = round(gaborDim_ypix);

% TO DO: set up stimulus angles/speed beforehand
% angle_options = [0, 45, 90, 135]; 
% randomIndex = randi(length(angle_options), 1);
% gaborAngles = angle_options(randomIndex);

%const.freq = const.numCycles_xpix / const.gaborDim_xpix;

% Center position of screen
%[scr.x_mid, scr.y_mid] = RectCenter(scr.rect);

% Experiental timing settings
const.T1  = 1.0;                % fixation time 1       = 1  sec
const.T2  = 0.050;              % isi (fix this to match Heeley paper)
const.T3  = 1.0;                % stimulus presentation = 1  sec

const.T4  = const.T1;
const.T5  = const.T2; 
const.T6  = const.T3;  

const.numFrm_T1  =  round(const.T1/scr.frame_duration);
const.numFrm_T2  =  round(const.T2/scr.frame_duration);
const.numFrm_T3  =  round(const.T3/scr.frame_duration);
const.numFrm_T4  =  round(const.T4/scr.frame_duration);
const.numFrm_T5  =  round(const.T5/scr.frame_duration);
const.numFrm_T6  =  round(const.T6/scr.frame_duration);
const.numFrm_Tot =  const.numFrm_T1 + const.numFrm_T2 + const.numFrm_T3 + const.numFrm_T4 + const.numFrm_T5 + const.numFrm_T6;

const.numFrm_T1_start  = 1;                              
const.numFrm_T1_end  =  const.numFrm_T1_start  + const.numFrm_T1-1;
const.numFrm_T2_start  = const.numFrm_T1_end+1;          
const.numFrm_T2_end  =  const.numFrm_T2_start  + const.numFrm_T2-1;
const.numFrm_T3_start  = const.numFrm_T2_end+1;          
const.numFrm_T3_end  =  const.numFrm_T3_start  + const.numFrm_T3-1;
const.numFrm_T4_start  = const.numFrm_T3_end+1;          
const.numFrm_T4_end  =  const.numFrm_T4_start  + const.numFrm_T4-1;
const.numFrm_T5_start  = const.numFrm_T4_end+1;          
const.numFrm_T5_end  =  const.numFrm_T5_start  + const.numFrm_T5-1;
const.numFrm_T6_start  = const.numFrm_T5_end+1;          
const.numFrm_T6_end  =  const.numFrm_T6_start  + const.numFrm_T6-1;

%% Saving procedure :
const_file = fopen(const.const_fileDat,'w');
fprintf(const_file,'Subject initial :\t%s\n',const.sjct);
if const.fromBlock == 1
    fprintf(const_file,'Subject age :\t%s\n',const.sjct_age);
    fprintf(const_file,'Subject gender :\t%s\n',const.sjct_gender);
end
fprintf(const_file,'Date : \t%i-%i-%i\n',const.my_clock_ini(3),const.my_clock_ini(2),const.my_clock_ini(1));
fprintf(const_file,'Starting time : \t%ih%i\n',const.my_clock_ini(4),const.my_clock_ini(5));
fclose('all');

% .mat file
save(const.const_fileMat,'const');

end