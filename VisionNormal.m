function VisionNormal(participantID)%, bigYesNo, zoomYesNo)
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
subjectfileName = ['C:\Experimento\programa\sujetos\' participantID '.mat'];
file = dir(subjectfileName);

normalClips = [83,93,103,3,13,43,113,53,123,133,63,143,153,163,173,23,33,193,183,73,58,17, 105, 10 , 45, 51, 54, 68, 75,81,84,90,104,118,8,137,110,159,171,203 ];

% not used 58, 113, 148, %136


if isempty(file)    
   
    s = RandStream('mt19937ar','Seed',sum(100*clock));
    RandStream.setDefaultStream(s);
    order = randperm(40);     
    blurred = randperm(40);
    blurred_low = blurred(1:8)
    blurred_high = blurred(9:16)
    
    index = 0;
    trialId = 0;
    clipsAssigned  = normalClips(order)   
    save(subjectfileName,'clipsAssigned', 'trialId' , 'order', 'blurred_low', 'blurred_high' );
    disp(['Archivo creado para sujeto ' participantID]);
    
else
    myfilename = file.name;
    load(subjectfileName);
    %index = 0;
    index = trialId;
    disp(['Archivo ya existe para el sujeto ' participantID ' que ha visto ' num2str(index) ' clips']);
end



% if (length(videoOrder) ~= 40) && (length(videoOrder) ~= 46)
%     a = input('You have passed in a list of neither 40 or 46 video ids. Are you sure you want to run with this set? (y/n) ','s');
%     if isempty(a) || ~strcmp(a, 'y') error('Chose to cancel because less than 40 videos in the list'); end;
% end

exptName = 'VisionNormal'; % Used to name the output files, so change on an experiment basis if you like.
videoRoot = 'C:\Experimento\videosNormal\';
audioOutputFolder = 'C:\Experimento\audioData\normal\';

 % if bigYesNo==1
   %   config = input( 'Is the display occupying the whole screen (BigTV condition)?');
aviClips = [ 45, 51, 54, 68, 75,81,84,90,104,118,136,137,148,159,171,203];       
  
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
    
    inormal =0;
    iLow =0;
    iHigh = 0;
    % Main trial loop
    for i = index+1:length(clipsAssigned)
              
        yellowCircleText = sprintf(['Clip ' num2str(i) ' - Pulse espacio para comenzar el video']);
    
        textScreen(win, yellowCircleText,60,true);        
        
        videoNumber = clipsAssigned(i)
        extension = '.mov';
      
        if find(i==blurred_low)
            disp('Low');
            iLow=iLow+1;
            if find(videoNumber==aviClips)
                extension = '.avi';
            end
            movieFileName = [videoRoot videoNames{videoNumber} '_b10' extension]
        else if find(i==blurred_high)
                disp('High');
                iHigh =iHigh+1;
                if find(videoNumber==aviClips)
                    extension = '.avi';
                end
                movieFileName = [videoRoot videoNames{videoNumber} '_b50' extension]
            else
                 disp('Normal');
                 inormal =inormal +1;
                movieFileName = [videoRoot videoNames{videoNumber} '_b0' extension]
            end
        end
    
       
        audioFileName = [audioOutputFolder baseFileName ' ' sprintf('%03d',i) 'q1.wav'];

        playMovieFromFile(win,movieFileName);
        
        audioResponseScreen(win, 'Describe el videoclip para alguien que no la haya visto', audioFileName);
        
        audioFileName = [audioOutputFolder baseFileName ' ' sprintf('%03d',i) 'q2.wav'];
        
        audioResponseScreen(win, 'Añade algún detalle adicional que recuerdes (camisa negra, flores rojas, etc.)', audioFileName);
             
        trialId = i;
        save(subjectfileName, 'clipsAssigned', 'trialId', 'order', 'blurred_low', 'blurred_high');

         % Display the number & name of the movie clip just finished, for
         % help with recovering from crashes.
         disp(sprintf('%s,%s', participantID,videoNames{videoNumber}));
                 
         stop = buttonScreen(win, ['Clip ' num2str(i) ' - Parar la sesión?'], {'Sí','No'}) == 1;
         if stop
             break;
         end
                 
   end
     disp(inormal);
    disp(iLow);
    disp(iHigh);
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



