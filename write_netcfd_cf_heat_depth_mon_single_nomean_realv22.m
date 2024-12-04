function []=write_netcfd_cf_heat_depth_mon_single_nomean_realv22(ht_estimate,time_1950,lon_tpx,...
    lat_tpx,mean_depth,mean_depth_bnds,start_mean,end_mean,file_name_nc)
    
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
   
    time=time_1950;
    
    latitude=lat_tpx';
    longitude=lon_tpx';
    
    
    nlon=length(longitude);
    nlat=length(latitude);
    ntime=length(time);
    ndepth=length(mean_depth);

    nv=2;
    
    file=file_name_nc;
    if exist(file,'file')
        delete(file)
    end
         
    [globalat]=make_globalatribute_RFROM_realv22();
    
    
    mySchema.Name   = '/';
    mySchema.Attributes=globalat;
    mySchema.Dimensions(1).Name   = 'longitude';
    mySchema.Dimensions(1).Length = nlon;
    mySchema.Dimensions(2).Name   = 'latitude';
    mySchema.Dimensions(2).Length = nlat;
    mySchema.Dimensions(3).Name   = 'time';
    mySchema.Dimensions(3).Length = ntime;
    mySchema.Dimensions(4).Name   = 'mean_depth';
    mySchema.Dimensions(4).Length = ndepth;
    mySchema.Dimensions(5).Name   = 'vertices';
    mySchema.Dimensions(5).Length = nv;
    
    map_dimen(1).Name='longitude';
    map_dimen(2).Name='latitude';
    map_dimen(3).Name='mean_depth';
    map_dimen(4).Name='time';
    map_dimen(1).Length=nlon;
    map_dimen(2).Length=nlat;
    map_dimen(3).Length=ndepth;
    map_dimen(4).Length=ntime;
    mean_depth_bnds_dimen(1).Name='vertices';
    mean_depth_bnds_dimen(1).Length=nv;
    mean_depth_bnds_dimen(2).Name='mean_depth';
    mean_depth_bnds_dimen(2).Length=ndepth;
    

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
    mySchema.Variables(3).Dimensions=map_dimen(4);
    mySchema.Variables(3).Attributes=time_att;
    mySchema.Variables(3).Datatype='single';
    mySchema.Variables(3).FillValue='disable';

      % mean_depth
    mean_depth_att(1).Name='units';
    mean_depth_att(1).Value='meters';
    mean_depth_att(2).Name='Description';
    mean_depth_att(2).Value='The mean depth of vertical integration';
    mean_depth_att(3).Name='bounds';
    mean_depth_att(3).Value='mean_depth_bnds';
    
    mySchema.Variables(4).Name='mean_depth';
    mySchema.Variables(4).Dimensions=map_dimen(3);
    mySchema.Variables(4).Attributes=mean_depth_att;
    mySchema.Variables(4).Datatype='single';
    mySchema.Variables(4).FillValue='disable';


    


    
    % Heatcontent
    ohca_att(1).Name='units';
    ohca_att(1).Value='10^9 J m^-2';
    ohca_att(2).Name='Description';
    ohca_att(2).Value=['real time mapped ocean heat content anomaly (TEOS-10) integrated ',...
        'from upper to lower bounds of mean depth with the seasonal cycle ',...
        'relivite to ',num2str(start_mean),' to ',num2str(end_mean),' mean'];
    
    mySchema.Variables(5).Name='ocean_heat_content_anomaly';
    mySchema.Variables(5).Dimensions=map_dimen;
    mySchema.Variables(5).Attributes=ohca_att;
    mySchema.Variables(5).Datatype='single';
    mySchema.Variables(5).FillValue='disable';
    
     

        % mean depth_bnds
   
    mean_depth_bnds_att(1).Name='Description';
    mean_depth_bnds_att(1).Value='The upper and lower bounds of vertical integration';
    
    mySchema.Variables(6).Name='mean_depth_bnds';
    mySchema.Variables(6).Dimensions=mean_depth_bnds_dimen;
    mySchema.Variables(6).Attributes=mean_depth_bnds_att;
    mySchema.Variables(6).Datatype='single';
    mySchema.Variables(6).FillValue='disable';
    
    % write the file format
    ncwriteschema(file, mySchema);
         
   % convert to single persision

   latitude=single(latitude);
   longitude=single(longitude);
   time=single(time);
   mean_depth=single(mean_depth);
   mean_depth_bnds=single(mean_depth_bnds);
   ht_estimate=single(ht_estimate./1e9);



    % write the varibles
    
    
    ncwrite(file,'latitude',latitude,[1]);
    ncwrite(file,'longitude',longitude,[1]);
    ncwrite(file,'time',time,[1]);
    ncwrite(file,'mean_depth',mean_depth,[1]);
    ncwrite(file,'mean_depth_bnds',mean_depth_bnds,[1,1]);
    ncwrite(file,'ocean_heat_content_anomaly',ht_estimate,[1,1,1,1]);  
    
end
        