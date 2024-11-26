function bin_EN4_2021_new_layers_orca_seasonal_sal_noEN4(OcoSetUp)

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


%% Load in the EN4 temp content without floats 


% eval(['load ',path_EN4_out,'allsal_wod_new_layers_all_conv4',file_name,file_WOD_suf]);

% 
%% load in the Argo fields 
eval(['load ',file_path_out,'allsal_new_layers_seasonal_',allsal_extra,...
    t_var_name,s_var_name,...
    'cds dt tm mdep npts time fptot fpkeep bdt bbas ind id qual ',...
	'press_mis_flag dac_centre wmo_inst cycle'])%


argo_delayed_mode=nans(size(qual))';
argo_delayed_mode(qual=='D')=1;
argo_delayed_mode(qual=='R')=0;
argo_float_id=id;
argo_cycle=cycle;


    
%% combine WOD and argo 
% t_0_40=[temp_0_40_wod;t_0_40];
% 
% for ilayer=2:length(layer_bounds)
%      eval(['t_junk=',...
%         't_',num2str(layer_bounds(ilayer-1)),'_',...
%          num2str(layer_bounds(ilayer)),';'])
%      
%      eval(['temp_wod_junk=',...
%         'temp_',num2str(layer_bounds(ilayer-1)),'_',...
%          num2str(layer_bounds(ilayer)),'_wod;'])
% 
%      eval(['s_junk=',...
%         's_',num2str(layer_bounds(ilayer-1)),'_',...
%          num2str(layer_bounds(ilayer)),';'])
%      
%      eval(['sal_wod_junk=',...
%         'sal_',num2str(layer_bounds(ilayer-1)),'_',...
%          num2str(layer_bounds(ilayer)),'_wod;'])
%      
%     t_junk=[temp_wod_junk;t_junk];
%      s_junk=[sal_wod_junk;s_junk];
%     
%      
%      eval(['t_',num2str(layer_bounds(ilayer-1)),'_',...
%          num2str(layer_bounds(ilayer)),...
%          '=t_junk;'])
% 
%      eval(['s_',num2str(layer_bounds(ilayer-1)),'_',...
%          num2str(layer_bounds(ilayer)),...
%          '=s_junk;'])
%     
% end



% 
% t_1800=[temp_1800_wod;t_1800];
% t_900=[temp_900_wod;t_900];
% t_700=[temp_700_wod;t_700];
% t_300=[temp_300_wod;t_300];
% t_100=[temp_100_wod;t_100];
% t_300_700=[temp_300_700_wod;t_300_700];
% t_100_300=[temp_100_300_wod;t_100_300];


% cds=[coords_wod;cds];
% dt=[dt_wod;dt];
% argo_delayed_mode=[nans(size(qual_wod));argo_delayed_mode];
% argo_float_id=[nans(size(qual_wod));argo_float_id];
% argo_cycle=[nans(size(qual_wod));argo_cycle];
% mdep=[mdep_wod;mdep];
%time=[time_wod;time];

% wod_oclnum=[oclnum_wod;nans(size(id))];
wod_oclnum=[nans(size(id))];

    




    
 eval(['save ',file_path_out,'allsal_new_layers_argo_noEN4_new_',file_name_season,...
    t_var_name,s_var_name,...
     'cds dt argo_delayed_mode argo_float_id mdep wod_oclnum'])
	
   


% 
% eval(['save /Volumes/ThunderBay/Data/Globalhc/WOD05/allheat_100_300_700_900_1800_argo_WOD_new_',file_name,' t_1800 t_900 t_700 t_300 t_100 t_300_700 t_100_300 '...
%     'cds dt argo_delayed_mode argo_float_id mdep wod_oclnum'])
% 


