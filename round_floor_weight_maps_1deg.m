
function [weight_a,weight_b,weight_c,weight_d]=round_floor_weight_maps_1deg(lon_map,lat_map,TreeSetUp)

scale_box_deg=TreeSetUp.scale_box_deg;
% scale_box_deg=1;

LON=repmat(lon_map,[1 720]);
LAT=repmat(lat_map',[1440 1]);

diff_LON_round=LON-scale_box_deg.*round(LON./scale_box_deg);
diff_LAT_round=LAT-scale_box_deg.*round(LAT./scale_box_deg);
diff_LON_floor=LON-scale_box_deg.*floor(LON./scale_box_deg);
diff_LAT_floor=LAT-scale_box_deg.*floor(LAT./scale_box_deg);
% round weight map

round_weight_lon=diff_LON_round./scale_box_deg;
round_weight_lon(round_weight_lon>0)=-1.*round_weight_lon(round_weight_lon>0);
round_weight_lon=round_weight_lon.*2;

round_weight_lat=diff_LAT_round./scale_box_deg;
round_weight_lat(round_weight_lat>0)=-1.*round_weight_lat(round_weight_lat>0);
round_weight_lat=round_weight_lat.*2;

weight_a=round_weight_lon.*round_weight_lat;

% floor weight map

floor_weight_lon=diff_LON_floor./scale_box_deg-.5;
floor_weight_lon(floor_weight_lon>0)=-1.*floor_weight_lon(floor_weight_lon>0);
floor_weight_lon=floor_weight_lon.*2;

floor_weight_lat=diff_LAT_floor./scale_box_deg-.5;
floor_weight_lat(floor_weight_lat>0)=-1.*floor_weight_lat(floor_weight_lat>0);
floor_weight_lat=floor_weight_lat.*2;

weight_d=floor_weight_lon.*floor_weight_lat;

% floor lon round lat

weight_c=floor_weight_lon.*round_weight_lat;


% floor lat round lon

weight_b=floor_weight_lat.*round_weight_lon;


