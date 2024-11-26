








function []=write_netcfd_cf_OHCA_OHU_curves(time_aviso,ohca,ohca_cycle,...
    ohu_cycle,ohu_cycle_qu,ohu_annual,file_name_nc)
    
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
   
   
    
    year_aviso=floor(time_aviso);
   aviso_day=1+(time_aviso-year_aviso).*yeardays(year_aviso);
   sday=round(aviso_day+datenum(year_aviso,1,1)-1);

   days_since_1950=sday-datenum(1950,1,1);%NEED TO CHECK THIS
 

    time=time_1950;
    
    
    ntime=length(time);
    

    
    file=file_name_nc;
    if exist(file,'file')
        delete(file)
    end
         
    [globalat]=make_globalatribute_RFROM_curves();
    
    
    mySchema.Name   = '/';
    mySchema.Attributes=globalat;
   
    mySchema.Dimensions(1).Name   = 'time';
    mySchema.Dimensions(1).Length = ntime;
    
    
    map_dimen(1).Name='time';
   
    map_dimen(1).Length=ntime;
    
    
    

   
    % time
    time_att(1).Name='units';
    time_att(1).Value='days since 1950-1-1 0:0:0';
    time_att(2).Name='Description';
    time_att(2).Value='Time in days since January 1st 1950';
    time_att(3).Name='standard_name';
    time_att(3).Value='time';
    
    mySchema.Variables(1).Name='time';
    mySchema.Variables(1).Dimensions=map_dimen(4);
    mySchema.Variables(1).Attributes=time_att;
    mySchema.Variables(1).Datatype='single';
    mySchema.Variables(1).FillValue='disable';


    


    
    % 0-2000 m OHCA no cycle
    ohca_att(1).Name='units';
    ohca_att(1).Value='Zj';
    ohca_att(2).Name='Description';
    ohca_att(2).Value='globally integrated 0-2000 ocean heat content anomaly error (TEOS-10), with seasonal cycle';
    
    mySchema.Variables(2).Name='ocean_heat_content_anomaly_cycle';
    mySchema.Variables(2).Dimensions=map_dimen;
    mySchema.Variables(2).Attributes=ohca_att;
    mySchema.Variables(2).Datatype='single';
    mySchema.Variables(2).FillValue='disable';
    
    
    % 0-2000 m OHCA 
    ohca_att(1).Name='units';
    ohca_att(1).Value='Zj';
    ohca_att(2).Name='Description';
    ohca_att(2).Value='globally integrated 0-2000 ocean heat content anomaly error (TEOS-10), without seasonal cycle';
    
    mySchema.Variables(3).Name='ocean_heat_content_anomaly';
    mySchema.Variables(3).Dimensions=map_dimen;
    mySchema.Variables(3).Attributes=ohca_att;
    mySchema.Variables(3).Datatype='single';
    mySchema.Variables(3).FillValue='disable';

    % 0-2000 m OHU 
    ohca_att(1).Name='units';
    ohca_att(1).Value='watt m^-2';
    ohca_att(2).Name='Description';
    ohca_att(2).Value='globally integrated 0-2000 ocean heat uptake (TEOS-10), with seasonal cycle';
    
    mySchema.Variables(4).Name='ocean_heat_uptake_cycle';
    mySchema.Variables(4).Dimensions=map_dimen;
    mySchema.Variables(4).Attributes=ohca_att;
    mySchema.Variables(4).Datatype='single';
    mySchema.Variables(4).FillValue='disable';
    
    % 0-2000 m OHU quarterly
    ohca_att(1).Name='units';
    ohca_att(1).Value='watt m^-2';
    ohca_att(2).Name='Description';
    ohca_att(2).Value='globally integrated 0-2000 ocean heat uptake (TEOS-10), quarterly smoothed with seasonal cycle';
    
    mySchema.Variables(5).Name='ocean_heat_uptake_cycle_quarterly';
    mySchema.Variables(5).Dimensions=map_dimen;
    mySchema.Variables(5).Attributes=ohca_att;
    mySchema.Variables(5).Datatype='single';
    mySchema.Variables(5).FillValue='disable';

    % 0-2000 m OHU annual
    ohca_att(1).Name='units';
    ohca_att(1).Value='watt m^-2';
    ohca_att(2).Name='Description';
    ohca_att(2).Value='globally integrated 0-2000 ocean heat uptake (TEOS-10), annually smoothed without seasonal cycle';
    
    mySchema.Variables(6).Name='ocean_heat_uptake_annual';
    mySchema.Variables(6).Dimensions=map_dimen;
    mySchema.Variables(6).Attributes=ohca_att;
    mySchema.Variables(6).Datatype='single';
    mySchema.Variables(6).FillValue='disable';

      
    % write the file format
    ncwriteschema(file, mySchema);
         
   % convert to single persision

  
   time=single(time);
   
   ohca=single(ohca);
   ohca_cycle=single(ohca_cycle);
   ohu_cycle=single(ohu_cycle);
   ohu_cycle_qu=single(ohu_cycle_qu);
   ohu_annual=single(ohu_annual);


    % write the varibles
    
    
    
    ncwrite(file,'time',time,[1]);
    
    ncwrite(file,'ocean_heat_content_anomaly_cycle',ohca,[1]);  
    ncwrite(file,'ocean_heat_content_anomaly',ohca_cycle,[1]);  
    ncwrite(file,'ocean_heat_uptake_cycle',ohu_cycle,[1]);  
    ncwrite(file,'ocean_heat_uptake_cycle_quarterly',ohu_cycle_qu,[1]);
    ncwrite(file,'ocean_heat_uptake_annual',ohu_annual,[1]);


    
end        