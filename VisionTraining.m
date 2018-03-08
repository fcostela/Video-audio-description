function VisionTraining(participantID)%, bigYesNo, zoomYesNo)
% Run an inhouse information acquisition round, with audio recording of responses
% and eyetracking during video watching. Also poses the question of have
% you seen the movie before, and, if not, how much do you want to see it?
% Output is a set of .wav files, an .edf file (detailed eyetracking data)
% and an eyetrackPlus data file - that is, the eyetracking data in a
% struct, the answers to the questions about have you seen the movie, and a
% bit of info about the movie.
%
% INPUT
%  participantID: a string containing the id of the participant
%  videoOrder: array of numbers representing the video clips, from 1-200

% Example: BigTV('Daniel', );
%
% Usage: VisionNormal(participantID)

if ~exist('participantID')  participantID = 'test'; end;

% if ~exist('videoOrder')
%     videoOrder =   Shuffle(1:200);
%     videoOrder = videoOrder(1:20);
% end;
if ~exist('demoMode')  demoMode = false; end;


% if (length(videoOrder) ~= 40) && (length(videoOrder) ~= 46)
%     a = input('You have passed in a list of neither 40 or 46 video ids. Are you sure you want to run with this set? (y/n) ','s');
%     if isempty(a) || ~strcmp(a, 'y') error('Chose to cancel because less than 40 videos in the list'); end;
% end

exptName = 'VisionTraining'; % Used to name the output files, so change on an experiment basis if you like.
videoRoot = 'C:\Experimento\videosTraining\';
audioOutputFolder = 'C:\Experimento\audioData\training\';

 % if bigYesNo==1
   %   config = input( 'Is the display occupying the whole screen (BigTV condition)?');
      
  
try
    % Get the names of the videos we will be showing
    videoNames = importdata('test_video_names.txt');
    
    Screen('Preference', 'SkipSyncTests', 0);
    Screen('Preference', 'Verbosity', 2);
    KbName('UnifyKeyNames');
    
    % Disable key output to Matlab window:
    %     ListenChar(2);
    
    baseFileName = nameOutputFile(exptName, participantID);
    
    % Open a graphics window on the main screen
    whichScreen=max(Screen('Screens'));
    %win = Screen('OpenWindow', whichScreen, 0);
    win = Screen('OpenWindow',0);
     
    videoNames = {'BOOKC_27a','BOOKC_11a',};
 
    
    % Main trial loop
    for i = 1:2
              
        yellowCircleText = sprintf(['Clip ' num2str(i) ' - Pulse espacio para comenzar el video']);
    
        textScreen(win, yellowCircleText,60,true);        
       
        videoNumber = i;
       
        movieFileName = [videoRoot videoNames{videoNumber} '.mov'];
       
        audioFileName = [audioOutputFolder baseFileName ' ' sprintf('%03d',i) 'q1.wav'];

        playMovieFromFile(win,movieFileName);
        
        audioResponseScreen(win, 'Describe el videoclip para alguien que no la haya visto', audioFileName);
        
        if demoMode
            audioFileName = 'dummy.wav';
        else
            audioFileName = [audioOutputFolder baseFileName ' ' sprintf('%03d',i) 'q2.wav'];
        end
        
        audioResponseScreen(win, 'Añade algún detalle adicional que recuerdes (camisa negra, flores rojas, etc.)', audioFileName);
             
        trialId = i;
       

         % Display the number & name of the movie clip just finished, for
         % help with recovering from crashes.
         disp(sprintf('%s,%s', participantID,videoNames{videoNumber}));
         
         if i==2
              textScreen(win, 'Comprueba que los archivos de audio (en carpeta C:\experimento\audioData\training) se han grabado bien' ,60,true);   
         end
                          
   end
   
    disp('Final!');
    % Finish up with the eyetracking and pull over the .edf file from the
    % host PC.
%     if demoMode
%         Eyelink('CloseFile');
%     else
      
    cleanup
    
catch myerr
    %this "catch" section executes in case of an error in the "try" section
    %above.  Importantly, it closes the onscreen window if it's open.
    commandwindow;
    disp(sprintf('ERROR: %s', myerr.message));
    cleanup;
    for i = 1:length(myerr.stack)
        disp(sprintf('File %s Line %d', myerr.stack(i).file, myerr.stack(i).line));
    end
end %try..catch.


%----------------------------------------------------------

function name = nameOutputFile(exptName, participantID)
% Helper function to assemble the name of the output file.
name = sprintf('%s %s %s %s %s',exptName, participantID, datestr(now,'yyyy-mm-dd'));


%----------------------------------------------------------

function cleanup
% Cleanup routine for at the end or in case of an error

% Close window:
sca;

% Restore keyboard output to Matlab:
ListenChar(0);

% finish up: stop recording eye-movements,
% close graphics window, close data file and shut down tracker
ShowCursor;



