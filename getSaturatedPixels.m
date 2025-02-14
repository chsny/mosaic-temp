% getSaturatedPixels Returns the index of the saturated pixels in frames
%
% Inputs:
% frames    [heigth, width,...]     Clipped or raw frames
% bitlength [1]                     Number of bits to encode each pixel value
%
% Outputs:
% index     [n_sat_pixels]          Logical array of saturated pixels

function index_sat = getSaturatedPixels(frames, bitlength)

threshold = 5;
index_sat = frames > (2^bitlength-1 - threshold);
end