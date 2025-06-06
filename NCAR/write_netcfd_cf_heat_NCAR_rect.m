function []=write_netcfd_cf_heat_NCAR_rect(heat,time,yr_file,lon,...
    lat,depth,dz,file_name_nc)
    
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


% for iyear=year_start_nc:year_end_nc

%     good=floor(time_aviso)==iyear;
  
    latitude=lat;
    longitude=lon;
    
    smap=size(heat);
    nlon=smap(1);
    nlat=smap(2);
    ntime=length(time);
    ndepth=length(depth);

   
    
    file=file_name_nc;
    if exist(file,'file')
        delete(file)
    end
    
    
    globalat(1).Name='Conventions';
    globalat(1).Value='none';
    globalat(2).Name='title';
    globalat(2).Value=' POP 1/10 deg model 5-day NCAR';
    globalat(3).Name='institution';
    globalat(3).Value='NCAR';
    globalat(4).Name='source';
    globalat(4).Value='NCAR';
    globalat(5).Name='references';
    globalat(5).Value='none';
    globalat(6).Name='history';
    globalat(6).Value='none';
    globalat(7).Name='comment';
    globalat(7).Value='none';
% 
%     [globalat]=make_globalatribute_RFROM_real_delayed();
    
    
    mySchema.Name   = '/';
    mySchema.Attributes=globalat;
    mySchema.Dimensions(1).Name   = 'longitude';
    mySchema.Dimensions(1).Length = nlon;
    mySchema.Dimensions(2).Name   = 'latitude';
    mySchema.Dimensions(2).Length = nlat;
    mySchema.Dimensions(3).Name   = 'mean_depth';
    mySchema.Dimensions(3).Length = ndepth;
    mySchema.Dimensions(4).Name   = 'time';
    mySchema.Dimensions(4).Length = ntime;
    
%     mySchema.Dimensions(5).Name   = 'vertices';
%     mySchema.Dimensions(5).Length = nv;
    
    map_dimen(1).Name='longitude';
    map_dimen(2).Name='latitude';
    map_dimen(3).Name='depth';
    map_dimen(4).Name='time';
    map_dimen(1).Length=nlon;
    map_dimen(2).Length=nlat;
    map_dimen(3).Length=ndepth;
     map_dimen(4).Length=ntime;
%     mean_depth_bnds_dimen(1).Name='vertices';
%     mean_depth_bnds_dimen(1).Length=nv;
%     mean_depth_bnds_dimen(2).Name='mean_depth';
%     mean_depth_bnds_dimen(2).Length=ndepth;
    
   
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
    time_att(1).Value='days since 0000-01-01 00:00:00';
    time_att(2).Name='description';
    time_att(2).Value='end day of 5-day average';
    time_att(3).Name='standard_name';
    time_att(3).Value='time';
    time_att(4).Name='calendar';
    time_att(4).Value='noleap';

    mySchema.Variables(3).Name='time';
    mySchema.Variables(3).Dimensions=map_dimen(4);
    mySchema.Variables(3).Attributes=time_att;
    mySchema.Variables(3).Datatype='single';
    mySchema.Variables(3).FillValue='disable';

    % time yrfrac
    time_yrfrac_att(1).Name='units';
    time_yrfrac_att(1).Value='decimal year';
    time_yrfrac_att(2).Name='description';
    time_yrfrac_att(2).Value='end day of 5-day average';
    time_yrfrac_att(3).Name='standard_name';
    time_yrfrac_att(3).Value='time';
    time_yrfrac_att(4).Name='calendar';
    time_yrfrac_att(4).Value='no leap';

    mySchema.Variables(4).Name='time_yrfrac';
    mySchema.Variables(4).Dimensions=map_dimen(4);
    mySchema.Variables(4).Attributes=time_yrfrac_att;
    mySchema.Variables(4).Datatype='single';
    mySchema.Variables(4).FillValue='disable';
      % depth
    depth_att(1).Name='units';
    depth_att(1).Value='meters';
    depth_att(2).Name='Description';
    depth_att(2).Value='depth from surface to midpoint of layer';
    depth_att(3).Name='thickness';
    depth_att(3).Value='dz';
    
    mySchema.Variables(5).Name='depth';
    mySchema.Variables(5).Dimensions=map_dimen(3);
    mySchema.Variables(5).Attributes=depth_att;
    mySchema.Variables(5).Datatype='single';
    mySchema.Variables(5).FillValue='disable';
      % dz
    dz_att(1).Name='units';
    dz_att(1).Value='meters';
    dz_att(2).Name='Description';
    dz_att(2).Value='thickness of layer';
    
    
    mySchema.Variables(6).Name='dz';
    mySchema.Variables(6).Dimensions=map_dimen(3);
    mySchema.Variables(6).Attributes=dz_att;
    mySchema.Variables(6).Datatype='single';
    mySchema.Variables(6).FillValue='disable';


    


    
