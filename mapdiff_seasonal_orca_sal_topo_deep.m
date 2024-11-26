function mapdiff_seasonal_orca_sal_topo_deep(OcoSetUp)

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
file_name_season_out_deep=OcoSetUp.file_name_season_out_deep;



temp_anom_var_name=OcoSetUp.temp_anom_var_name;
temp_wod_var_name=OcoSetUp.temp_wod_var_name;
t_var_name=OcoSetUp.t_var_name;
temp_var_name=OcoSetUp.temp_var_name;
%%



eval(['load ',file_path_out,'allsal_new_layers_argo_WOD_new_',file_name_season,...
   t_var_name,s_var_name,...
    'cds dt argo_delayed_mode argo_float_id mdep wod_oclnum topex'])%

   



% comput wnum which are 10x10 degree boxes over which the alphas are
% computed.
 
% calculate appropriate square for given lat and lon
iii=find(cds(:,1)<=0&cds(:,2)>0);
jjj=find(cds(:,1)>0 &cds(:,2)>0);
lll=find(cds(:,1)<=0&cds(:,2)<=0);
nnn=find(cds(:,1)>0 &cds(:,2)<=0);
wnum(iii)=abs(ceil(cds(iii,1)/10))+100*(ceil(cds(iii,2)/10)-1)+7000;
wnum(jjj)=ceil(cds(jjj,1)/10)-1+100*(ceil(cds(jjj,2)/10)-1)+1000;
wnum(lll)=abs(ceil(cds(lll,1)/10))+100*abs(ceil(cds(lll,2)/10))+5000;
wnum(nnn)=ceil(cds(nnn,1)/10)-1+100*abs(ceil(cds(nnn,2)/10))+3000;




 


tpx=topex(:,1);
tpx(isnan(tpx))=0;




    
    
  
    

% time is not saved so set it to 0
tm=dt(:,1).*0;
day=datenum([dt,tm,tm*0,tm*0])-datenum(1950,1,1);

% yr=(day-datenum(1992,1,1)+datenum(1950,1,1))/365.25+1992;
yr=decyear(dt);
% make files for gridding 

fname_nc=[file_path_hdata,'sdata_new_layers_',file_WOD_suf,'_',file_name_season_out_deep];

load('D:\data\topo_tpx_new.mat','topo_tpx_new','lat_topo','lon_topo')
[LON,LAT]=meshgrid(lon_topo,lat_topo);
LON=LON';
LAT=LAT';
    
coords = cds;
coords_tpx=coords;
coords_tpx(coords_tpx(:,1)<0,1)=coords_tpx(coords_tpx(:,1)<0,1)+360;
topo_insitu=interp_topo_insitu(coords_tpx);
% This finds the area that are <500 m but we dont consider costal
%   need to test it.  
% topo_test=topo_tpx_new;
% pos_bad=find_bad_depths(LON,LAT);
% topom=topo_test;
% topom(pos_bad)=nan;
% topom(topom<-500|topom>1)=nan;
% pos_off_coast=find_off_coast(LON,LAT,topom);
% topom=topo_test;
% topom((~pos_off_coast|topom>10))=nan;
% 
% topo_insitu_new=interp_topo_insitu(coords_tpx,topom);
% off_coast_cds=isfinite(topo_insitu_new);

pos_bad_cds=find_bad_depths(coords_tpx(:,1),coords_tpx(:,2));

good_cds_costal=(topo_insitu>=-500)&~pos_bad_cds;
good_cds_deep=~good_cds_costal;



good=good_cds_deep;
coords=coords(good,:);
topo_insitu=topo_insitu(good);
tpx=tpx(good);
yr=yr(good);
for ilayer=2:length(layer_bounds)
     eval(['t_junk=',...
        't_',num2str(layer_bounds(ilayer-1)),'_',...
         num2str(layer_bounds(ilayer)),';'])
     
     

     eval(['s_junk=',...
        's_',num2str(layer_bounds(ilayer-1)),'_',...
         num2str(layer_bounds(ilayer)),';'])
     
     s_junk=s_junk(good);
     t_junk=t_junk(good);
    
     
     eval(['t_',num2str(layer_bounds(ilayer-1)),'_',...
         num2str(layer_bounds(ilayer)),...
         '=t_junk;'])

     eval(['s_',num2str(layer_bounds(ilayer-1)),'_',...
         num2str(layer_bounds(ilayer)),...
         '=s_junk;'])
    
end

% 
% eval(['save ',fname_nc,' tpx yr coords ',...
%     tdiffvar_name, t_var_name])
eval(['save ',fname_nc,' tpx yr coords topo_insitu ',...
     t_var_name,s_var_name])
