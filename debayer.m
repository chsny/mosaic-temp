% debayer  Interpolates the spectral fields of a hyperspectral cam to each pixel of the sensor.
% WARNING: input frames must be clipped with clipMosaicData first.
%
% Inputs:
% clipped_frames    [height, width, n_frames]           Frames clipped at the first macropixel corner
% linear            int                                 Int to activate interpolation or not and choose interpolation method (linear or cubic)
% sortwl            boolean                             Boolean to choose if wavelength peaks should be sorted
% 
% Outputs:
% debayeredFrames   [heigth, width, n_bands, n_frames]  Debayered frames with wavelengths in SORTED, INCREASING ORDER (not in Mosaic order) WHEN SORTWL IS ACTIVATED (which is default)!!

function debayeredFrames = debayer(clipped_frames, interpolate, sortwl)
arguments
    clipped_frames (:,:,:)
    interpolate = 2 % do cubic interpolation
    sortwl = true % sort peak wavelengths in increasing order
end

% CMV2K NIR sensor properties
n_bands = 25; % number of bands
[~, ~, ~, wl_peak, ~] = getMosaicProp();
[~,i_sort] = sort(wl_peak);

[in_height, in_width, n_frames] = size(clipped_frames);
if mod(in_width,5) ~= 0 || mod(in_height,5) ~= 0
    error("The input data does not have the correct shape");
end

if logical(interpolate) % transforms a positive int in a logical 1 
    out_width = in_width;
    out_height = in_height;
else
    out_width = in_width/5;
    out_height = in_height/5;
end

xq = 1:out_width;
yq = (1:out_height)';

debayeredFrames = zeros([out_height, out_width, n_bands, n_frames], class(clipped_frames));

switch interpolate
    case 1
        method = 'linear';
    case 2
        method = 'cubic';
end

for i_frame = 1:n_frames
    for i_band = 1:n_bands
        % debayering
        ci = double(idivide(int32(i_band-1),5))+1; % wavelength corner row indexes
        cj = mod(i_band-1,5)+1; % wavelength corner column indexes
        veci = ci:5:in_height; % vector of row indexes
        vecj = (cj:5:in_width)'; % vector of columns indexes
        V = double(clipped_frames(veci, vecj, i_frame)); % pixel data of selected wavelength

        % interpolation
        if logical(interpolate) % transforms a positive int in a logical 1
            x = vecj; % X axis = column index
            y = veci; % Y axis = row index
            interpolant = griddedInterpolant({y, x}, V, method, method); 
            % griddedInterpolant is multithreaded and more efficient than interpn (see MATLAB doc)
            Vq = interpolant({yq, xq}); 
        else 
            Vq = V;
        end
        debayeredFrames(:,:,i_band,i_frame) = Vq;
    end
    %debdata(debdata<0) = 0; debdata(debdata>255) = 255;
end

if sortwl
debayeredFrames = debayeredFrames(:,:,i_sort,:);
end 

end