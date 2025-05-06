% fitTemp Fit grey body model to measured spectrum of each pixel in frames
% and estimates temperature (multicolor pyrometry method)
%
% Inputs:
% deb_frames    [heigth, width, n_bands, n_frames]  Debayered frames with wavelengths in INCREASING ORDER (not in Mosaic order) !! [DN]
% exposure      [1]                                 Exposure time used to capture the frames [us]
% bitlength     [1]                                 Number of bits to encode each pixel value
% method        "mean gain" or "per pixel gain"     Type of gain to used
%
% Outputs:
% i_wl          [n_useful_bands]                    Indices of wl_peak_sorted used to compute the temperature
% L             [height, width, n_bands, n_frames]  Pixel spectra matrix [W/m2/sr/nm]
% T             [heigth, width, n_frames]           Temperature matrix [K]
% emissivity    [height, width, n_frames]           Emissivity matrix [-]
% err           [height, width, n_frames]           Fitting error matrix [-]

function [i_wl, L, T, emissivity, err] = fitTemp(deb_frames, exposure, bitlength, head)

arguments
    deb_frames (:,:,:,:)
    exposure double
    bitlength = 8
    head = "highyag"
end

[height, width, n_bands, n_frames] = size(deb_frames);

%% Camera calibration
[~, ~, ~, wl_peak, ~] = getMosaicProp();
[wl_peak_sorted, i_sort] = sort(wl_peak);

if bitlength == 12
   load("calibration.mat", "S0_12bits");
   S0 = 110; % S0_12bits;
elseif bitlength == 8
    load("calibration.mat", "S0_8bits");
    S0 = S0_8bits;
else
    error("Unknown bitlength")
end

%% Useful bands and reference band
switch head
    case "highyag"
        i_wl = [4 6 8:20]; % ignore 1) high wls because of low T_miclad 2) low wls because of low SNR 3) 731nm and 742nm because low G_mosaic
        wl_ref = 884; %  wl_ref = 884nm because highest SNR
        i_ref = find(wl_peak_sorted(i_wl) == wl_ref); % index of the reference wl IN THE i_wl VECTOR
    case "precitec"
        i_wl = 1:18;%[1:4 6 8:25]; % ignore 731 and 742 nm because very low gain
        wl_ref = 884; %  wl_ref = 884nm because highest SNR
        i_ref = find(wl_peak_sorted(i_wl) == wl_ref); % index of the reference wl IN THE i_wl VECTOR
end
        
wl_tempestim = wl_peak_sorted(i_wl); % wavelengths used to compute T
deb_frames = deb_frames(:,:,i_wl,:);
%% Data cleaning: ignoring saturated and low signal pixels
index_sat = getSaturatedPixels(deb_frames,bitlength);
deb_frames(index_sat) = 0;
index_black = getBlackPixels(deb_frames, bitlength);
deb_frames(index_black) = 0;

%% Temperature fitting method
G_total = getGtotal(exposure, bitlength, head); % G_total is in increasing order
G_total = G_total(i_wl);
G_total = reshape(G_total, 1, 1, [], 1);

L = double(deb_frames - S0) ./G_total; % 3D matrix of pixel spectra [heigth, width, n_bands]

T = zeros(height, width, n_frames);
emissivity = zeros(height, width, n_frames);
err = zeros(height, width, n_frames);

for k = 1:n_frames
    for i = 1:height
        for j = 1:width
            L_loc = squeeze(L(i,j,:,k));
            i_valid = find(L_loc ~= 0);
            n_valid = length(i_valid);
            wlRefIsDiscarded = not(any(i_valid == i_ref)); % boolean value indicating if L(wl_ref) == 0
            if n_valid < 5 || wlRefIsDiscarded
                T(i,j,k) = NaN;
                err(i,j,k) = NaN;
                emissivity(i,j,k) = NaN;
            else
                L_ref = L_loc(i_ref);
                [T_loc, emissivity_loc, error_loc] = fitTempLocal(wl_tempestim(i_valid), L_loc(i_valid), wl_ref, L_ref);
                T(i,j,k) = T_loc;
                emissivity(i,j,k) = emissivity_loc;
                err(i,j,k) = error_loc;
            end
        end
    end
end
end

function [T_loc, emissivity_loc, err_loc] = fitTempLocal(wl, L_loc, wl_ref, L_ref)
% Multicolor pyrometry with grey body hypothesis
T0 = 1670;
T_lb = 900;
T_ub = 3500;
fun_error = @(T) abs(L_loc/L_ref - blackbody(wl,T)/blackbody(wl_ref,T));

% % Multicolor pyrometry with linear emissivity
% emissivity = @(wl,A,B) A - B*wl; 
% fun_error = @(x) (L_loc - emissivity(wl_loc, x(2), x(3)).*blackbody(wl_loc,x(1)))./sqrt(sigma_L_loc);
% T0 = 1670;
% A0 = 0.3;
% B0 = 0;
% x0 = [T0 A0 B0];
% lb = [900 0 0];
% ub = [3500 1 1/1000]

options = optimoptions('lsqnonlin', 'Algorithm','levenberg-marquardt', 'Display', 'off');
[T_loc, err_loc] = lsqnonlin(fun_error, T0, T_lb, T_ub, options); % lsqnonlin minimizes fun_error^2
emissivity_loc = L_ref / blackbody(wl_ref,T_loc);
end