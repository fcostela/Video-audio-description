function clicked = mouseInButton(center, diameter,x,y)
% Determine whether the mouse is inside a particular button.
% 
% INPUT
%  center   [x y] for the center of the button
%  diameter Diameter of button in pixels
%  x,y      Mouse location
% 
% OUTPUT 
%  clicked  True if mouse was in button.
%
% Usage: clicked = mouseInButton(center, diameter,x,y)

clicked = sqrt((x-center(1))^2 + (y-center(2))^2) < diameter/2;
