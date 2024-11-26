 function [hc,time,hc_one]=heat_curv_gen_mat_abhi(file_name,var_name)




%var_name should be onw of the four
% tslaE;
% ht=tslaO;
% ht=ptaO;
% htptaE
 
load meanssh lat lon sshmean
% to get rid of ice
sshmean=[sshmean(542:end,:);sshmean(1:541,:)];

lon_tpx=[lon(542:end)-360;lon(1:541)];
lat_tpx=lat;
arw=areavec(lon_tpx,lat_tpx);
clear lon lat

load landmask msk2


eval(['load ' file_name]);
 lon2=lon;

 lat2=lat;
eval(['ht=',var_name,';']);

 
for i=1:length(time)



lon=lon2;
lat=lat2;



corrhc=interp2(lat,lon,ht(:,:,i),lat_tpx,lon_tpx')./1e9;
corrhc(isnan(msk2(2:end-1,:)))=NaN;
corrhc(isnan(sshmean))=NaN;

corrhc_one=interp2(lat,lon,one(:,:,i),lat_tpx,lon_tpx');
corrhc_one(isnan(msk2(2:end-1,:)))=NaN;
corrhc_one(isnan(sshmean))=NaN;



lor=lon_tpx;
lat=lat_tpx;
Area=sum(arw(~isnan(corrhc)));

hc_rep(i)=1e9.*nansum(arw(:).*corrhc(:))./sum(arw(~isnan(corrhc)));
hc_one(i)=nansum(arw(:).*corrhc_one(:))./sum(arw(~isnan(corrhc_one)));
hc(i)=1e9.*nansum(arw(:).*corrhc(:));

time_hc(i)=time(i);


end


area_of_earth=5.1e14;

hc1=hc_rep*3.4e14;


one_curve=hc_one;
 hc_one=hc1./hc_one;

