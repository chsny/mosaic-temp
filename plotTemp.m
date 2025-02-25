% plotTemp Plots the temperature distribution T in the (x,y) space based on the pixel calibration.
%
% NOTE: T MUST BE COMPUTED FROM AN INTERPOLATED IMAGE, OTHERWISE SCALING WILL NOT BE CORRECT
%
% Inputs:
% T             [heigth, width]                 Temperature matrix [K]
% mp_prop_loc   [height, width]                 Location vector of the melt pool widht and length [-]
% spectrum_loc  [2]                             XY location of the spectrum to plot [-]
% ax                                            Axes to use for the plot [-]

function im = plotTemp(T, mp_prop_loc, spectrum_loc, ax)
arguments
    T (:,:)
    mp_prop_loc = []
    spectrum_loc = [] % [um]
    ax = gca
end

if isempty(mp_prop_loc)
    plotMpProp = false;
else
    plotMpProp = true;
end

if isempty(spectrum_loc)
    plotSpectrumLoc = false;
else
    plotSpectrumLoc = true;
end
sz = size(T);

% XY limits of the plot in mm
xy0 = ij2xy([0 0], sz);
xyEnd = ij2xy(sz, sz); 
x = [xy0(1) xyEnd(1)];
y = [xy0(2) xyEnd(2)];

im = plotTemp_ij(T, ax);
im.XData = x;
im.YData = y;

xlimits = [-1000 1500];
ylimits = [-1000 1000];
xlim(ax, xlimits);
xlabel(ax, "X axis [um]");
ylim(ax, ylimits);
ylabel(ax, "Y axis [um]")

% % location of the min temp
% hold(ax,'on')
% [~, k_min] = min(T, [], 'all');
% [i_min, j_min] = ind2sub(sz, k_min);
% xy_min = ij2xy([i_min, j_min], sz);
%plot(ax, xy_min(1), xy_min(2), 'b*'); % plots min temp location

if plotSpectrumLoc
    plot(ax, spectrum_loc(1), spectrum_loc(2), 'r*') % plots location of current plotted spectrum
end

if plotMpProp
    plot(ax, points(1:2,1), points(1:2,2), 'k-*')
    plot(ax, points(3:4,1), points(3:4,2), 'k-*')
end
end
