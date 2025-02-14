% getGtotal Returns total mean gain of (MiCLAD + Mosaic camera) system
% 
% Inputs:
%   exposure    [us]                Exposure time of image
%   bitlength   [bits]              Bitlength of image
%   head        string              Name of the processing head used for the experiment
%
% Output:
%   G_total     [DN/(W/m2/sr/nm)]   Total gain in increasing order

function G_total = getGtotal(exposure, bitlength, head)
arguments
    exposure = 5000; % exposure of the calibration experiment outside of the machine (see excel sheet 2021-08-11)
    bitlength = 8;
    head = "highyag"
end

switch head
    case "highyag"
        G_total0 = readmatrix("Gtotal0_highyag.csv")'; % exposure = 5000 us, bitlength = 8 
        if bitlength == 12
            bitlength_factor = (2^12-1)/(2^8-1);
        elseif bitlength == 8
            bitlength_factor = 1;
        else 
            error("Unknown bitlength");
        end
    case "precitec"
        G_total0_precitec = readmatrix("Gtotal0_precitec.csv");
        G_total0 = G_total0_precitec(:,1); % exposure = 5000 us, bitlength = 12
        if bitlength == 12
            bitlength_factor = 1;
        elseif bitlength == 8
            bitlength_factor = (2^8-1)/(2^12-1);
        else
            error("Unknown bitlength");
        end
    otherwise
        error("Unknown processing head")
end

G_total = bitlength_factor* exposure * G_total0;
end