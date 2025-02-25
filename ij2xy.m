function xy = ij2xy(ij, frame_sz)

height = frame_sz(1);
width = frame_sz(2);

xy = [map(ij(2),width) map(ij(1), height)];

    function x = map(i, N)
    % map   Converts index i from index range [1, N]  
    % to length range [-L/2, L/2] (with L = N * l_px)
    load("calibration.mat", "l_px")
    L = N * l_px;
    x = (i - 0.5) * l_px - L/2;
    end
end