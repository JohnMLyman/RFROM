function [hc_tpx,hc_hctpx,time_hc]=heat_curv_gen_twin_realtime_2012_2016(file_name,depth)

current_dir=cd('/Users/lyman/data/Globalhc/HC/twin/EN3');

% load topex/hc regression info

eval(['load /Volumes/Data/Globalhc/Floats/Argo/CORIOLIS/depth_grid/hregress_',depth,'_2.mat'])

eval(['alpha2=alpha_',depth,';'])





%load ../../../Mtpers/meanssh_oco_realtime lat lon sshmean
load ../../../Mtpers/meanssh lat lon sshmean

% to get rid of ice
sshmean=[sshmean(542:end,:);sshmean(1:541,:)];

lon_tpx=[lon(542:end)-360;lon(1:541)];

lat_tpx=lat;
arw=areavec(lon_tpx,lat_tpx);
clear lon lat

% linear interpilate alpha to topex grid and apply mland mask


alpha2=interp2(alat,alon,alpha2,lat_tpx,lon_tpx');clear alon alat 


load ../../../HC/landmask msk2

file_name

eval(['load ',file_name,' lat lon tpx time one'])
 sshtpx=tpx;
 ssh=tpx;
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

corrhc_hc=interp2(lat,lon,sshtpx(:,:,i),lat_tpx,lon_tpx');
corrhc_hc(isnan(msk2(2:end-1,:)))=NaN;
corrhc_hc(isnan(sshmean))=NaN;
corrhc_hc=corrhc_hc.*alpha2;

corrhc_one=interp2(lat,lon,one(:,:,i),lat_tpx,lon_tpx');
corrhc_one(isnan(msk2(2:end-1,:)))=NaN;
corrhc_one(isnan(sshmean))=NaN;


lor=lon_tpx;
lat=lat_tpx;
Area=sum(arw(~isnan(corrhc)));
% compute the area average heatcontent across the globe.

hc_tpx(i)=nansum(arw(:).*corrhc(:))./sum(arw(~isnan(corrhc)));
hc_hctpx(i)=nansum(arw(:).*corrhc_hc(:)./sum(arw(~isnan(corrhc_hc))));
hc_one(i)=nansum(arw(:).*corrhc_one(:))./sum(arw(~isnan(corrhc_one)));

time_hc(i)=time(i);


end
hc_tpx=hc_tpx.*3.4e14./hc_one;
hc_hctpx=hc_hctpx.*3.4e14./hc_one;


cd(current_dir);
