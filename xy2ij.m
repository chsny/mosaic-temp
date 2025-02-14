% xy2ij Transforms xy coordinates (in um) in row and columns indices
%
% Inputs:
% xy            [2]       X,Y location to transform [um]
% frame_sz      [2]       Size vector of the matrix
%
% Output:
% ij            [2]       i,j row and column indices corresponding to the location xy 


function ij = xy2ij(xy, frame_sz)

height = frame_sz(1);
width = frame_sz(2);

ij = [map(xy(2), height) map(xy(1),width)];

    function i = map(x, N)
    % map   Converts length l from range [-L/2, L/2] to pixel index from range
    % [1, N] (with L = N * l_px)
    load("calibration.mat", "l_px")
    L = N * l_px;
    i = min(floor((x+L/2)/l_px) + 1, N);
    end
end