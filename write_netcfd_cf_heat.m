function []=write_netcfd_cf_heat(ht_estimate,lon_tpx,lat_tpx,time_aviso,path_nc,...
    ohca_description,file_nc_prefix,year_start_nc,year_end_nc)
% time [days since 1950-01-01 00:00:00] CMEMS time I should convert all
% % times to this
% 
% path_tree='C:\Users\jlyma\OneDrive - University of Hawaii\data\OHCA\OHCA_trees\';
% %NEED TO CONVERT TIME TO DAYS SINCE ??? FROM AVISO.  ALSO NEED TO MASK HEAT
%CONTENT TO REFLECT THE DEPTH RANGE

% path_nc='C:\Users\jlyma\OneDrive - University of Hawaii\data\OHCA\OHCA_trees\netcdf\';



% sday=days_since_1950+datenum(1950,1,1);
% datevec_sday=datevec(sday);
% aviso_day=sday-datenum(datevec_sday(:,1),1,1)+1;
% syr=datevec_sday(:,1)+(aviso_day-1)./yeardays(datevec_sday(:,1));

year_aviso=floor(time_aviso);
aviso_day=1+(time_aviso-year_aviso).*yeardays(year_aviso);
sday=round(aviso_day+datenum(year_aviso,1,1)-1);

days_since_1950=sday-datenum(1950,1,1);%NEED TO CHECK THIS

for iyear=year_start_nc:year_end_nc
% for iyear=2019

    file_nc=[file_nc_prefix,num2str(iyear),'.nc'];
    good=floor(time_aviso)==iyear;
%     good=[100 200 300];
    time=days_since_1950(good);
    ht_estimate_out=ht_estimate(:,:,good);
    latitude=lat_tpx';
    longitude=lon_tpx';
    
    nlon=length(longitude);
    nlat=length(latitude);
    ntime=length(time);
    
    file=[path_nc,file_nc];
    if exist(file,'file')
        delete(file)
    
    end
         
    [globalat]=make_globalatribute();
    
    
    mySchema.Name   = '/';
    mySchema.Attributes=globalat;
    mySchema.Dimensions(1).Name   = 'longitude';
    mySchema.Dimensions(1).Length = nlon;
    mySchema.Dimensions(2).Name   = 'latitude';
    mySchema.Dimensions(2).Length = nlat;
    mySchema.Dimensions(3).Name   = 'time';
    mySchema.Dimensions(3).Length = ntime;
    
    map_dimen(1).Name='longitude';
    map_dimen(2).Name='latitude';
    map_dimen(3).Name='time';
    map_dimen(1).Length=nlon;
    map_dimen(2).Length=nlat;
    map_dimen(3).Length=ntime;
    
    % Longitude
    lon_att(1).Name='units';
    lon_att(1).Value='degrees_east';
    lon_att(2).Name='Description';
    lon_att(2).Value='Longitude (positive east)';
    
    mySchema.Variables(1).Name='longitude';
    mySchema.Variables(1).Dimensions=map_dimen(1);
    mySchema.Variables(1).Attributes=lon_att;
    mySchema.Variables(1).Datatype='double';
    mySchema.Variables(1).FillValue='disable';
    
    % Latitude
    lat_att(1).Name='units';
    lat_att(1).Value='degrees_north';
    lat_att(2).Name='Description';
    lat_att(2).Value='Latitude (positive north)';
    
    mySchema.Variables(2).Name='latitude';
    mySchema.Variables(2).Dimensions=map_dimen(2);
    mySchema.Variables(2).Attributes=lat_att;
    mySchema.Variables(2).Datatype='double';
    mySchema.Variables(2).FillValue='disable';
    % time
    time_att(1).Name='units';
    time_att(1).Value='days since 1950-1-1 0:0:0';
    time_att(2).Name='Description';
    time_att(2).Value='Time in days since January 1st 1950';
    
    mySchema.Variables(3).Name='time';
    mySchema.Variables(3).Dimensions=map_dimen(3);
    mySchema.Variables(3).Attributes=time_att;
    mySchema.Variables(3).Datatype='double';
    mySchema.Variables(3).FillValue='disable';
    
    
    % Heatcontent
    ohca_att(1).Name='units';
    ohca_att(1).Value='J/m^2';
    ohca_att(2).Name='Description';
    ohca_att(2).Value=ohca_description;
    
    mySchema.Variables(4).Name='ocean_heat_content_anomaly';
    mySchema.Variables(4).Dimensions=map_dimen;
    mySchema.Variables(4).Attributes=ohca_att;
    mySchema.Variables(4).Datatype='double';
    mySchema.Variables(4).FillValue='disable';
    
    
    
    % write the file format
    ncwriteschema(file, mySchema);
         
    % write the varibles
    
    ncwrite(file,'latitude',latitude,[1]);
    ncwrite(file,'longitude',longitude,[1]);
    ncwrite(file,'time',time,[1]);
    
    ncwrite(file,'ocean_heat_content_anomaly',ht_estimate_out,[1,1,1]);  
    
end
        