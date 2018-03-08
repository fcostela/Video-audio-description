function eyetrackRecord = showStillWithEyetracking(win, el, imagefilename, duration)
% Used by movieVsStillSaccades to collect eyetracking data with a still
% image on the screen.
%
% INPUT
%  win           open window to draw to
%  el            Returned from eyetrack initialization
%  imagefilename Path to image file such as .png.
%  duration      How long to leave the image up (seconds)
%
% OUTPUT
%  eyetrackRecord Eyetracking data collected during the trial, in a struct.
%
% Usage: eyetrackRecord = showStillWithEyetracking(win, el, imagefilename, duration)

esc=KbName('ESCAPE');


if Eyelink('isconnected') ~= el.dummyconnected
    Eyelink('startrecording');
    WaitSecs(0.1);
    Eyelink('Message', 'SYNCTIME'); % Mark the start of the trial in the edf file.
    
    eye_used = Eyelink('EyeAvailable'); % get eye that's tracked
    if eye_used == el.BINOCULAR; % if both eyes are tracked
        eye_used = el.LEFT_EYE; % use left eye
    end
end

HideCursor;

imageArray = imread(imagefilename);
srcRect = [0 0 size(imageArray,2) size(imageArray,1)];
textureIndex=Screen('MakeTexture', win, imageArray);

destRect = Screen(win,'Rect');
aspectRatio = RectWidth(srcRect)/RectHeight(srcRect);
% This code makes sure the video fills as much of the screen as
% possible, and displays at its proper aspect ratio.
if aspectRatio < 16/9
    destRect(3) = destRect(4)*aspectRatio;
elseif aspectRatio > 16/9
    destRect(4) = destRect(3)/aspectRatio;
end
destRect = CenterRect(destRect,Screen(win, 'Rect'));
% Draw the frame on the screen
Screen('FillRect',win,[0 0 0]);
Screen('DrawTexture', win, textureIndex, srcRect,destRect);

vbl=Screen('Flip', win,[],[],1);

Screen('Close', textureIndex); 




eyetrackRecord.x = [];
eyetrackRecord.y = [];
eyetrackRecord.pa = [];
eyetrackRecord.t = [];
eyetrackRecord.missing = [];

% Loop through the frames of the movie
t0 = GetSecs;
while(GetSecs-t0 < duration)
    %%% DEAL WITH EYETRACKING %%%
%     error=Eyelink('CheckRecording');
%     if(error~=0)
%         error('CheckRecording failed.');
%     end
%     % Get the gaze location.
    % If in dummy mode, use the mouse position.
    if Eyelink('isconnected') == el.dummyconnected
        [x,y,button] = GetMouse(win);
        missing = 0;
        eyetrackRecord.x = [eyetrackRecord.x x];
        eyetrackRecord.y = [eyetrackRecord.y y];        
        eyetrackRecord.pa = [eyetrackRecord.pa 1];        
        eyetrackRecord.missing = [eyetrackRecord.missing missing];
    else
        if Eyelink( 'NewFloatSampleAvailable') > 0
            % get the sample in the form of an event structure
            evt = Eyelink( 'NewestFloatSample');
            if eye_used ~= -1 % do we know which eye to use yet?
                % if we do, get current gaze position from sample
                x = evt.gx(eye_used+1); % +1 as we're accessing MATLAB array
                y = evt.gy(eye_used+1);
                pa = evt.pa(eye_used+1);
                t = evt.time;
                % do we have valid data and is the pupil visible?
                if x~=el.MISSING_DATA && y~=el.MISSING_DATA && evt.pa(eye_used+1)>0
                    missing = 0;
                else
                    missing = 1;
                end
            end
            eyetrackRecord.x = [eyetrackRecord.x x];
            eyetrackRecord.y = [eyetrackRecord.y y];
            eyetrackRecord.t = [eyetrackRecord.t t];
            eyetrackRecord.pa = [eyetrackRecord.pa pa];
            eyetrackRecord.missing = [eyetrackRecord.missing missing];
        end
    end

    % Stop if the enter key is pressed
    [keyIsDown,secs,keyCode]=KbCheck;
    if (keyIsDown==1 && keyCode(KbName('Enter')))
        break;
    end
    if keyIsDown && (keyCode(KbName('Delete')) || keyCode(KbName('DeleteForward')))
        error('Pressed delete to exit'); 
    end;
end;
Eyelink('StopRecording');


ShowCursor;

