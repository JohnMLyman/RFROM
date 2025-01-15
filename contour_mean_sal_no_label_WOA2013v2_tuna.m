%this code contours mean salinity

function contour_mean_sal_no_label_WOA2013v2_tuna
path_woa2013v2='D:\WOA2013v2\';

path_tpx_means='C:\Users\jlyma\OneDrive - University of Hawaii\Documents\OHCA_2020\tpest_test\tpxtest\';
path_tpx_means='G:\C_drive\Documents\OHCA_2020\tpest_test\tpxtest\';

load([path_tpx_means,'meanssh.mat'], 'lat', 'lon')
lon_tpx=[lon(542:end)-360;lon(1:541)];
lat_tpx=lat;

clear lon lat

load([path_tpx_means,'landmask.mat'], 'msk2')

% load Levitus high-res climatology so we can subtract it (mean?)
lat=ncread([path_woa2013v2,'woa13_decav_s00_01v2.nc'],'lat');
lon=ncread([path_woa2013v2,'woa13_decav_s00_01v2.nc'],'lon');
depth=ncread([path_woa2013v2,'woa13_decav_s00_01v2.nc'],'depth');
sal=ncread([path_woa2013v2,'woa13_decav_s00_01v2.nc'],'s_an');

lat=double(lat);
lon=double(lon);
% load /Volumes/ThunderBay/Data/WOA09/salinity_annual_1deg.mat sal lat lon depth

dep=depth;
ii_lev=find(lon<=180);
jj_lev=find(lon>180);
lon=[lon(jj_lev)-360;lon(ii_lev)];
levsal=[sal(jj_lev,:,:,:);sal(ii_lev,:,:,:)];

levsal=[levsal(end-40:end,:,:);levsal;levsal(1:41,:,:)];
lon=[lon(end-40:end)-360; lon; 360+lon(1:41)];
levsal(:,end+1,:)=levsal(:,end,:);lat(end+1)=lat(end)+mean(diff(lat));
surface_sal=levsal(:,:,1);

corrhc=interp2(lat,lon,surface_sal,lat_tpx,lon_tpx');
corrhc(isnan(msk2(2:end-1,:)))=NaN;

%hold on 

gray=[.7 .7 .7];
gray=[.35 .35 .35];
ii=find(lon_tpx<30);
jj=find(lon_tpx>=30);
lon_tpx=[lon_tpx(jj);lon_tpx(ii)+360];
corrhc=[corrhc(jj,:);corrhc(ii,:)];

[C,h]=m_contour(lon_tpx,lat_tpx,corrhc',[32:.5:38]);

sal_cont=corrhc;
lat_cont=lat_tpx;
lon_cont=lon_tpx;

%save /Volumes/Data/WOA09/salinity_annual_1deg_cont.mat sal_cont lat_cont lon_cont
%jj=clabel(C,h);
set(h,'color',gray);
%set(jj,'color',gray);
% [C1,h1]=m_contour(lon_tpx+360,lat_tpx,corrhc',[32:.5:38],'c');

%UNCOMMENT!!!
 jj=clabel(C,h,'manual');


%set(h1,'color',gray);
set(jj,'color',gray);

%hold off
