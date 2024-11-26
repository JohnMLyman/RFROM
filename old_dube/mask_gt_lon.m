function [pos_mask]=mask_gt_lon(line_lon1,line_lat1,line_lon2,line_lat2,lon_min,lon_max,lon2,lat2)

% The line is defined by line_lon1, line_lat1 and line_lon2,line_lat2
% longitudes greater than this will be in the mask that are
% >= line_lat1, <= line_lat2, >= lon_min, and <= lon_max.
%
% lon2 amd lat2 are a 2-d matrix of the longitudes and latitudes that
% correspond to the grid.
%
% sss is the grided data that is to be masked and is the same size as lon2
% and lat2
% 
% note line_lat1 < line_lat2 and lon_nim < lon_max
% 

[m,b]=find_line(line_lon1,line_lat1,line_lon2,line_lat2);

pos_mask=find(lon2 >= ((lat2-b)./m) & lat2 > line_lat1 & lat2 < line_lat2 & ...
    lat2 < line_lat2 & lon2>= lon_min & lon2<lon_max);


