
function [weight_a,weight_b,weight_c,weight_d]=round_floor_weight_maps_eqbox(lon_map,lat_map,TreeSetUp)

% scale_box_deg=TreeSetUp.scale_box_deg;


scale_box_deg_lat=TreeSetUp.scale_box_deg_lat;
scale_box_eq=TreeSetUp.scale_box_eq;
lat_change=TreeSetUp.lat_change;


LON=repmat(lon_map,[1 720]);
LAT=repmat(lat_map',[1440 1]);

% 


LAT_round=scale_box_deg_lat.*round(LAT./scale_box_deg_lat);
LAT_floor=scale_box_deg_lat.*floor(LAT./scale_box_deg_lat);


A=scale_box_deg_lat.*abs(sind(lat_change)./(cosd(lat_change).*sind(LAT_round)));
B=scale_box_deg_lat./cosd(LAT_round);
C=scale_box_eq;
AA=min(A,C);
scale_box_deg_lon_round=max(AA,B);

A=scale_box_deg_lat.*abs(sind(lat_change)./(cosd(lat_change).*sind(LAT_floor)));
B=scale_box_deg_lat./cosd(LAT_floor);
C=scale_box_eq;
AA=min(A,C);
scale_box_deg_lon_floor=max(AA,B);




diff_LON_round_round=LON-scale_box_deg_lon_round.*round(LON./scale_box_deg_lon_round);
diff_LON_round_floor=LON-scale_box_deg_lon_floor.*round(LON./scale_box_deg_lon_floor);
diff_LAT_round=LAT-scale_box_deg_lat.*round(LAT./scale_box_deg_lat);
diff_LON_floor_round=LON-scale_box_deg_lon_round.*floor(LON./scale_box_deg_lon_round);
diff_LON_floor_floor=LON-scale_box_deg_lon_floor.*floor(LON./scale_box_deg_lon_floor);
diff_LAT_floor=LAT-scale_box_deg_lat.*floor(LAT./scale_box_deg_lat);

% round weight map

round_weight_lon_round=diff_LON_round_round./scale_box_deg_lon_round;
round_weight_lon_round(round_weight_lon_round>0)=-1.*round_weight_lon_round(round_weight_lon_round>0);
round_weight_lon_round=round_weight_lon_round.*2;

round_weight_lat=diff_LAT_round./scale_box_deg_lat;
round_weight_lat(round_weight_lat>0)=-1.*round_weight_lat(round_weight_lat>0);
round_weight_lat=round_weight_lat.*2;

weight_a=round_weight_lon_round.*round_weight_lat;

% floor weight map

floor_weight_lon_floor=diff_LON_floor_floor./scale_box_deg_lon_floor-.5;
floor_weight_lon_floor(floor_weight_lon_floor>0)=-1.*floor_weight_lon_floor(floor_weight_lon_floor>0);
floor_weight_lon_floor=floor_weight_lon_floor.*2;

floor_weight_lat=diff_LAT_floor./scale_box_deg_lat-.5;
floor_weight_lat(floor_weight_lat>0)=-1.*floor_weight_lat(floor_weight_lat>0);
floor_weight_lat=floor_weight_lat.*2;

weight_d=floor_weight_lon_floor.*floor_weight_lat;

% floor lon round lat

floor_weight_lon_round=diff_LON_floor_round./scale_box_deg_lon_round-.5;
floor_weight_lon_round(floor_weight_lon_round>0)=-1.*floor_weight_lon_round(floor_weight_lon_round>0);
floor_weight_lon_round=floor_weight_lon_round.*2;

weight_c=floor_weight_lon_round.*round_weight_lat;


% floor lat round lon

round_weight_lon_floor=diff_LON_round_floor./scale_box_deg_lon_floor;
round_weight_lon_floor(round_weight_lon_floor>0)=-1.*round_weight_lon_floor(round_weight_lon_floor>0);
round_weight_lon_floor=round_weight_lon_floor.*2;

weight_b=floor_weight_lat.*round_weight_lon_floor;


