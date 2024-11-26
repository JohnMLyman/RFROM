function [lon_out,lat_out,time_out,pres,sal]=find_RFROM_sal_profile__gen(lon_data,lat_data,time_data,path_RFROM)


% lon_data=[170 -10];
% lat_data=[0 2];
% time_data=[21936 21946];

% make sure that longitude is 
lon_data(lon_data<0)=lon_data(lon_data<0)+360;

% path_RFROM='H:\erddap\temp\netcdf';
% path_RFROM='H:\erddap\sal_3_nosst\netcdf_stable\yearly_mean_t_nossh';
% path_RFROM='H:\erddap\sal_3_n_mean_nosst_half\netcdf_stable';



files=dir([path_RFROM,'\RFROM_SAL_*.nc']);
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
if slat(1)>slat(2)
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
npres=length(pres);
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
[~,pos_time]=min(abs((TIME-TIME_DATA)),[],1,'omitnan');

lat_out=lat(pos_lat);
lon_out=lon(pos_lon);
time_out=time_RFROM(pos_time);
sal=nans(nprof,npres);

day_1950=datenum(1950,1,1);

for iprof=1:nprof

        [iyear,imonth,~]=datevec(double(time_out(iprof))+day_1950);

         if imonth>=10
              jfile_name_nc= [path_RFROM,'\RFROM_SAL_',num2str(iyear),'_',num2str(imonth),'.nc'];
           else
              jfile_name_nc= [path_RFROM,'\RFROM_SAL_',num2str(iyear),'_0',num2str(imonth),'.nc'];
         end
        
       ilon=pos_lon(iprof);
       ilat=pos_lat(iprof);
       
       

       sal(iprof,:)=load_sal(jfile_name_nc,ilon,ilat,time_out(iprof));
       





end

end

function [sal]=load_sal(file_name,ilon,ilat,jtime)


    sal_total=ncread(file_name,'ocean_salinity');
    time=ncread(file_name,'time');
    pos_time=find(time==jtime);
    sal=squeeze(sal_total(ilon,ilat,:,pos_time));

     
end






