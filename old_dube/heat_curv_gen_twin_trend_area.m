function [hc_tpx,hc_hctpx,time_hc]=heat_curv_gen_twin_trend_area(file_name)

current_dir=cd('/home/shoko2/wills/globalhc_dirs/Globalhc/SAL/Floats/twin/trend');


load ../../../../Mtpers/meanssh lat lon sshmean
% to get rid of ice
sshmean=[sshmean(542:end,:);sshmean(1:541,:)];

lon_tpx=[lon(542:end)-360;lon(1:541)];
lat_tpx=lat;
arw=areavec(lon_tpx,lat_tpx);
clear lon lat

load ../../../../HC/landmask msk2

file_name

ncload(file_name,'lat','lon','tpx','time','hctpx')
 sshtpx=permute(hctpx,[3 2 1]);
 ssh=permute(tpx,[3 2 1]);
 lon2=lon;
 lat2=lat;

 
for i=1:length(time)
%for i=1:2
%%%figure(i);wysiwyg

lon=lon2;
lat=lat2;

% linear interpilate to topex grid and apply mland mask

corrhc=interp2(lat,lon,ssh(:,:,i),lat_tpx,lon_tpx');
corrhc(isnan(msk2(2:end-1,:)))=NaN;
corrhc(isnan(sshmean))=NaN;

corrhc_one=interp2(lat,lon,sshtpx(:,:,i),lat_tpx,lon_tpx');
corrhc_one(isnan(msk2(2:end-1,:)))=NaN;
corrhc_one(isnan(sshmean))=NaN;



lor=lon_tpx;
lat=lat_tpx;
Area=nansum(arw(~isnan(corrhc)));
% compute the area average heatcontent across the globe.

hc_tpx(i)=nansum(arw(:).*corrhc(:))./Area;
hc_hctpx(i)=nansum(arw(:).*corrhc_one(:))./Area;

time_hc(i)=time(i);


end



cd(current_dir);
