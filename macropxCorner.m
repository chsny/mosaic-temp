% macropxCorner Returns row and column index of the macropixel corner the
% closest to the upper left corner of the captured image by the Avior 3D-One 
% mosaic camera.
%
% Inputs:
%   width    [px]  Pixel width of the captured image
%   height   [px]  Pixel height of the captured image
% Output:
%   ci       [-]   Row index of the macropixel corner (1-based indexing)
%   cj       [-]   Column index of the macropixel corner (1-based indexing)

function [ci, cj] = macropxCorner(width, height)
mpx_width = 5; % macropixel width

deltai = (2048 - height)/2; % pixel distance (along rows) between sensor corner (2048x2048) and roi corner
ci = (ceil(deltai/mpx_width)*mpx_width - deltai) + 1; % row index of first macropixel corner inside roi
deltaj = (2048 - width)/2; % pixel distance (along columns)
cj = (ceil(deltaj/mpx_width)*mpx_width - deltaj) + 1; % row index of first macropixel corner inside roi
end