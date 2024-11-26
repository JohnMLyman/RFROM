function []=write_netcfd_cf_mld_pressure_mon_single(mld_estimate,...
                       mld_temp_estimate,mld_sal_estimate,mld_den_estimate,...
                       time_1950,lon_tpx,...
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
   
    time=time_1950;
    
    latitude=lat_tpx';
    longitude=lon_tpx';
    
    
    nlon=length(longitude);
    nlat=length(latitude);
    ntime=length(time);
  
    
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
    
    mySchema.Variables(1).Name='longitude';
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
    
    mySchema.Variables(2).Name='latitude';
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
    
    mySchema.Variables(3).Name='time';
    mySchema.Variables(3).Dimensions=map_dimen(3);
    mySchema.Variables(3).Attributes=time_att;
    mySchema.Variables(3).Datatype='single';
    mySchema.Variables(3).FillValue='disable';

   
     % MLD 
    mld_att(1).Name='units';
    mld_att(1).Value='meters';
    mld_att(2).Name='Description';
    mld_att(2).Value=['Mixed layer depth'];
    
    mySchema.Variables(4).Name='mld';
    mySchema.Variables(4).Dimensions=map_dimen;
    mySchema.Variables(4).Attributes=mld_att;
    mySchema.Variables(4).Datatype='single';
    mySchema.Variables(4).FillValue='disable';


    
    % MLD Temperature
    mld_temp_att(1).Name='units';
    mld_temp_att(1).Value='degree_Celsius';
    mld_temp_att(2).Name='Description';
    mld_temp_att(2).Value=['Mixed layer depth ocean conservative temperature (TEOS-10)'];
    
    mySchema.Variables(5).Name='mld_temperature';
    mySchema.Variables(5).Dimensions=map_dimen;
    mySchema.Variables(5).Attributes=mld_temp_att;
    mySchema.Variables(5).Datatype='single';
    mySchema.Variables(5).FillValue='disable';
    
   
    % MLD Salinity
    mld_sal_att(1).Name='units';
    mld_sal_att(1).Value='grams_per_kilogram';
    mld_sal_att(2).Name='Description';
    mld_sal_att(2).Value=['Mixed layer depth ocean absoulte salinity (TEOS-10)'];
    
    mySchema.Variables(6).Name='mld_salinity';
    mySchema.Variables(6).Dimensions=map_dimen;
    mySchema.Variables(6).Attributes=mld_sal_att;
    mySchema.Variables(6).Datatype='single';
    mySchema.Variables(6).FillValue='disable';

     % MLD Density
    mld_den_att(1).Name='units';
    mld_den_att(1).Value='kilogram_per_meter';
    mld_den_att(2).Name='Description';
    mld_den_att(2).Value=['Mixed layer depth ocean density (TEOS-10) with a reference pressure of 0 '];
    
    mySchema.Variables(7).Name='mld_density';
    mySchema.Variables(7).Dimensions=map_dimen;
    mySchema.Variables(7).Attributes=mld_den_att;
    mySchema.Variables(7).Datatype='single';
    mySchema.Variables(7).FillValue='disable';

    
    % write the file format
    ncwriteschema(file, mySchema);
         
   % convert to single persision

   latitude=single(latitude);
   longitude=single(longitude);
   time=single(time);
   
   mld_estimate=single(mld_estimate);
   mld_temp_estimate=single(mld_temp_estimate);
   mld_sal_estimate=single(mld_sal_estimate);
   mld_den_estimate=single(mld_den_estimate);



    % write the varibles
    
    
    ncwrite(file,'latitude',latitude,[1]);
    ncwrite(file,'longitude',longitude,[1]);
    ncwrite(file,'time',time,[1]);
    ncwrite(file,'mld',mld_estimate,[1,1,1]);
    ncwrite(file,'mld_temperature',mld_temp_estimate,[1,1,1]); 
    ncwrite(file,'mld_salinity',mld_sal_estimate,[1,1,1]); 
    ncwrite(file,'mld_density',mld_den_estimate,[1,1,1]);  
    
end
        