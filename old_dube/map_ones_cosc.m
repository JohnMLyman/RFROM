function [corrhc_one,lon,lat]=map_ones_cosc(start_year)

%close(1)
%close(2)
cd '/Users/johnlyman/data/Globalhc/SAL/Floats'
load ../../Mtpers/meanssh lat lon sshmean
% to get rid of ice
sshmean=[sshmean(542:end,:);sshmean(1:541,:)];

lon_tpx=[lon(542:end)-360;lon(1:541)];
lat_tpx=lat;
arw=areavec(lon_tpx,lat_tpx);
clear lon lat

load ../../HC/landmask msk2
%[lon,lat,time,ht]=load_idl_data_mean_heat('../SAL/Floats/mean_1960_2000.nc');
%load htanom_2004_2007_mon_975
load 'htanom_oco_realtime_1993_2008.mat'
%error=1-(error-2.2);
 lon2=lon;

 lat2=lat;
nlon=length(lon_tpx);
nlat=length(lat_tpx);
corrhc_one_total=ones(nlon,nlat)*0;
year_map=floor(time);
mon_map=round(12.*(time-floor(time)))+1;

index=max(find(year_map == start_year));

corrhc_one=interp2(lat,lon,squeeze(one(:,:,index)),lat_tpx,lon_tpx');
corrhc_one(isnan(corrhc_one))=0.;

corrhc_one(isnan(msk2(2:end-1,:)))=NaN;
corrhc_one(isnan(sshmean))=NaN;
lon=lon_tpx;
lat=lat_tpx;
