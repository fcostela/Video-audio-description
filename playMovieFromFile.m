function playMovieFromFile(win, filename)
% Basic movie playing code, not particularly in use at the moment.
%
% INPUT
%  win          Open window to draw to.
%  filename     Movie to play.
%
% Usage: playMovieFromFile(win, filename)


vbl = Screen('Flip', win);
[movie movieduration fps imgw imgh] = Screen('OpenMovie', win, filename); % Open movie file, get a handle to the movie
Screen('PlayMovie', movie, 1, 0, 1); % start playback
f = 0;
t = GetSecs;
while(1)    
    [tex pts] = Screen('GetMovieImage', win, movie);
    if tex<=0
        break;
    end;
    srcRect = Screen(tex,'Rect');
    destRect = Screen(win,'Rect');
    aspectRatio = (RectWidth(srcRect)*1.185)/RectHeight(srcRect); % The 1.185 factor is for anamorphic stretching, which we are assuming all of them have.
    if aspectRatio < 16/9
        destRect(3) = destRect(4)*aspectRatio;
    elseif aspectRatio > 16/9
        destRect(4) = destRect(3)/aspectRatio;
    end
    destRect = CenterRect(destRect,Screen(win, 'Rect'));
    Screen('FillRect',win,[0 0 0]);
    Screen('DrawTexture', win, tex, srcRect,destRect); 
   % Screen('DrawText', win, sprintf('%s src: %d x %d dest ratio: %.2f', filename, srcRect(3), srcRect(4), RectWidth(destRect)/RectHeight(destRect)), 20, 1200, [255, 255, 255]);

    vbl=Screen('Flip', win);
    Screen('Close', tex);
    
    [keyIsDown,secs,keyCode]=KbCheck;
    if (keyIsDown==1 && (keyCode(KbName('Delete')) ))%|| keyCode(KbName('DeleteForward'))))
        break;
    end
    f = f+1;
end;

%disp(sprintf('Number of frames shown: %d Framerate: %.2f',f,f/(GetSecs-t)));
Screen('CloseMovie', movie); % close movie reader