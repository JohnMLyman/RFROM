function []=write_netcfd_cf_test(ht_estimate_year,time_aviso,lon_tpx,...
                   lat_tpx,file_name_nc)
    
% time [days since 1950-01-01 00:00:00] CMEMS time I should convert all
% % times to this
% 
% path_tree='C:\Users\jlyma\OneDrive - University of Hawaii\data\OHCA\OHCA_trees\';
% %NEED TO CONVERT TIME TO DAYS SINCE ??? FROM AVISO.  ALSO NEED TO MASK HEAT
%CONTENT TO REFLECT THE pressure RANGE

% path_nc='C:\Users\jlyma\OneDrive - University of Hawaii\data\OHCA\OHCA_trees\netcdf\';



% sday=days_since_1950+datenum(1950,1,1);
% datevec_sday=datevec(sday);
% aviso_day=sday-datenum(datevec_sday(:,1),1,1)+1;
% syr=datevec_sday(:,1)+(aviso_day-1)./yeardays(datevec_sday(:,1));


% for iyear=year_start_nc:year_end_nc

%     good=floor(time_aviso)==iyear;
   
    
    nlon=length(lon_tpx);
    nlat=length(lat_tpx);
    ntime=length(time_aviso);
   

  
    file=file_name_nc;
    if exist(file,'file')
        delete(file)
    end
         
    [globalat]=make_globalatribute_RFROM();
    
    
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
    lon_att(3).Name='standard_name';
    lon_att(3).Value='longitude';
    
    mySchema.Variables(1).Name='lon_tpx';
    mySchema.Variables(1).Dimensions=map_dimen(1);
    mySchema.Variables(1).Attributes=lon_att;
    mySchema.Variables(1).Datatype='single';
    mySchema.Variables(1).FillValue='disable';
    
    % Latitude
    lat_att(1).Name='units';
    lat_att(1).Value='degrees_north';
    lat_att(2).Name='Description';
    lat_att(2).Value='Latitude (positive north)';
    lat_att(3).Name='standard_name';
    lat_att(3).Value='latitude';
    
    mySchema.Variables(2).Name='lat_tpx';
    mySchema.Variables(2).Dimensions=map_dimen(2);
    mySchema.Variables(2).Attributes=lat_att;
    mySchema.Variables(2).Datatype='single';
    mySchema.Variables(2).FillValue='disable';
    % time
    time_att(1).Name='units';
    time_att(1).Value='days since 1950-1-1 0:0:0';
    time_att(2).Name='Description';
    time_att(2).Value='Time in days since January 1st 1950';
    time_att(3).Name='standard_name';
    time_att(3).Value='time';
    
    mySchema.Variables(3).Name='time_aviso';
    mySchema.Variables(3).Dimensions=map_dimen(3);
    mySchema.Variables(3).Attributes=time_att;
    mySchema.Variables(3).Datatype='single';
    mySchema.Variables(3).FillValue='disable';

    

    


    
    % Temperature
    ohca_att(1).Name='units';
    ohca_att(1).Value='degree_Celsius';
    ohca_att(2).Name='Description';
    ohca_att(2).Value=['mapped ocean conservative temperature (TEOS-10) averaged ',...
        'from upper to lower bounds of mean pressure with the seasonal cycle '];
    
    mySchema.Variables(4).Name='ht_estimate_year';
    mySchema.Variables(4).Dimensions=map_dimen;
    mySchema.Variables(4).Attributes=ohca_att;
    mySchema.Variables(4).Datatype='single';
    mySchema.Variables(4).FillValue='disable';
    
     

      
    
    % write the file format
    ncwriteschema(file, mySchema);
         
   % convert to single persision

   latitude=single(lat_tpx);
   longitude=single(lon_tpx);
   time=single(time_aviso);
  
   temp_estimate=single(ht_estimate_year);



    % write the varibles
    
    
    ncwrite(file,'lat_tpx',lat_tpx,[1]);
    ncwrite(file,'lon_tpx',longitude,[1]);
    ncwrite(file,'time_aviso',time_aviso,[1]);
    
    ncwrite(file,'ht_estimate_year',temp_estimate,[1,1,1]);  
    
end
        