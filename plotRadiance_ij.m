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
% spectrum_ij   [2]                             IJ index of the location to plot [-]

function plotRadiance_ij(wl, deb_frame, L, T, emissivity, spectrum_ij, ax_signal, ax_radiance, LineWidth)
arguments  
    wl
    deb_frame (:,:,:)
    L (:,:,:)
    T (:,:)
    emissivity (:,:)
    spectrum_ij (2,1)
    ax_signal = subplot(2,1,1)
    ax_radiance = subplot(2,1,2)
    LineWidth = 0.5
end
i = spectrum_ij(1); j = spectrum_ij(2);
S = squeeze(deb_frame(i,j,:));
L_loc = squeeze(L(i,j,:));
T0 = T(i,j);
wl_GB = linspace(min(wl),max(wl)); 
L_GB = emissivity(i,j)*blackbody(wl_GB,T0); % grey body radiance

plot(ax_signal, wl, S, '*', 'LineWidth',  LineWidth);
xlabel(ax_signal, "Wavelength [nm]");
ylabel(ax_signal, "Signal [DN]");
title(ax_signal, "Debayered signal");

plot(ax_radiance, wl, L_loc, '*', wl_GB, L_GB, 'LineWidth',  LineWidth);
xlabel(ax_radiance, "Wavelength [nm]");
ylabel(ax_radiance, "Radiance [W/m^2/sr/nm]");
title(ax_radiance, "Radiance");
legend(ax_radiance, "Measured radiance", "Fitted grey body", "Location", "NorthWest");
end