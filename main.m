clear variables
close all

[~, ~, ~, wl_peak, ~] = getMosaicProp();
[wl_peak_sorted, i_sort] = sort(wl_peak);

data_folder = "data";

%% PRECITEC, 12 BITS IMAGE (2023)
exposure = 200; % us
bitlength = 12;
head = "precitec";

filenames = ["587/445507.tif"];%["780/77700.tif"]; %, "780/77701.tif"];
raw_frames = readImages(fullfile(data_folder, filenames), bitlength);
clipped_frames = clipFrames(raw_frames);
interpolate = 0;
sort_wl = true;
deb_frames = debayer(clipped_frames, interpolate, sort_wl); % deb_frames are outputted in sorted order

[i_wl, L, T, emissivity, err] = fitTemp(deb_frames, exposure, bitlength, head);


%% Radiance plot for Precitec, 12 bits image
close all

i = round(162/5); % image is not interpolated so index is divided by a macropixel width
j = round(207/5);

figure
plotRadiance_ij(wl_peak_sorted(i_wl), deb_frames(:,:,i_wl), L, T, emissivity, [i j])


%% Plot of temperature estimation for Precitec, 12 bits image
close all
for i=1:length(filenames)
    figure
    t = tiledlayout(2,2);
    title(t, filenames(i))

    nexttile
    imagesc(raw_frames(:,:,i))
    title("Raw hyperspectral image")

    nexttile
    imagesc(T(:,:,i));
    title("Temperature")
    clim([1500 3000])
    colorbar

    nexttile
    imagesc(emissivity(:,:,i))
    title("Emissivity")
    clim([0 1])
    colorbar

    nexttile
    imagesc(err(:,:,i))
    title("Least square fitting error")
    colorbar
end

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

%% Temperature plot for highyag, 8 bits image
close all

figure
t = tiledlayout(2,2);
title(t, "410 (8 bits, highyag head)")

nexttile
imagesc(clipped_frames)
title("Raw hyperspectral image")

nexttile
imagesc(T);
colorbar

nexttile
imagesc(emissivity)
title("Emissivity")
colorbar

nexttile
imagesc(err)
title("Least square fitting error")
colorbar

%% Radiance plot for highyag, 8 bits image
close all

x = 0; % um
y = 0;

figure
plotRadiance(wl_peak_sorted(i_wl), deb_frame(:,:,i_wl), L, T, emissivity, [x y])
title("410 (8 bits, highyag head)")

