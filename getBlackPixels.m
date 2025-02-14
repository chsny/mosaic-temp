% getBlackPixels Returns the index of the pixels at black level in frames
%
% Inputs:
% frames    [heigth, width,...]     Clipped or raw frames
% bitlength [1]                     Number of bits to encode each pixel value
%
% Outputs:
% index     [n_sat_pixels]          Logical array of black pixels

function index_sat = getBlackPixels(frames, bitlength)

load("calibration.mat", "S0_8bits", "S0_12bits");
switch bitlength
    case 8
        S0 = S0_8bits;
        threshold = 15;
    case 12
        S0 = S0_12bits;
        threshold = 150;
end

index_sat = frames-S0 <= threshold;
end