
function getalltp_oco_realtime_oco_2022_orca_new_heat(OcoSetUp)

file_path=OcoSetUp.file_path;
file_path_out=OcoSetUp.file_path_out;
path_OHCA_data_out=OcoSetUp.path_OHCA_data_out;
file_name=OcoSetUp.file_name;
file_name_mean=OcoSetUp.file_name_mean;
file_path_hdata=OcoSetUp.file_path_hdata;
max_year=OcoSetUp.max_year;
min_year=OcoSetUp.min_year;
file_WOD_suf=OcoSetUp.file_WOD_suf; 
path_EN4_in=OcoSetUp.path_EN4_in;
path_EN4_out=OcoSetUp.path_EN4_out;
file_path_in=OcoSetUp.file_path_in;
max_year_maps=OcoSetUp.max_year_maps;
min_year_maps=OcoSetUp.min_year_maps;
allheat_extra=OcoSetUp.allheat_extra;
layer_bounds=OcoSetUp.layer_bounds;
bad_heat_var_name=OcoSetUp.bad_heat_var_name;
ind_var_name=OcoSetUp.ind_var_name;
heat_var_name=OcoSetUp.heat_var_name;
lon_grid_mean=OcoSetUp.lon_grid_mean;
lat_grid_mean=OcoSetUp.lat_grid_mean;
mean_heat_var_name=OcoSetUp.mean_heat_var_name;
heat_anom_var_name=OcoSetUp.heat_anom_var_name;
heat_wod_var_name=OcoSetUp.heat_wod_var_name;
h_var_name=OcoSetUp.h_var_name;
mean_heat_oa_name=OcoSetUp.mean_heat_oa_name;
tdiffvar_name=OcoSetUp.tdiffvar_name; 
file_EN3_type=OcoSetUp.file_EN3_type;
file_name_argo=OcoSetUp.file_name_argo;
min_year_mean=OcoSetUp.min_year_mean;
max_year_mean=OcoSetUp.max_year_mean;
file_name_season=OcoSetUp.file_name_season;
max_year_Dssh=OcoSetUp.max_year_Dssh;
max_month_Dssh=OcoSetUp.max_month_Dssh;
max_day_Dshh=OcoSetUp.max_day_Dshh;


% getalltp.m - matlab script to read in ALL merged T/P data from
% netcdf files and save them in equavilent matlab files.
% also calculate 10-year time mean and annual cycle for removal
% 1/3/3

% get directory info and keep only files from 1993- for mean
% and seasonal cycle 

%modified 1-15-2007 jml

