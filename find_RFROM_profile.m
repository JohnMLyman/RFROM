function []=find_RFROM_profile(lon_data,lat_data,time_data)


lon_data=[170 -10];
lat_data=[0 2];
time_data=[16399 163420];

% make sure that longitude is 
lon_data(lon_data<0)=lon_data(lon_data<0)+360;


path_RFROM='H:\erddap\temp\netcdf';




files=dir([path_RFROM,'\R*.nc']);
Nfile=length(files);

lon=ncread([files(1).folder,'\',files(1).name],'longitude');
lat=ncread([files(1).folder,'\',files(1).name],'latitude');
pres=ncread([files(1).folder,'\',files(1).name],'mean_pressure');

slon=size(lon_data);
slat=size(lat_data);
stime=size(time_data);

if slon(1)>slon(2)
    lon_data=lon_data';
end
if slat(1)>slat(2)S
    lat_data=lat_data';
end
if stime(1)>stime(2)
    time_data=time_data';
end

filenc_first=[files(1).folder,'\',files(1).name];
filenc_last=[files(end).folder,'\',files(end).name];
time_first=ncread(filenc_first,'time');
time_last=ncread(filenc_last,'time');
time_RFROM=[time_first(1):7:time_last(end)]';


nprof=length(time_data);
nlat=length(lat);
nlon=length(lon);
ntime=length(time_RFROM);
LON=repmat(lon,[1 nprof]);
LAT=repmat(lat,[1 nprof]);
TIME=repmat(time_RFROM,[1 nprof]);

LON_DATA=repmat(lon_data,[nlon 1]);
LON_small=(LON_DATA<100 &LON>260);
LON_big=(LON_DATA>260 &LON<100);
LON(LON_small)=LON(LON_small)-360;
LON(LON_big)=LON(LON_big)+360;



LAT_LON_DATA=repmat(lat_data,[nlon 1]);

LAT_DATA=repmat(lat_data,[nlat 1]);
TIME_DATA=repmat(time_data,[ntime 1]);

[~,pos_lon]=min(abs((LON-LON_DATA).*cosd(LAT_LON_DATA)),[],1,'omitnan');
[~,pos_lat]=min(abs((LAT-LAT_DATA)),[],1,'omitnan');
[~,pos_time]=min(abs((TIME-TIME_DATA),[],1,'omitnan');

lat_out=lat(pos_lat);
lon_out=lon(pos_lon);
time_out=time_RFROM(pos_time);

parfor iprof=1:nprof






end

end

function load_sal(file_name,ilon,ilat,time,sal)


sal_total=ncread(filen_name,'ocean_salintiy');

sal=sal_total(ilon,ilat,:,itime);

     
end






