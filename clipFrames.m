% clipMosaicData Extracts a submatrix from rawData which is a multiple of
% several macropixels and starts at the first macropixel upper left corner.
%
% Inputs:
% frames        [heigth, width, n_frames]   Raw frames with upper left corner not necessarily being the corner of a full macropixel   
% roi           [2,2]                       Region of interest = [istart istop; jstart jstop]
%
% Outputs:
% clippedFrames [heigth, width, n_frames]   Frames clipped at the first upper left macropixel corner

function clippedFrames = clipFrames(frames, roi)

arguments
frames 
roi = []
end

mpx_width = 5; % width of macropixel
[height, width, ~, ~] = size(frames);
if isempty(roi)
    roi = [0 height; 0 width];
end

[ci, cj] = macropxCorner(width,height);

i_start = roi(1,1); i_stop = roi(1,2); j_start = roi(2,1); j_stop = roi(2,2);

ci = ci + ceil((i_start-ci)/mpx_width)*mpx_width;
cj = cj + ceil((j_start-cj)/mpx_width)*mpx_width;

cx2 = ci + floor((i_stop-ci)/mpx_width)*mpx_width - 1; % location of lower right macropixel corner
cy2 = cj + floor((j_stop-cj)/mpx_width)*mpx_width - 1;

clippedFrames = frames(ci:cx2, cj:cy2, :, :);
end