
date_vec1='200105'

path_ME='D:\ME4OH\data\en4.1.1\1979-2014\full\update\';
file_ME=['ofam3-jra55.all.EN.4.1.1.f.profiles.g10.',date_vec1,'.update.nc']


temp_ME=ncread([path_ME,file_ME],'temp');
depth_ME=ncread([path_ME,file_ME],'ts_z');
lon_ME=ncread([path_ME,file_ME],'ts_lon');
la_MEt=ncread([path_ME,file_ME],'ts_lat')';
s=size(temp_ME);
max_ME=nan(1,s(2));
for iprof=1:s(2)
     good=isfinite(temp_ME(:,iprof));
     max_ME(iprof)=max(depth_ME(good));


end
path_EN4='D:\EN4\Cheng_2014\';
file_EN4=['EN.4.2.2.f.profiles.c14.',date_vec1,'.nc']
depth_EN4=ncread([path_EN4,file_EN4],'DEPH_CORRECTED');
temp_EN4=ncread([path_EN4,file_EN4],'TEMP');
lon_EN4=ncread([path_EN4,file_EN4],'LONGITUDE');
lat_EN4=ncread([path_EN4,file_EN4],'LATITUDE');


depth_EN4(depth_EN4>1e10)=nan;
max_EN4=max(depth_EN4);



figure(1)

histogram(max_ME)
figure(2)
histogram(max_EN4)
figure(3)
scatter(lon_EN4,lat_EN4,max_EN4./100,max_EN4,'filled')
clim([0 2000])
figure(4)
scatter(lon_ME,lat_ME,max_ME./100,max_ME,'filled')
clim([0 2000])

