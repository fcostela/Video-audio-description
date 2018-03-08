function eyetrackRecord = showTargetsWithEyetracking(win, el, duration, distance)
% Used by basicSaccadeRecording to collect eyetracking data looking between
% two dots.
%
% INPUT
%  win           open window to draw to
%  el            Returned from eyetrack initialization
%  duration      How long to leave the image up (seconds)
%  distance      How far apart the dots are (pixels)
%
% OUTPUT
%  eyetrackRecord Eyetracking data collected during the trial, in a struct.
%
% Usage: eyetrackRecord = showTargetsWithEyetracking(win, el, duration, distance)

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


Screen('FillRect',win,[0 0 0]);

screenRect = Screen(win,'Rect');
[cx cy] = RectCenter(screenRect);
rectSize = 20;
circleRect = CenterRectOnPoint([0 0 rectSize rectSize], round(cx-distance/2), cy);
Screen('FillOval', win, [255 255 0], circleRect);
circleRect = CenterRectOnPoint([0 0 rectSize rectSize], round(cx+distance/2), cy);
Screen('FillOval', win, [255 255 0], circleRect);

vbl=Screen('Flip', win,[],[],1);



eyetrackRecord.x = [];
eyetrackRecord.y = [];
eyetrackRecord.pa = [];
eyetrackRecord.t = [];
eyetrackRecord.missing = [];

% Loop through the frames of the movie
t0 = GetSecs;
i = 1;
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
%         eyetrackRecord.y = [eyetrackRecord.y y];        
%         eyetrackRecord.pa = [eyetrackRecord.pa 1];      
%         t = GetSecs;
%         eyetrackRecord.t = [eyetrackRecord.t 4];        
%         eyetrackRecord.missing = [eyetrackRecord.missing missing];
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

    if mod(i,1000) == 1
        %     Stop if the enter key is pressed
        [keyIsDown,secs,keyCode]=KbCheck;
        if (keyIsDown==1 && keyCode(KbName('Enter')))
            break;
        end
        if keyIsDown && (keyCode(KbName('Delete')) || keyCode(KbName('DeleteForward')))
            error('Pressed delete to exit');
        end;
    end
 i = i +1;
end;
Eyelink('StopRecording');


ShowCursor;

