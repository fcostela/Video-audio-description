function drawRecordAnimation(win, t, drawColor)
% Draw the red recording icon at a particular point in time.
%
% INPUT
%  win  Open window to draw to.
%  t    Time for animation frame. Doesn't matter where it starts, as long
%       as it advances by seconds.
%  drawColor    What colour to draw the thing. Defaults to red.
%
% Usage: drawRecordAnimation(win, t, drawColor)

color.red = [210 0 0];
color.white = [255 255 255];

if ~exist('drawColor')
    drawColor = color.red;
end

period = 1;
scale = 2.5; % Scaling factor - increase to make the whole thing bigger
d = 60 * scale;
a = 40 * scale;
b = 10 * scale;
c = 20 * scale;
n = 4;
r = Screen('Rect',win);
[cx cy] = RectCenter(r);
cy = cy+230;
ox1 = cx-d/2;
ox2 = cx+d/2;
oval1 = round([ox1-a/2 cy-a/2 ox1+a/2 cy+a/2]);
oval2 = round([ox2-a/2 cy-a/2 ox2+a/2 cy+a/2]);

Screen('FillOval', win,drawColor, oval1);
Screen('FillOval', win,drawColor, oval2);
Screen('FillOval', win,color.white, InsetRect(oval1,b,b));
Screen('FillOval', win,color.white, InsetRect(oval2,b,b));


baroffsets = (0:n)*(d/n);
i = floor(mod(t, period) / (period/n)) + 1;
x = ox1 + baroffsets(i);
y = cy-a/2;
Screen('FillRect', win, drawColor, [x y x+c, y+b]);


