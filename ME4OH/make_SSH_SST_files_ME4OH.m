function []=make_SSH_SST_files_ME4OH(OcoSetUp)


path_ME4OH_SSH= OcoSetUp.path_ME4OH_SSH;
path_ME4OH_SST=OcoSetUp.path_ME4OH_SST;
path_ME4OH_SSH_out= OcoSetUp.path_ME4OH_SSH_out;
path_oisst=OcoSetUp.path_oisst;

file_SSH=OcoSetUp.file_SSH;
file_SST=OcoSetUp.file_SST;

file_in_SSH=[path_ME4OH_SSH,file_SSH];
file_in_SST=[path_ME4OH_SST,file_SST];

path_SSH=path_ME4OH_SSH_out;
path_SST=path_oisst;
SSH=ncread(file_in_SSH,'eta_t');
lon_SSH=ncread(file_in_SSH,'xt_ocean');
lat_SSH=ncread(file_in_SSH,'yt_ocean');
time_SSH=ceil(ncread(file_in_SSH,'Time'));
% time_SSH_bnds=ncread(file_in_SSH,'Time_bnds');

% time is in "days since 1979-01-01 00:00:00"

SST=squeeze(ncread(file_in_SST,'temp'));

lon_SST=ncread(file_in_SST,'xt_ocean');
lat_SST=ncread(file_in_SST,'yt_ocean');
time_SST=ceil(ncread(file_in_SST,'Time'));
% depth_SST=ncread(file_in_SST,'st_ocean');


time_SSH=time_SSH-datenum(1950,1,1)+datenum(1979,1,1);
time_SST=time_SST-datenum(1800,1,1)+datenum(1979,1,1);


% make synthetic SSH files in the saem form as AVISO


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



[year_SST,~,~]=datevec(time_SST+datenum(1800,1,1));
good_lat_SST=ismember(lat,lat_SST);
lon=lon_SST;
% time=time_SST;
for iyear=min(year_SST):max(year_SST)
    if length(find(good_lat_SST))<length(lat_SST)
        disp('LATITUDE in synthetic SST is diferent than AVISO!!!')
        break
    end
    good_time_SST=year_SST==iyear;
    ntime_good_sst=length(find(good_time_SST));
    sst=nan(1440,720,ntime_good_sst);
    file_name_SST=[path_SST,'sst.day.mean.',num2str(iyear),'.nc'];
    
    sst(:,good_lat_SST,:)=SST(:,:,good_time_SST);
    time=time_SST(good_time_SST);

 
     file=file_name_SST;
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
  