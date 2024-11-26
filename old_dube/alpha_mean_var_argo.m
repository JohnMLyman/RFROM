

alpha=(.6e7)/(.04);
area_of_ocean=3.4e14;
area_of_earth=5.1e14;

alpha_paper=alpha*area_of_ocean./1e21
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

 
load ../../HC/hregress_argo
 

lon=alon;
lat=alat;

% linear interpilate to topex grid and apply mland mask

corrhc=interp2(lat,lon,alpha,lat_tpx,lon_tpx');
corrhc(isnan(msk2(2:end-1,:)))=NaN;
corrhc(isnan(sshmean))=NaN;


Area=sum(arw(~isnan(corrhc)));
% compute the area average heatcontent across the globe.

mean_alpha=nansum(arw(:).*corrhc(:))./Area;
var=nansum(arw(:).*(corrhc(:)-mean_alpha).^2)./Area;



paper_mean=mean_alpha*area_of_ocean./1e21
paper_std=sqrt(var)*area_of_ocean./1e21



