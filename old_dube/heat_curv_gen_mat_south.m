function [hc_tpx,hc_tpx_one,time,hc,hc_one]=heat_curv_gen_mat_south(file_name)



alpha=(.6e7)/(.04);
area_of_ocean=3.4e14;
area_of_earth=5.1e14;
scale=alpha;                                                                                                                         

% to plot in zeta-jouels.  Not it is different than t_sub because t_sub has been divided by the area of the ocean
% plot(time,hc_tpx.*scale./1e21)
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
 
for i=1:length(time)

lon=lon2;
lat=lat2;

% linear interpilate to topex grid and apply mland mask


corrhc=interp2(lat,lon,ht(:,:,i),lat_tpx,lon_tpx');
corrhc(isnan(msk2(2:end-1,:)))=NaN;
corrhc(isnan(sshmean))=NaN;

corrhc_tpx=interp2(lat,lon,tpx(:,:,i),lat_tpx,lon_tpx');
corrhc_tpx(isnan(msk2(2:end-1,:)))=NaN;
corrhc_tpx(isnan(sshmean))=NaN;

corrhc_one=interp2(lat,lon,one(:,:,i),lat_tpx,lon_tpx');
corrhc_one(isnan(msk2(2:end-1,:)))=NaN;
corrhc_one(isnan(sshmean))=NaN;



Area=sum(arw(~isnan(corrhc)));
% compute the area average heatcontent across the globe.

hc(i)=nansum(arw(:).*corrhc(:));
hc_tpx(i)=nansum(arw(:).*corrhc_tpx(:));
hc_one_scale(i)=nansum(arw(:).*corrhc_one(:))/sum(arw(~isnan(corrhc_one)));

time_hc(i)=time(i);


end



hc_tpx=hc_tpx.*scale;
hc=hc;
hc_one=hc./hc_one_scale;
hc_tpx_one=hc_tpx./hc_one_scale;

