clear variables
close all

[~, ~, ~, wl_peak, ~] = getMosaicProp();
[wl_peak_sorted, i_sort] = sort(wl_peak);

data_folder = "data";

%% PRECITEC, 12 BITS IMAGE (2023)
exposure = 200; % us
bitlength = 12;
head = "precitec";

filename = "587/445507.tif"; %"780/77700.tif"; %"780/77701.tif";
raw_frames = readImages(fullfile(data_folder, filename), bitlength);
clipped_frames = clipFrames(raw_frames);
interpolate = 0;
sort_wl = true;
deb_frames = debayer(clipped_frames, interpolate, sort_wl); % deb_frames are outputted in sorted order

[i_wl, L, T, emissivity, err] = fitTemp(deb_frames, exposure, bitlength, head);


%% Radiance plot for Precitec, 12 bits image
close all

i = round(162/5); % image is not interpolated so index is divided by a macropixel width
j = round(207/5);

f = figure;
f.Units = "centimeters";
f.Position(3:4) = [10 8];
plotRadiance_ij(wl_peak_sorted(i_wl), deb_frames(:,:,i_wl), L, T, emissivity, [i j])
% exportgraphics(gcf,'./figures/radianceplot_precitec.png','Resolution',300)

%% Plot of temperature estimation for Precitec, 12 bits image
close all

% Plot 1: temperature distribution
f = figure;
f.Units = "centimeters";
f.Position(3:4) = [9 6];
plotTemp_ij(T);
% exportgraphics(gcf,'./figures/tempplot_precitec.png','Resolution',300)


% Plot 2: tiled plots
imAlpha=ones(size(T));
imAlpha(isnan(T))=0;

f = figure;
f.Units = "centimeters";
f.Position(3:4) = [12 9];
tiledlayout(2,2);

nexttile
imagesc(raw_frames)
axis image
title("Raw hyperspectral image")
colorbar

nexttile
plotTemp_ij(T);
title("Temperature")

nexttile
imagesc(emissivity, 'AlphaData',imAlpha)
axis image
title("Emissivity")
clim([0 1])
colorbar

nexttile
imagesc(err, 'AlphaData',imAlpha)
axis image
title("Least square fitting error")
colorbar

% exportgraphics(gcf,'./figures/fullplot_precitec.png','Resolution',300)

%% HIGHYAG, 8 BITS IMAGE (2021)
head = "highyag";
exposure = 1000; % us
bitlength = 8;

filename = "410\410.mat";
data = load(fullfile(data_folder, filename));
clipped_frames = uint8(data.frame);
interpolate = 0;
sort_wl = true;
deb_frame = debayer(clipped_frames, interpolate, sort_wl);

[i_wl, L, T, emissivity, err] = fitTemp(deb_frame, exposure, bitlength, head);

%% Radiance plot for highyag, 8 bits image
close all

x = 34; 
y = 29;

figure
plotRadiance_ij(wl_peak_sorted(i_wl), deb_frame(:,:,i_wl), L, T, emissivity, [x y])

%% Temperature plot for highyag, 8 bits image
close all

% Plot 1: temperature distribution
figure
plotTemp_ij(T);

% Plot 2: tiled plots
imAlpha=ones(size(T));
imAlpha(isnan(T))=0;

figure
t = tiledlayout(2,2);

nexttile
imagesc(raw_frames);
axis image
title("Raw hyperspectral image")
colorbar

nexttile
plotTemp_ij(T);
title("Temperature")

nexttile
imagesc(emissivity, 'AlphaData',imAlpha);
axis image
title("Emissivity")
clim([0 1])
colorbar

nexttile
imagesc(err, 'AlphaData',imAlpha);
axis image
title("Least square fitting error")
colorbar