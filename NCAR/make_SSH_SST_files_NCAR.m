function []=make_SSH_SST_files_NCAR(OcoSetUp)


path_NCAR_SSH= OcoSetUp.path_NCAR_SSH;
% path_NCAR_SST=OcoSetUp.path_NCAR_SST;
path_NCAR_SSH_out= OcoSetUp.path_NCAR_SSH_out;
path_oisst=OcoSetUp.path_oisst;

file_SSH=OcoSetUp.file_SSH;
% file_SST=OcoSetUp.file_SST;
sdir=dir([path_NCAR_SSH,file_SSH,'*.nc']);
file_in_SSH=[sdir(1).folder,'/',sdir(1).name];
file_in_SST=file_in_SSH;

path_SSH=path_NCAR_SSH_out;
path_SST=path_oisst;
SSH=ncread(file_in_SSH,'ssh');
lon_SSH=ncread(file_in_SSH,'longitude');
lat_SSH=ncread(file_in_SSH,'latitude');
% time_SSH_bnds=ncread(file_in_SSH,'Time_bnds');

% time is in "days since 1979-01-01 00:00:00"

% make synthetic SSH files in the saem form as AVISO


lon=lon_SSH;
lat=-89.8750:.25:89.8750;
lat=lat';
good_lat_SSH=ismember(lat,lat_SSH);

ntime=length(sdir);

for itime=1:ntime

    file_in_SSH=[sdir(itime).folder,'/',sdir(itime).name];
    file_in_SST=file_in_SSH;

    %
    SSH=ncread(file_in_SSH,'ssh');
    lon_SSH=ncread(file_in_SSH,'longitude');
    lat_SSH=ncread(file_in_SSH,'latitude');
    
    % time_SSH_bnds=ncread(file_in_SSH,'Time_bnds');
    
    % time is in "days since 1979-01-01 00:00:00"
    
    
    lon_SST=lon_SSH;
    lat_SST=lat_SSH;
    yr=double(ncread(file_in_SST,'time_yrfrac'));
    % depth_SST=ncread(file_in_SST,'st_ocean');
    yr_file=floor(yr);

    time_SSH=round(365*(yr_file)+((yr-yr_file).*365)+1);
  
%     
    time_SSH=time_SSH-datenum(1950,1,1);
 
    %


    if length(find(good_lat_SSH))<length(lat_SSH)
        disp('LATITUDE in synthetic SSH is diferent than AVISO!!!')
        break
    end
    sshanom=nan(1440,720);
    file_name_SSH=[path_SSH,'new_ssh',num2str(time_SSH),'.mat'];
    sshanom(:,good_lat_SSH)=SSH;
    adt=sshanom;
    lon=double(lon);
    save(file_name_SSH,'lon','lat','sshanom','adt')

   
end




good_lat_SST=ismember(lat,lat_SST);
lon=lon_SST;
% time=time_SST;
for iyear=1993:2018
    iyear_model=iyear+158-1993;
    sdir=dir([path_NCAR_SSH,file_SSH,'0',num2str(iyear_model),'*.nc']);
    if length(find(good_lat_SST))<length(lat_SST)
        disp('LATITUDE in synthetic SST is diferent than AVISO!!!')
        break
    end
    ntime_good_sst=length(sdir);
    sst=nan(1440,720,ntime_good_sst);
    time=nan(ntime_good_sst,1);
    for iweek=1:length(sdir)
        file_in_SST=[sdir(iweek).folder,'/',sdir(iweek).name];
       
        SST=double(ncread(file_in_SST,'ptemp'));
        SST=squeeze(SST(:,:,1));
        % time_SSH_bnds=ncread(file_in_SSH,'Time_bnds');
        
        % time is in "days since 1979-01-01 00:00:00"
        
        
        
        yr=ncread(file_in_SST,'time_yrfrac');
        year_file=double(floor(yr));
        time_SST=round((year_file)*365+((yr-year_file).*365)+1);
       
    
        time_SST=time_SST-datenum(1800,1,1);
        
       
        
        sst(:,:,iweek)=SST;
        time(iweek)=time_SST;
    end

     file_name_SST=[path_SST,'sst.day.mean.',num2str(iyear),'.nc'];
     file=file_name_SST;
     time=single(time);
     lat=single(lat);
     lon=single(lon);

    if exist(file,'file')
        delete(file)
    end
    nlon=length(lon);
    nlat=length(lat);
    ntime=length(time);
    mySchema.Name   = '/';
%     mySchema.Format = "classic";
    mySchema.Dimensions(1).Name   = 'lon';
    mySchema.Dimensions(1).Length = nlon;
    mySchema.Dimensions(2).Name   = 'lat';
    mySchema.Dimensions(2).Length = nlat;
    mySchema.Dimensions(3).Name   = 'time';
    mySchema.Dimensions(3).Length = ntime;
    
    map_dimen(1).Name='lon';
    map_dimen(2).Name='lat';
    map_dimen(3).Name='time';
    map_dimen(1).Length=nlon;
    map_dimen(2).Length=nlat;
    map_dimen(3).Length=ntime;
    

     lon_att(1).Name='units';
    lon_att(1).Value='degrees_east';
    lon_att(2).Name='Description';
    lon_att(2).Value='Longitude (positive east)';
    lon_att(3).Name='standard_name';
    lon_att(3).Value='longitude';
    
    mySchema.Variables(1).Name='lon';
    mySchema.Variables(1).Dimensions=map_dimen(1);
    mySchema.Variables(1).Datatype='single';
    mySchema.Variables(1).FillValue='disable';
    
    mySchema.Variables(2).Name='lat';
    mySchema.Variables(2).Dimensions=map_dimen(2);
    mySchema.Variables(2).Datatype='single';
    mySchema.Variables(2).FillValue='disable';

    mySchema.Variables(3).Name='time';
    mySchema.Variables(3).Dimensions=map_dimen(3);
    mySchema.Variables(3).Datatype='single';
    mySchema.Variables(3).FillValue='disable';

    mySchema.Variables(4).Name='sst';
    mySchema.Variables(4).Dimensions=map_dimen;
    mySchema.Variables(4).Datatype='double';
    mySchema.Variables(4).FillValue='disable';

    ncwriteschema(file, mySchema);
    ncwrite(file,'lon',lon,[1]);
    ncwrite(file,'lat',lat,[1]);
    ncwrite(file,'time',time,[1]);
    ncwrite(file,'sst',sst,[1 1 1]);

    clear mySchema


         
end
  