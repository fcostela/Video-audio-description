function drawTextCenteredOnPoint(win, message, point, fontColor)
% Utility function to draw text on the screen centered on a specific screen
% coordinate.
%
% INPUT
%   win        Open window to draw to
%   message    Text to draw
%   point      Array with [x, y] to center on
%   fontColor  Colour of the text.
%
% Usage: drawTextCenteredOnPoint(win, message, point, fontColor)

if ~exist('fontColor')
    fontColor = [0 0 0];
end

bounds = Screen('TextBounds',win,message);
c = CenterRectOnPoint(bounds, point(1),point(2));
sx = c(1);
sy = c(2);
DrawFormattedText(win, message, sx, sy, fontColor);
