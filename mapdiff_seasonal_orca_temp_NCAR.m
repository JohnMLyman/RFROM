function mapdiff_seasonal_orca_temp_NCAR(OcoSetUp)

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
alltemp_extra=OcoSetUp.alltemp_extra;
layer_bounds=OcoSetUp.layer_bounds;
bad_temp_var_name=OcoSetUp.bad_temp_var_name;
ind_var_name=OcoSetUp.ind_var_name;
temp_var_name=OcoSetUp.temp_var_name;
lon_grid_mean=OcoSetUp.lon_grid_mean;
lat_grid_mean=OcoSetUp.lat_grid_mean;
mean_temp_var_name=OcoSetUp.mean_temp_var_name;
temp_anom_var_name=OcoSetUp.temp_anom_var_name;
temp_wod_var_name=OcoSetUp.temp_wod_var_name;
t_var_name=OcoSetUp.t_var_name;
mean_temp_oa_name=OcoSetUp.mean_temp_oa_name;
tdiffvar_name=OcoSetUp.tdiffvar_name; 
file_EN3_type=OcoSetUp.file_EN3_type;
file_name_argo=OcoSetUp.file_name_argo;
min_year_mean=OcoSetUp.min_year_mean;
max_year_mean=OcoSetUp.max_year_mean;
file_name_season=OcoSetUp.file_name_season;



file_name_NCAR=OcoSetUp.file_name_NCAR;

%%



eval(['load ',file_path_out,'alltemp_new_layers_argo_WOD_new_',file_name_season,...
   t_var_name,...
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

coords=cds;
pos_360=coords(:,1)<0;
coords(pos_360,1)=coords(pos_360,1)+360;

max_depth=nan(length(yr),1);
% this section finds the maxium depth of the profile that we used.
for ilayer=2:length(layer_bounds)
     
     eval(['t_junk=',...
        't_',num2str(layer_bounds(ilayer-1)),'_',...
         num2str(layer_bounds(ilayer)),';'])
     good=~isfinite(t_junk)& ~isfinite(max_depth);
     max_depth(good)=layer_bounds(ilayer-1);

     if ilayer==length(layer_bounds) % this is the case that the last layer is good so the max depth goes to the bottom 
         good=isfinite(t_junk)& ~isfinite(max_depth);
         max_depth(good)=layer_bounds(ilayer);
     end
    
end

%Load in NCAR lat lon and SSH
%aslo compute model day 
% years 26-61 and 148-183.  Both correspond to calendar years 1983-2018. 

[pos_2d,coords_ncar_prof,max_depth_ncar_prof,yr_ncar_prof]=...
    find_profs_model(coords,yr,max_depth);

save(file_name_NCAR,'pos_2d','coords_ncar_prof','max_depth_ncar_prof','yr_ncar_prof')



