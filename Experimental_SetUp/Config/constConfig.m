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
const.numCycles_deg = 1; %2.5; % cycles per degree 
[numCycles_cm] =  vaDeg2cm(const.numCycles_deg,scr); 
const.numCycles_cm = numCycles_cm;
[gaborSF_xpix, gaborSF_ypix] =  vaDeg2pix(const.numCycles_deg,scr); % cycles per pixel (double check calc)
const.gaborSF_xpix = round(gaborSF_xpix);
const.gaborSF_ypix = round(gaborSF_ypix);

const.gaborDim_deg = 2.5; %was 4
[gaborDim_cm] =  vaDeg2cm(const.gaborDim_deg,scr); 
const.gaborDim_cm = gaborDim_cm;
[gaborDim_xpix, gaborDim_ypix] =  vaDeg2pix(const.gaborDim_deg,scr);
const.gaborDim_xpix = round(gaborDim_xpix);
const.gaborDim_ypix = round(gaborDim_ypix);

const.gaborDist_deg = 7;
[gaborDist_xpix, gaborDist_ypix] =  vaDeg2pix(const.gaborDist_deg,scr);
const.gaborDist_ypix = round(gaborDist_ypix);
const.gaborDist_xpix = const.gaborDist_ypix; %round(gaborDist_xpix);

% TO DO: set up stimulus angles/speed beforehand
% angle_options = [0, 45, 90, 135]; 
% randomIndex = randi(length(angle_options), 1);
% gaborAngles = angle_options(randomIndex);

%const.freq = const.numCycles_xpix / const.gaborDim_xpix;

% Center position of screen
%[scr.x_mid, scr.y_mid] = RectCenter(scr.rect);

% sound settings
%InitializePsychSound(1);
%reqlatencyclass = 2; % Level 2 means: Take full control over the audio device, even if this causes other sound applications to fail or shutdown.
%InitializePsychSound(1);
%const.pahandle = PsychPortAudio('Open', [], [], reqlatencyclass, 44100, 1); % 1 = single-channel
%PsychPortAudio('Volume', const.pahandle, 0.5); % 1 denotes 100% volume.

% Experiental timing settings
const.T1  = 1.0; %0.5;                % fixation time 1       = 0.5  sec
const.T2  = 0.3; %0.05;              % isi (fix this to match Heeley paper)
const.T3  = 0.5;                % stimulus presentation = 0.5  sec

const.numFrm_T1  =  round(const.T1/scr.frame_duration);
const.numFrm_T2  =  round(const.T2/scr.frame_duration);
const.numFrm_T3  =  round(const.T3/scr.frame_duration);
const.numFrm_Tot =  const.numFrm_T1 + const.numFrm_T2 + const.numFrm_T3;

const.numFrm_T1_start  = 1;                              
const.numFrm_T1_end  =  const.numFrm_T1_start  + const.numFrm_T1-1;
const.numFrm_T2_start  = const.numFrm_T1_end+1;          
const.numFrm_T2_end  =  const.numFrm_T2_start  + const.numFrm_T2-1;
const.numFrm_T3_start  = const.numFrm_T2_end+1;          
const.numFrm_T3_end  =  const.numFrm_T3_start  + const.numFrm_T3-1;

% For staircase procedure (99-practice 0-thresholding 1-experimental)

if const.use_staircase
    stairParams.whichStair = 1; % QUEST = 2, bestPEST = 1;
    % (make sure this makes sense) -- this is one array (e.g. T1)
    stairParams.alphaRange = [0.25:0.25:3, 3.5:0.5:7];  % values same as aysun's exp 
    stairParams.fitBeta = 2; % params for the psychoetric fn
    stairParams.fitLambda = 0.01; 
    stairParams.fitGamma = 0.5; 
    stairParams.perfLevel =0.75; % performance
    stairParams.useMyPrior = [];
    const.stairs = usePalamedesStaircase(stairParams); % is this needed here (move to outside of the loop)?
    const.stairs.xCurrent = const.currStair; % starting point: defined in expLauncher
    fprintf('\nStaircase is ON\n');
else
    const.stairs.xCurrent = const.currStair; % same as above.. defined in expLauncher
end

% not sure if this is needed? I added this
const.stairvec = [];

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