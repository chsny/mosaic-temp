% blackbody Returns blackbody's spectral radiance at temperature T and wavelength
% wl following Planck's law.

% Inputs:
%   wl  [nm]    Wavelength
%   T   [K]     Temperature

% Output:
%   B   [W/m^2/nm/sr]   Spectral radiance

function B = blackbody(wl,T)
arguments
    wl (:,1) double
    T (1,1) double
end
h = 6.62607015e-34; % [Js]
c = 299792458; % [m/s]
kB = 1.380649e-23; % [J/K]
wl_m = wl*1e-9; % [nm] --> [m]
B = (2*h*c^2./(wl_m.^5)./(exp(h*c./(wl_m*kB*T))-1))/1e9; % spectral radiance [W/m^2/nm/sr]
end