%     % temp
%     temp_att(1).Name='units';
%     temp_att(1).Value='deg C';
%     temp_att(2).Name='Description';
%     temp_att(2).Value=' Ocean heatcontent';
%     
%     mySchema.Variables(7).Name='heat';
%     mySchema.Variables(7).Dimensions=map_dimen;
%     mySchema.Variables(7).Attributes=tem_att;
%     mySchema.Variables(7).Datatype='single';
%     mySchema.Variables(7).FillValue='disable';

    % Heatcontent
    ohca_att(1).Name='units';
    ohca_att(1).Value='10^9 J m^-2';
    ohca_att(2).Name='Description';
    ohca_att(2).Value=['mapped ocean heat content anomaly (TEOS-10) integrated'];
    
    mySchema.Variables(7).Name='heat';
    mySchema.Variables(7).Dimensions=map_dimen;
    mySchema.Variables(7).Attributes=ohca_att;
    mySchema.Variables(7).Datatype='single';
    mySchema.Variables(7).FillValue='disable';

%      % sal
%     sal_att(1).Name='units';
%     sal_att(1).Value='gram/kilogram';
%     sal_att(2).Name='Description';
%     sal_att(2).Value='Salinity';
%     
%     mySchema.Variables(8).Name='sal';
%     mySchema.Variables(8).Dimensions=map_dimen;
%     mySchema.Variables(8).Attributes=sal_att;
%     mySchema.Variables(8).Datatype='single';
%     mySchema.Variables(8).FillValue='disable';
% 
%     % ssh
%     ssh_att(1).Name='units';
%     ssh_att(1).Value='cm';
%     ssh_att(2).Name='Description';
%     ssh_att(2).Value='Sea Surface Height';
%     
%     mySchema.Variables(9).Name='ssh';
%     mySchema.Variables(9).Dimensions=[map_dimen(1:2),map_dimen(4)];
%     mySchema.Variables(9).Attributes=ssh_att;
%     mySchema.Variables(9).Datatype='single';
%     mySchema.Variables(9).FillValue='disable';

    
     

    % write the file format
    ncwriteschema(file, mySchema);
         
   % convert to single persision

   latitude=single(latitude);
   longitude=single(longitude);
   time=single(time);
   time_yrfrac=single(yr_file);
   depth=single(depth);
   dz=single(dz);
   heat=single(heat./1e9);
  
   



    % write the varibles
    
    
    ncwrite(file,'latitude',latitude,[1]);
    ncwrite(file,'longitude',longitude,[1]);
   
    ncwrite(file,'time',time,[1]);
    ncwrite(file,'time_yrfrac',time_yrfrac,[1]);
    ncwrite(file,'depth',depth,[1]);
    ncwrite(file,'dz',dz,[1]);
    ncwrite(file,'heat',heat,[1,1,1,1]);  
    

    
end
        