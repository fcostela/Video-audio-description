function movieVsStillSaccades(participantID)
% Run special experiment comparing eye movements on movie images and still
% images.
%
% INPUT
%  participantID    String. The id of the participant.
%
% Usage: movieVsStillSaccades(participantID)

if ~exist('participantID')  participantID = 'test'; end;


exptName = 'movieVsStill';

eyetrackOutputFolder = 'eyetrackPlusData/';
edfFolder = 'edfData/';
dummymode = false;
stimuliOrder = 2;
stimuliRoot = '/Users/woodslab/Desktop/Defocus Video Clips/';

try
    % Get the names of the videos we will be showing
    %     videoNames = ls([videoRoot '*.mov']);
    %     videoNames = strread(videoNames,'%s','delimiter','\t');
    %     videoNames = importdata('test_video_names.txt');
    stimuliNames = importdata('stimuli_names.txt');

    Screen('Preference', 'SkipSyncTests', 0);
    Screen('Preference', 'Verbosity', 2);
    KbName('UnifyKeyNames');
    
    % Disable key output to Matlab window:
    %     ListenChar(2);
    
    baseFileName = nameOutputFile(exptName, participantID);
    
    eyetrackFileName = [eyetrackOutputFolder baseFileName ' ' sprintf('%03d',1) '.mat'];
    fid = fopen(eyetrackFileName, 'r');
    if fid > 0 
        a = input(sprintf('File ''%s'' exists. Overwrite? (y/n) ',eyetrackFileName),'s');
        fclose(fid);
        if isempty(a) || ~strcmp(a, 'y') error(sprintf('Chose not to overwrite file ''%s''.',eyetrackFileName)); end;
    end
    
    
    % Open a graphics window on the main screen
    whichScreen=max(Screen('Screens'));
    win = Screen('OpenWindow', whichScreen, 0);
    
    % Initialize eyelink
    el=EyelinkInitDefaults(win);
    el.targetbeep = 0;
    if ~EyelinkInit(dummymode, 1)
        error('Eyelink Init aborted.\n');
    end
    
    
    % make sure that we get gaze data from the Eyelink
    Eyelink('Command', 'link_sample_data = LEFT,RIGHT,GAZE,AREA');
    
    
    
    if Eyelink('isconnected') ~= el.dummyconnected
        % Calibrate the eye tracker
        EyelinkDoTrackerSetup(el);
    end
    
       
    % Create the eyelink data file on the eyetracker machine.
    edfFile = [edfFolder baseFileName '.edf'];
    tempEdfFile = sprintf('freen%02d.edf',floor(rand*100));
    Eyelink('Openfile', tempEdfFile);
    
    for i = 1:length(stimuliOrder)
        stimulusFileName = [stimuliRoot stimuliNames{stimuliOrder(i)}];

        eyetrackFileName = [eyetrackOutputFolder baseFileName ' ' sprintf('%03d',i) '.mat'];
        yellowCircleText = sprintf('Look at the middle of the yellow circle on the next screen and press the space bar.');
        textScreen(win, yellowCircleText,70,true);
        if Eyelink('isconnected') ~= el.dummyconnected
            EyelinkDoDriftCorrection(el);
        end
        
        if strcmp(stimulusFileName(end-2:end),'mov')   % By the extension, figure out if it's a movie
            eyetrackRecord = playMovieWithEyetracking(win, el, stimulusFileName);
        else                                           % or it's a still image
            eyetrackRecord = showStillWithEyetracking(win, el, stimulusFileName, 30);
        end        
        
        save(eyetrackFileName, 'eyetrackRecord','stimulusFileName');
        
    end
    textScreen(win, 'Experiment done. Receiving eyetracker data file...');
    Eyelink('CloseFile');
    
    try
        fprintf('Receiving data file ''%s''\n', tempEdfFile );
        status=Eyelink('ReceiveFile',[], edfFile);
        %         if status > 0
        fprintf('ReceiveFile status %d\n', status);
        %         end
        if 2==exist(edfFile, 'file')
            fprintf('Data file ''%s'' can be found in ''%s''\n', edfFile, pwd );
        end
    catch rdf
        fprintf('Problem receiving data file ''%s''\n', edfFile );
        rdf;
    end
    
    cleanup
    
catch myerr
    %this "catch" section executes in case of an error in the "try" section
    %above.  Importantly, it closes the onscreen window if it's open.
    commandwindow;
    disp(sprintf('ERROR: %s', myerr.message));
    cleanup;
    for k = 1:length(myerr.stack)
        disp(sprintf('File %s Line %d', myerr.stack(k).file, myerr.stack(k).line));
    end
end %try..catch.



function name = nameOutputFile(exptName, participantID)
name = sprintf('%s %s %s',exptName, participantID, datestr(now,'yyyy-mm-dd'));




% Cleanup routine for at the end or in case of an error
function cleanup

% Close window:
sca;

% Restore keyboard output to Matlab:
ListenChar(0);

% finish up: stop recording eye-movements,
% close graphics window, close data file and shut down tracker
if Eyelink('isconnected')
    Eyelink('Stoprecording');
    Eyelink('CloseFile');
    Eyelink('Shutdown');
end
ShowCursor;
