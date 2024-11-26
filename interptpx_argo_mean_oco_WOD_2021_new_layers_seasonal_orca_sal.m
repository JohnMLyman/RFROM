function interptpx_argo_mean_oco_WOD_2021_new_layers_seasonal_orca_sal(OcoSetUp)

%%
file_path_prof=OcoSetUp.file_path_prof;
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
allsal_extra=OcoSetUp.allsal_extra;
layer_bounds=OcoSetUp.layer_bounds;
bad_sal_var_name=OcoSetUp.bad_sal_var_name;
ind_var_name=OcoSetUp.ind_var_name;
sal_var_name=OcoSetUp.sal_var_name;
lon_grid_mean=OcoSetUp.lon_grid_mean;
lat_grid_mean=OcoSetUp.lat_grid_mean;
mean_sal_var_name=OcoSetUp.mean_sal_var_name;
sal_anom_var_name=OcoSetUp.sal_anom_var_name;
sal_wod_var_name=OcoSetUp.sal_wod_var_name;
s_var_name=OcoSetUp.s_var_name;
mean_sal_oa_name=OcoSetUp.mean_sal_oa_name;
tdiffvar_name=OcoSetUp.tdiffvar_name; 
file_EN3_type=OcoSetUp.file_EN3_type;
file_name_argo=OcoSetUp.file_name_argo;
min_year_mean=OcoSetUp.min_year_mean;
max_year_mean=OcoSetUp.max_year_mean;
file_name_season=OcoSetUp.file_name_season;


temp_anom_var_name=OcoSetUp.temp_anom_var_name;
temp_wod_var_name=OcoSetUp.temp_wod_var_name;
t_var_name=OcoSetUp.t_var_name;
temp_var_name=OcoSetUp.temp_var_name;
%%

eval(['load ',file_path_out,'allsal_new_layers_argo_WOD_new_',file_name_season,...
    t_var_name,s_var_name,...
    'cds dt argo_delayed_mode argo_float_id mdep wod_oclnum'])%

   

date=dt;
coords=cds;
time=date*0;


aviso_path=[file_path_in,'/Mtpers/matlab_files/'];
d=dir([aviso_path, 'new_ssh*.mat']);
n_aviso_files=length(d);
% need to fix any coordinates that stray outside the range -180:180
ii=find(coords(:,1)>180);coords(ii,1)=coords(ii,1)-360;
ii=find(coords(:,1)<-180);coords(ii,1)=coords(ii,1)+360;

time_aviso_argo=datenum(dt(:,1),dt(:,2),dt(:,3))-datenum(1950,1,1);
lon_argo=coords(:,1);
lat_argo=coords(:,2);
lon_180_argo=lon_argo;
lon_argo(lon_argo<0)=lon_argo(lon_argo<0)+360;
nprof=length(lon_argo);

good_180=lon_180_argo>-90 & lon_180_argo<90;


% compute,save and remove the mean (same as Argo)
load([aviso_path,d(1).name],'lat','lon')
pos_aviso_180=lon>180;
lon_180=[lon(pos_aviso_180)-360 ; lon(~pos_aviso_180)];

[LON,LAT]=ndgrid(lon,lat);
[LON_180,~]=ndgrid(lon_180,lat);
  
%JML 6/27/2023 to include black sea and caspin sea which dont have means
 [global_basins_aviso]=find_basin_paige(LON,LAT);


topex=nans(nprof,2);

tic
unq_aviso_day=unique(time_aviso_argo);
% don't try and find ssh before AVISO
unq_aviso_day=unq_aviso_day(unq_aviso_day>=15000);
for iaviso_cycle=unq_aviso_day'
    ssh_file=[aviso_path,'new_ssh',num2str(iaviso_cycle),'.mat'];
    if exist(ssh_file,'file')
      load(ssh_file)
% only use delyed mode aviso for the mean.  realitime adt is spikey
      if ~exist('offset_adt','var') 
%JML 6/27/2023 to include black sea and caspin sea which dont have means 
          adt(global_basins_aviso(10).pos|global_basins_aviso(6).pos)=sshanom(global_basins_aviso(10).pos|global_basins_aviso(6).pos);
          good_time=time_aviso_argo ==iaviso_cycle;
          good_all=good_time & ~good_180;
          good_all_180=good_time & good_180;
    
          adt_180=[adt(pos_aviso_180,:);adt(~pos_aviso_180,:)];
          F=griddedInterpolant(LON,LAT,adt);
          F_180=griddedInterpolant(LON_180,LAT,adt_180);
          jlon=lon_argo(good_all);
          jlat=lat_argo(good_all);
          jlon_180=lon_180_argo(good_all_180);
          jlat_180=lat_argo(good_all_180);
        
          topex(good_all,1)=F(jlon,jlat);
          topex(good_all_180,1)=F_180(jlon_180,jlat_180);
      end
      clear offset_sla offset_adt
    end


  

  
  
end



topex(:,2)=topex(:,1);



cds=coords;
dt=date;
tm=time(:,1);

['sdata_new_layers_',file_WOD_suf,'_',file_name_season]
 eval(['save ',file_path_out,'allsal_new_layers_argo_WOD_new_',file_name_season,...
    t_var_name,s_var_name,...
    'cds dt argo_delayed_mode argo_float_id mdep wod_oclnum topex'])%

   toc./60


