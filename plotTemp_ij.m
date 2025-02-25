% plotTemp_ij Plots the temperature distribution T in the (i,j) space (row and column index).
%
% Inputs:
% T             [heigth, width]                 Temperature matrix [K]
% ax                                            Axes to use for the plot [-]
function im = plotTemp_ij(T, ax)
arguments
    T (:,:)
    ax = gca;
end

imAlpha=ones(size(T));
imAlpha(isnan(T))=0;
clims = [1300 3000];

cla(ax);
im = imagesc(ax, T, 'AlphaData', imAlpha, clims);
axis(ax,'image');
hc = colorbar(ax);
hc.Ruler.TickLabelFormat='%g K';
title(ax, "Temperature");
end