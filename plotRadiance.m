% plotRadiance Plots measured debayered signal and spectral radiance at
% location spectrum_xy. It also plots the fitted blackbody spectrum
% obtained by a temperature estimation method.
%
% Inputs:
% wl            [n_useful_bands]                Wavelengths used to compute the temperature
% deb_frame     [height, width, n_useful_bands] Debayered frames with wavelengths in the SAME ORDER as wl [DN]
% L             [height, width, n_useful_bands] Pixel spectra matrix [W/m2/sr/nm]
% T             [heigth, width]                 Temperature matrix [K]
% emissivity    [height, width]                 Emissivity matrix [-]
% spectrum_xy   [2]                             XY location of the spectrum [um]

function plotRadiance(wl, deb_frame, L, T, emissivity, spectrum_xy, ax_signal, ax_radiance, LineWidth)
arguments  
    wl
    deb_frame (:,:,:)
    L (:,:,:)
    T (:,:)
    emissivity (:,:)
    spectrum_xy (2,1)
    ax_signal = subplot(2,1,1)
    ax_radiance = subplot(2,1,2)
    LineWidth = 0.5
end
spectrum_ij = xy2ij(spectrum_xy, size(T));
plotRadiance_ij(wl, deb_frame, L, T, emissivity, spectrum_ij, ax_signal, ax_radiance, LineWidth);
end