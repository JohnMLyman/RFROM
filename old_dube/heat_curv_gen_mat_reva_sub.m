function [hc_tpx,time,hc_tpx_no]=heat_curv_gen_mat_reva(file_name)



alpha=(.6e7)/(.04);
area_of_ocean=3.4e14;
area_of_earth=5.1e14;
scale=alpha;
load ../../Mtpers/meanssh lat lon sshmean
% to get rid of ice
sshmean=[sshmean(542:end,:);sshmean(1:541,:)];

lon_tpx=[lon(542:end)-360;lon(1:541)];
lat_tpx=lat;
arw=areavec(lon_tpx,lat_tpx);
clear lon lat

load ../../HC/landmask msk2
eval(['load ' file_name]);

 lon2=lon;

 lat2=lat;
% subsect for a particular lat and lon range

good_lat=find((lat >-60) & (lat< -55));
good_lon=find((lon > -180) & (lon < 180));

lat=lat(good_lat);
lat2=lat;
lon=lon(good_lon);
lon2=lon;
tpx=tpx(good_lon,good_lat,:);
tpx_no=tpx_no(good_lon,good_lat,:);
 
for i=1:length(time)

lon=lon2;
lat=lat2;

% linear interpilate to topex grid and apply mland mask

corrhc=interp2(lat,lon,tpx(:,:,i),lat_tpx,lon_tpx');
corrhc(isnan(msk2(2:end-1,:)))=NaN;
corrhc(isnan(sshmean))=NaN;

corrhc_no=interp2(lat,lon,tpx_no(:,:,i),lat_tpx,lon_tpx');
corrhc_no(isnan(msk2(2:end-1,:)))=NaN;
corrhc_no(isnan(sshmean))=NaN;




lor=lon_tpx;
lat=lat_tpx;
Area=sum(arw(~isnan(corrhc)));
% compute the area average heatcontent across the globe.

hc_tpx(i)=nansum(arw(:).*corrhc(:));
hc_tpx_no(i)=nansum(arw(:).*corrhc_no(:));


time_hc(i)=time(i);


end

