file='RG_ArgoClim_Temperature_2019.nc';
file_s='RG_ArgoClim_Salinity_2019.nc';
file_matlab='RG_ArgoClim.mat';
path_file= 'C:\Users\jlyma\OneDrive - University of Hawaii\data\Roemmich_Gilson_Clim\';
path_monthly='C:\Users\jlyma\OneDrive - University of Hawaii\data\Roemmich_Gilson_Clim\monthly\';
file_name=[path_file,file];
file_name_s=[path_file,file_s];

time_2018=ncread(file_name,'TIME');
lat=ncread(file_name,'LATITUDE');
lon=ncread(file_name,'LONGITUDE');
pres=ncread(file_name,'PRESSURE');
mask=ncread(file_name,'MAPPING_MASK');
bmask=ncread(file_name,'BATHYMETRY_MASK');
temp_2018=ncread(file_name,'ARGO_TEMPERATURE_ANOMALY');
mean_temp=ncread(file_name,'ARGO_TEMPERATURE_MEAN');
sal_2018=ncread(file_name_s,'ARGO_SALINITY_ANOMALY');
mean_sal=ncread(file_name_s,'ARGO_SALINITY_MEAN');

s=dir([path_monthly,'*.nc']);
nmonths_new=length(s);
s_var=size(sal_2018);

sal=nans(s_var(1),s_var(2),s_var(3),s_var(4)+nmonths_new);
temp=sal;
time=nans(s_var(4)+nmonths_new,1);
sal(:,:,:,1:s_var(4))=sal_2018;
temp(:,:,:,1:s_var(4))=temp_2018;
time(1:s_var(4))=time_2018;
clear time_2018 sal_2018 temp_2018
for ifile=1:nmonths_new
    timej=ncread([s(ifile).folder,'\',s(ifile).name],'TIME');
    salj=ncread([s(ifile).folder,'\',s(ifile).name],'ARGO_SALINITY_ANOMALY');
    tempj=ncread([s(ifile).folder,'\',s(ifile).name],'ARGO_TEMPERATURE_ANOMALY');
    sal(:,:,:,s_var(4)+ifile)=salj;
    temp(:,:,:,s_var(4)+ifile)=tempj;
    time(s_var(4)+ifile)=timej;
    clear timej salj tempj
end


save([path_file,file_matlab],'sal','temp','time','lat','lon','pres',...
    'mean_temp','mean_sal','bmask','mask','-v7.3')


