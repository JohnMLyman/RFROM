path_ME4OH_SSH= 'D:\ME4OH\data\ofam3\sfc\';
path_ME4OH_SST=path_ME4OH_SSH;

file_SST='temp_ofam3_7d_197901-201412.0p25x0p25.nc';
file_SSH='etat_ofam3_7d_197901-201412.0p25x0p25.nc';
file_in_SSH=[path_ME4OH_SSH,file_SSH];
file_in_SST=[path_ME4OH_SST,file_SST];

SSH=ncread(file_in_SSH,'eta_t');
lon_SSH=ncread(file_in_SSH,'xt_ocean');
lat_SSH=ncread(file_in_SSH,'yt_ocean');
time_SSH=ncread(file_in_SSH,'Time');
% time_SSH_bnds=ncread(file_in_SSH,'Time_bnds');

% time is in "days since 1979-01-01 00:00:00"
datenum(1950,1,1);
SST=squeeze(ncread(file_in_SST,'temp'));

lon_SST=ncread(file_in_SST,'xt_ocean');
lat_SST=ncread(file_in_SST,'yt_ocean');
time_SST=ncread(file_in_SST,'Time');
depth_SST=ncread(file_in_SST,'st_ocean');


time_SSH=time_SSH+datenum(1950,1,1)-datenum(1979,1,1);
time_SST=time_SST+datenum(1950,1,1)-datenum(1979,1,1);


% make synthetic SSH files in the saem form as AVISO
file_path_in='D:/ME4OH/';
aviso_path=[file_path_in,'Mtpers/matlab_files/'];
if ~exist(aviso_path,'dir')
    mkdir(aviso_path)
end
ntime=length(time_SSH);

lon=lon_SSH;
lat=-89.8750:.25:89.8750;
lat=lat';
good_lat_SSH=ismember(lat,lat_SSH);


for itime=1:ntime
    if length(find(good_lat_SSH))<length(lat_SSH)
        disp('LATITUDE in synthetic SSH is diferent than AVISO!!!')
        break
    end
    sshanom=nan(1440,720);
    file_name_SSH=[path_SSH,'new_ssh',num2str(time_SSH(itime)),'.mat'];
    sshanom(:,good_lat_SSH)=SSH(:,:,itime);
    adt=sshanom;
    save(file_name_SSH,'lon','lat','sshanom','adt')

end


  