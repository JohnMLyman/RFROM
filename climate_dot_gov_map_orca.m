function climate_dot_gov_map_orca(TreeSetUp,depth_top_plot,depth_bot_plot)
path_curves=[TreeSetUp.path_Fig_data,'curves\'];
path_figs=TreeSetUp.path_Figs;
start_year_plot=floor(TreeSetUp.start_year);
end_year_plot=ceil(TreeSetUp.end_year);
OUTOUT_type=TreeSetUp.OUTOUT_type;
path_heat_slope=path_curves;
heat_slope_file=[path_heat_slope,'slope_heat_',OUTOUT_type,'_',num2str(depth_top_plot),'_',num2str(depth_bot_plot)];
heat_slope_file_nc=[path_heat_slope,'slope_heat_',OUTOUT_type,'_',num2str(depth_top_plot),'_',num2str(depth_bot_plot),'.nc'];

% load /Volumes/ThunderBay/Data/Globalhc/Mtpers/meanssh lat lon 
% lon_tpx=[lon(542:end)-360;lon(1:541)];
% lat_tpx=lat;
% the lat and lon in topo_tpx is wrong!!!


% load('/Volumes/ThunderBay/Data/Globalhc/SAL/Floats/slope_heat_2022_tpx_0_700.mat')
% load('C:\Users\jlyma\OneDrive - University of Hawaii\data\OHCA\OHCA_grided\slope_heat_2022_tpx_0_700.mat')
load(heat_slope_file)
lon_tpx=lon;
lat_tpx=lat;


% load /Volumes/ThunderBay/Data/Globalhc/HC/landmask msk2 lon2 lat2
% % % load('C:\Users\jlyma\OneDrive - University of Hawaii\Documents\OHCA_2020\landmask.mat')
% % % 
% % % % cahnge msk2 to be 0 to 360
% % % pos_360=lon2<1 & lon2>-180.00;
% % % pos_360_1=lon2<180 &lon2>=-1;
% % % msk2_360=[msk2(pos_360_1,:); msk2(pos_360,:)];
% % % 
% % % lon2_360=[lon2(pos_360_1);lon2(pos_360)+360];
% % % 
% % % mask2=interp2(lat2,lon2_360',msk2_360,lat_tpx',lon_tpx);


% load('/Volumes/ThunderBay/Data/Globalhc/SAL/Floats/slope_heat_2021_tpx_0_700.mat')
% load('C:\Users\jlyma\OneDrive - University of Hawaii\data\OHCA\OHCA_grided\slope_heat_2022_tpx_0_700.mat')
load(heat_slope_file)

slope=slope./1e9;
error=error./1e9; 

corrhc=slope;
%corrhc(isnan(corrhc))=0;
%corrhc(isnan(msk2(2:end-1,:)))=NaN;
% corrhc(isnan(mask2))=NaN;

slope=corrhc;

corrhc=error;
%corrhc(isnan(corrhc))=0;
%corrhc(isnan(msk2(2:end-1,:)))=NaN;
% corrhc(isnan(mask2))=NaN;

error=corrhc;
lon=lon_tpx';
lat=lat_tpx;
% put into the proper coordinates


ii=find(lon<30);
jj=find(lon>=30);
lon=[lon(jj);lon(ii)+360];
slope=[slope(jj,:);slope(ii,:)];
error=[error(jj,:);error(ii,:)];

slope=slope.*1e9/24/365.25/3600;

error=error.*1e9/24/365.25/3600;

nlon=length(lon);
nlat=length(lat);

% file_name='C:\Users\jlyma\OneDrive - University of Hawaii\data\OHCA\climate_dot_gov\trend_pmel_0_700_1993_2021.nc'
file_name=heat_slope_file_nc;


nccreate(file_name,'slope','Dimensions', {'lon',nlon,'lat',nlat},...
         'FillValue','disable')
 nccreate(file_name,'error','Dimensions', {'lon',nlon,'lat',nlat},...
     'FillValue','disable')
 
 nccreate(file_name,'lon','Dimensions', {'lon',nlon},...
     'FillValue','disable')
 nccreate(file_name,'lat','Dimensions', {'lat',nlat},...
     'FillValue','disable')
ncwrite(file_name,'slope',slope,[1,1]);
ncwrite(file_name,'error',error,[1,1]);
ncwrite(file_name,'lon',lon,[1]);
ncwrite(file_name,'lat',lat,[1]);



%%% 

% close all
% clear all
% 
% load('/Volumes/ThunderBay/Data/Globalhc/SAL/Floats/OHCA_2019_tpx.mat')
% nlon=length(lon);
% nlat=length(lat);
% ht=corrhc;
% 
% file_name='/Volumes/ThunderBay/Data/Globalhc/SAL/Floats/OceanHeat_SoC_2020.nc'
% nccreate(file_name,'ht','Dimensions', {'lon',nlon,'lat',nlat},...
%          'FillValue','disable')
%  
%  nccreate(file_name,'lon','Dimensions', {'lon',nlon},...
%      'FillValue','disable')
%  nccreate(file_name,'lat','Dimensions', {'lat',nlat},...
%      'FillValue','disable')
% ncwrite(file_name,'ht',ht,[1,1]);
% 
% ncwrite(file_name,'lon',lon,[1]);
% ncwrite(file_name,'lat',lat,[1]);