% 11-3-05 new2 and different!  removes old mat files and then recomputes the
%   offset over two months than loads the realtime data to fill in the gap
% % % 
% % % %move all the new SSH files out of their subdirecories
% % % file_name_argo='pfloat_sal_greg_oct_2021_QC'
% % % path_OHCA_data_out='C:\data\OHCA\'
% % % path_OHCA_data_in='C:\OHCA\'
% % % %%  YOU MUST DOWNLOAD ARGO AND AVISO DATA AND PUT THEM IN THE CORRECT LOCATIONS!!!!
% % % %%%%  Do I need the next line I dont think so!!!  11/14/2017
% % % 
% % % %%
% % % % YOU MUST CHANE THE FILE_NAME TO THE CURRNET DATE EVERY TIME YOU CHANGE
% % % % LAYERBOUNDS AND/OR FILE_NAME_ARGO SO THAT THE FILES DO NOT GET OVER WRITEN!!!!!
% % % % file_nmae=argo_year_month_day_qc
% % % 
% % % file_name='argo_2020_10_14_QC';
% % % file_name_season=[file_name,'_seasonal']
% % % layer_bounds=[0,40,90,190,290,450,700,950,1450,1950,2000] % layer_bounds must be in assending order
% % % %layer_bounds=[0,100,300,700,900,1800] % layer_bounds must be in assending order
% % % 
% % % 
% % % % grid for first-order large scale mean
% % % lon_grid_mean=[-180:5:180];
% % % lat_grid_mean=[-90:5:90];
% % % 
% % % % range for the large scale mean in Avsio and Argo
% % % %   it is also the time range for which the Aviso and Argo
% % % %   are correlated for means of infilling
% % % 
% % % max_year_mean=2021;
% % % min_year_mean=2005;
% % % 
% % % 
% % % %range for annual maps
% % % 
% % % 
% % % max_year_maps=2021;
% % % min_year_maps=1990;
% % % 
% % % %% NEED TO CHANGE THE PLOT INFO AT THE BOTTOM OF THIS FILE!!!!!
% % % 
% % % 
% % % 
% % % 
% % % %set paths
% % % % file_path='/Volumes/ThunderBay/Data/Globalhc/Floats/Argo/CORIOLIS/'
% % % % file_path_out='/Volumes/ThunderBay/Data/Globalhc/Floats/Argo/CORIOLIS/depth_grid/'
% % % file_path=[path_OHCA_data_out,'OHCA_profiles\'];
% % % file_path_out=[path_OHCA_data_out,'OHCA_grided\'];
% % % file_path_in=path_OHCA_data_in;
% % % % I think you can change file_anme_mean if you want to run a diffent mean but not
% % % % 100% sure doubble check
% % % file_name_mean=file_name;
% % % file_path_hdata=[path_OHCA_data_out,'OHCA_maps\'];
% % % 
% % % file_EN3_type='_cheng_EN4_2014'
% % % path_EN4_in=[path_OHCA_data_in,'EN4\Cheng_2014\'];
% % % path_EN4_out=[path_OHCA_data_out,'EN4\Cheng_2014\'];
% % % allheat_extra='_new'
% % % file_WOD_suf=file_EN3_type;

path_OHCA_data_in=file_path_in;

dnew_real=dir([path_OHCA_data_in,'\Mtpers\realtime_oco\*\*\*.nc']);
for ifile_real=1:length(dnew_real)
    movefile([dnew_real(ifile_real).folder,'\',dnew_real(ifile_real).name],[path_OHCA_data_in,'\Mtpers\realtime_oco'])
end

dnew_dt=dir([path_OHCA_data_in,'\Mtpers\delayed_oco\*\*\*.nc']);
for ifile_dt=1:length(dnew_dt)
    movefile([dnew_dt(ifile_dt).folder,'\',dnew_dt(ifile_dt).name],[path_OHCA_data_in,'\Mtpers\delayed_oco'])
end

cd([path_OHCA_data_in,'\Mtpers\delayed_oco'])
% cd /Volumes/ThunderBay/Data/Globalhc/Mtpers/delayed_oco
d=[sdir('*.nc')];
dy=strjust(strvcat(d(:).name),'right');
year=str2num(dy(:,29-4:32-4));
month=str2num(dy(:,33-4:34-4));
day=str2num(dy(:,35-4:36-4));
dy=datenum(year,month,day)-datenum(1950,1,1);


%THIS SETS THE DATE RANGE OF THE dyelaed mode data with over lap into
%realtime range
tmin=datenum(1993,1,1)-datenum(1950,1,1);
%tmax=datenum(2015,12,31)-datenum(1950,1,1);
% the max date is not 2016,12,31 because no realtime data for before
% 2017,1,7


  tmax=datenum(max_year_Dssh,max_month_Dssh,max_day_Dshh)-datenum(1950,1,1);

%jj=find(dy>=tmin);% only load delyed mode data that it is older that 2 years (so that diferences)
%	can be made

pos_delayed=find(dy>=tmin&dy<=tmax);
dy=dy(pos_delayed);
d=d(pos_delayed);

% initialize variabiles for making variance and mean





%% 11-3-2005 compute the offset over 2 weeks averaged over the whole globe
%% 11-13-2017 changed to start on the end of the delayed mode for over lap 
%% this assumes that the there is delayed mode data 

last_delayed=dy(end);

prefex_realtime_name='./realtime_oco/nrt_global_allsat_phy_l4_';
prefex_realtime_dir='./realtime_oco/';

prefex_delayed_name='./delayed_oco/dt_global_allsat_phy_l4_';
prefex_delayed_dir='./delayed_oco/';

number_overlap=7;
start_time=last_delayed-7*number_overlap;


%

lon=ncread([d(1).folder,'/',d(1).name],'longitude');
% read_netcdf_sla_adt_tuna.m forces adt and sla to go from 0 to 360.  this
% is because of inconsitantcies in aviso ssh product over time.  here i
% force lon to go from 0 to 360 also

lon=[lon(lon>=0);lon(lon<0)+360];

lat=ncread([d(1).folder,'/',d(1).name],'latitude');
arw=areavec(lon,lat);
nlat=length(lat);
nlon=length(lon);
cd([path_OHCA_data_in,'/Mtpers'])
d_realtime=sdir([prefex_realtime_dir,'*.nc']);
dy_realtime=strjust(strvcat(d_realtime(:).name),'right');
year_realtime=str2num(dy_realtime(:,26:29));
month_realtime=str2num(dy_realtime(:,30:31));
day_realtime=str2num(dy_realtime(:,32:33));
dy_realtime=datenum(year_realtime,month_realtime,day_realtime)-datenum(1950,1,1);

offset_sla=nan(nlon,nlat,7*number_overlap+1);
offset_adt=nan(nlon,nlat,7*number_overlap+1);
for ii= start_time:last_delayed
    ioff=ii-start_time+1;
    % load the realtime data and compute its mean

	
   
    
       
    % load the delayed time data and compute it's mean
    date_delayed=datevec(ii+datenum(1950,1,1));
    delay_day=num2str(date_delayed(3));
    delay_month=num2str(date_delayed(2));
    delay_year=num2str(date_delayed(1));
    if date_delayed(3) < 10
	delay_day=['0',delay_day];
    end
    if date_delayed(2) < 10
	delay_month=['0',delay_month];
    end
	
    
    %%%%%%
    
     djunk=[sdir([prefex_realtime_name,delay_year,delay_month,delay_day,'*.nc'])];
% %      [sla]=read_netcdf_getall_getprofiles([prefex_realtime_dir,djunk(1).name],'sla');
          [sla_real,adt_real]=read_netcdf_sla_adt_tuna([prefex_realtime_dir,djunk(1).name]);

    %nc_getall([prefex_realtime_dir,djunk(1).name])
    [prefex_realtime_dir,djunk(1).name]
   

    clear sla
    
   
   
   %%%%%
    
    djunk=[sdir([prefex_delayed_name,delay_year,delay_month,delay_day,'*.nc'])];
% %     [sla]=read_netcdf_getall_getprofiles([prefex_delayed_dir,djunk(1).name],'sla');
    [sla,adt]=read_netcdf_sla_adt_tuna([prefex_delayed_dir,djunk(1).name]);
    %nc_getall([prefex_delayed_dir,djunk(1).name])
    [prefex_delayed_dir,djunk(1).name]
    
    offset_sla(:,:,ioff)=(sla-sla_real).*arw;
    offset_adt(:,:,ioff)=(adt-adt_real).*arw;

    

end

% take out spikes at high latitudes
offset_sla(:,abs(lat)>66,:)=nan;
offset_sla=nanmean(offset_sla,3);
total_area_sla=nansum(arw(isfinite(offset_sla)));
offset_sla=nansum(offset_sla(:))./total_area_sla;

offset_adt(:,abs(lat)>66,:)=nan;
offset_adt=nanmean(offset_adt,3);
total_area_adt=nansum(arw(isfinite(offset_adt)));
offset_adt=nansum(offset_adt(:))./total_area_adt;
% 11-3-2005 now change d so that it contains the realtime data


use_real=(dy_realtime > last_delayed);

    % this part takes out real time estimates that were made in between the
    % delayed time time interval

    
%good_real=find((position_factor >=1) & (mod(position_factor,7)==0));


delay_names=d;
real_names=d_realtime(use_real);

dy=[dy',dy_realtime(use_real)']';
d=[delay_names',real_names']';

clear ii sshanom

%% this section rewrites the data as a matlab file delayed mode for the first half and then realtime



tic
parfor i=1:length(d)
    
    sla=[];
    adt=[];
    
        if d(i).name(1)=='n'  
           %  nc_getall(['realtime_oco/',d(i).name]);
% % %              [sla]=read_netcdf_getall_getprofiles(['realtime_oco/',d(i).name],'sla');
             [sla,adt]=read_netcdf_sla_adt_tuna(['realtime_oco/',d(i).name]);
            
             %nc_getall([prefex_realtime_dir,djunk(1).name])
             
        else
         date_delayed=datevec(dy(i)+datenum(1950,1,1));
         delay_day=num2str(date_delayed(3));
        delay_month=num2str(date_delayed(2));
        delay_year=num2str(date_delayed(1));
        if date_delayed(3) < 10
            delay_day=['0',delay_day];
        end
        
        if date_delayed(2) < 10
            delay_month=['0',delay_month];
        end
	
    
        djunk=[sdir([prefex_delayed_name,delay_year,delay_month,delay_day,'*.nc'])];
        %nc_getall([prefex_delayed_dir,djunk(1).name]);
% %         [sla]=read_netcdf_getall_getprofiles([prefex_delayed_dir,djunk(1).name],'sla');
        [sla,adt]=read_netcdf_sla_adt_tuna([prefex_delayed_dir,djunk(1).name]);

        %nc_getall([prefex_realtime_dir,djunk(1).name])
        
        
        end
        
    sshanom=(sla);
   
    
    
    
    if d(i).name(1)=='d'
        filename=['matlab_files/new_ssh',num2str(dy(i))];
        parsave_ssh(filename,sshanom,lat,lon,adt)
%         save(['matlab_files/new_ssh',num2str(dy(i))],'sshanom','lat','lon','adt');
    else
        sshanom=sshanom+offset_sla;
        adt=adt+offset_adt;
        filename=['matlab_files/new_ssh',num2str(dy(i))];
        parsave_ssh_real(filename,sshanom,lat,lon,adt,offset_sla,offset_adt)

%         save(['matlab_files/new_ssh',num2str(dy(i))],'sshanom','lat','lon','offset_sla','adt','offset_adt');
    end
  
    
 
  
  
  
  
    
end
toc./60
  
%% Compute the mean and seasonal cycle

end


function parsave_ssh(filename,sshanom,lat,lon,adt)
 save(filename,'sshanom','lat','lon','adt');
end
function parsave_ssh_real(filename,sshanom,lat,lon,adt,offset_sla,offset_adt)
 save(filename,'sshanom','lat','lon','offset_sla','adt','offset_adt');
end
