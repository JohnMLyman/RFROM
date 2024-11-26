function argo_remove_bad_profiles_layers_seasonal_orca_sal(OcoSetUp)

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
%%
date=[];%must define date as a varible so its not used as a function
eval(['load ',file_path_out,file_name,'_new_layers_sal_oco_100  ',...
    temp_var_name,sal_var_name,...
    'coords date mdep npts time fptot fpkeep bdt bbas ind id qual ',...
	'press_mis_flag dac_centre wmo_inst cycle'])



eval(['load ',file_path_out,file_name,'_bad_oco_100_new_layers_sal.mat ',...
    bad_sal_var_name])


% take out bad data


for ilayer=2:length(layer_bounds)

     eval(['temp_',num2str(layer_bounds(ilayer-1)),'_',...
         num2str(layer_bounds(ilayer)),'(',...
         'bad_sal_',num2str(layer_bounds(ilayer-1)),'_',...
         num2str(layer_bounds(ilayer)),')=NaN;'])
     eval(['sal_',num2str(layer_bounds(ilayer-1)),'_',...
         num2str(layer_bounds(ilayer)),'(',...
         'bad_sal_',num2str(layer_bounds(ilayer-1)),'_',...
         num2str(layer_bounds(ilayer)),')=NaN;'])
end
 


% remove the mean
eval(['np=length(temp_',num2str(layer_bounds(1)),'_',...
         num2str(layer_bounds(2)),');'])
% extend the lon of the mean so that it wraps around assumes globally
% grided mean


for ilayer=2:length(layer_bounds)

         eval(['t_',num2str(layer_bounds(ilayer-1)),'_',...
         num2str(layer_bounds(ilayer)),'=temp_',...
         num2str(layer_bounds(ilayer-1)),'_',...
         num2str(layer_bounds(ilayer)),';'])
          eval(['s_',num2str(layer_bounds(ilayer-1)),'_',...
         num2str(layer_bounds(ilayer)),'=sal_',...
         num2str(layer_bounds(ilayer-1)),'_',...
         num2str(layer_bounds(ilayer)),';'])
end


cds=coords;
dt=date;
tm=time(:,1);

% % % eval(['save ',file_path_out,'alltemp_100_300_700_900_1800_new',alltemp_extra,' ht_100 ht_300 ht_100_300 ht_300_700 ',...
% % %     'ht_700 ht_900 ht_1800 topex cds dt tm mdep npts time fptot fpkeep bdt bbas ind id qual ',...
% % % 	'press_mis_flag dac_centre wmo_inst cycle'])%
% % % 
% % % 

% took out topex from save John Lyman 11/12/2015
 eval(['save ',file_path_out,'allsal_new_layers_seasonal_',allsal_extra,...
    t_var_name,s_var_name,...
    'cds dt tm mdep npts time fptot fpkeep bdt bbas ind id qual ',...
	'press_mis_flag dac_centre wmo_inst cycle'])%


