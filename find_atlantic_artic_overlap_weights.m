function [w_art,w_atl]=find_atlantic_artic_overlap_weights(global_basins,lon,lat)

% This function find the weights for the overlap of the Atlantic and Artic
% Oceans.  lon and lat can be 1 or 2 dimension and must match global_banins







size_data=size(lon);
w_art=ones(size_data);
w_atl=w_art;
lon_180=lon;
lon_180(lon>180)=lon(lon>180)-360;

in_art=global_basins(3).pos;
in_atl=global_basins(5).pos;

load('D:\data\topo_tpx_new.mat','lon_topo','lat_topo','topo_tpx_new')
nlat=length(lat_topo);
nlon=length(lon_topo);

[LON,LAT]=ndgrid(lon_topo,lat_topo);



[global_basins_int]=find_basin_paige_artic_w(LON,LAT);
in_art_int=global_basins_int(3).pos;
in_atl_int=global_basins_int(5).pos;

overlap=in_art&in_atl;
overlap_int=in_art_int&in_atl_int;

LON_180=LON;
LON_180(LON>180)=LON(LON>180)-360;


in_ocean=topo_tpx_new<0;
x_map=[-37.1250   68.8750
      -24.2500   73.7500
        8.1250   51.8750
        1.8770   48.6250
      -37.1250   68.8750];

use_map=inpolygon(lon_180,lat,x_map(:,1),x_map(:,2));
use_map_int=inpolygon(LON_180,LAT,x_map(:,1),x_map(:,2));

distance_atl=nans(size_data);
distance_art=nans(size_data);

use=overlap&use_map;
use_atl=use_map_int&in_ocean&in_atl_int&~overlap_int;
use_art=use_map_int&in_ocean&in_art_int&~overlap_int;


junk_lon=lon_180(use);
junk_lat=lat(use);

s_lat=size(junk_lat);

% for the dimensions of lat and lon to be correct so that they from a
% matrix in min;

if s_lat(1)>s_lat(2)
    
    junk_lon=junk_lon';
    junk_lat=junk_lat';

end

if ~isempty(junk_lat) % sometimes there are no data in the overlap region
    distance_atl(use)=min( ((LON_180(use_atl)-junk_lon)./cosd(60)).^2+((LAT(use_atl)-junk_lat)).^2  );
    distance_art(use)=min( ((LON_180(use_art)-junk_lon)./cosd(60)).^2+((LAT(use_art)-junk_lat)).^2  );
    
    
    
    w_art(use)=distance_atl(use)./(distance_art(use)+distance_atl(use));
    w_atl(use)=1-w_art(use);
end









end