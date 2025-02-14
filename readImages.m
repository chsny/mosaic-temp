% READIMAGES Reads images using their filenames.
% WARNING: DOESNT CLIP PARTIAL MACROPIXELS
%
% Note: use readImageFolder to auto detect filenames in a folder

function imgs = readImages(filenames, bitlength)

switch bitlength
    case 8
        output_type = 'uint8';
    case 12
        output_type = 'uint16';
end

n_files = length(filenames);

img1 = imread(filenames(1));
[h_px, w_px] = size(img1);
imgs = zeros(h_px, w_px, n_files, output_type);
imgs(:,:,1) = img1;

if n_files>1
    for i=2:n_files
        imgs(:,:,i) = imread(filenames(i));
    end
end

if bitlength == 12
    imgs = bitshift(imgs, -4);
end
end