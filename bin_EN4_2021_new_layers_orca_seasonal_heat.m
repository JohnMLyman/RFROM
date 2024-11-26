function bin_EN4_2021_new_layers_orca_seasonal_heat(OcoSetUp)

%%

file_path_out=OcoSetUp.file_path_out;

file_name=OcoSetUp.file_name;

file_WOD_suf=OcoSetUp.file_WOD_suf; 

path_EN4_out=OcoSetUp.path_EN4_out;

allheat_extra=OcoSetUp.allheat_extra;
layer_bounds=OcoSetUp.layer_bounds;

h_var_name=OcoSetUp.h_var_name;

file_name_season=OcoSetUp.file_name_season;

%%


%% Load in the EN4 heat content without floats 


eval(['load ',path_EN4_out,'allheat_wod_new_layers_all_conv4',file_name,file_WOD_suf]);

% 
%% load in the Argo fields 
eval(['load ',file_path_out,'allheat_new_layers_seasonal_',allheat_extra,...
    h_var_name,...
    'cds dt tm mdep npts time fptot fpkeep bdt bbas ind id qual ',...
	'press_mis_flag dac_centre wmo_inst cycle'])%


argo_delayed_mode=nans(size(qual))';
argo_delayed_mode(qual=='D')=1;
argo_delayed_mode(qual=='R')=0;
argo_float_id=id;
argo_cycle=cycle;


    
%% combine WOD and argo 
% t_0_40=[heat_0_40_wod;t_0_40];

for ilayer=2:length(layer_bounds)
     eval(['h_junk=',...
        'h_',num2str(layer_bounds(ilayer-1)),'_',...
         num2str(layer_bounds(ilayer)),';'])
     
     eval(['heat_wod_junk=',...
        'heat_',num2str(layer_bounds(ilayer-1)),'_',...
         num2str(layer_bounds(ilayer)),'_wod;'])
     
    h_junk=[heat_wod_junk;h_junk];
    
     
     eval(['h_',num2str(layer_bounds(ilayer-1)),'_',...
         num2str(layer_bounds(ilayer)),...
         '=h_junk;'])
    
end



% 
% t_1800=[heat_1800_wod;t_1800];
% t_900=[heat_900_wod;t_900];
% t_700=[heat_700_wod;t_700];
% t_300=[heat_300_wod;t_300];
% t_100=[heat_100_wod;t_100];
% t_300_700=[heat_300_700_wod;t_300_700];
% t_100_300=[heat_100_300_wod;t_100_300];


cds=[coords_wod;cds];
dt=[dt_wod;dt];
argo_delayed_mode=[nans(size(qual_wod));argo_delayed_mode];
argo_float_id=[nans(size(qual_wod));argo_float_id];
argo_cycle=[nans(size(qual_wod));argo_cycle];
mdep=[mdep_wod;mdep];
%time=[time_wod;time];

wod_oclnum=[oclnum_wod;nans(size(id))];

    




    
 eval(['save ',file_path_out,'allheat_new_layers_argo_WOD_new_',file_name_season,...
    h_var_name,...
     'cds dt argo_delayed_mode argo_float_id mdep wod_oclnum'])
	
   


% 
% eval(['save /Volumes/ThunderBay/Data/Globalhc/WOD05/allheat_100_300_700_900_1800_argo_WOD_new_',file_name,' t_1800 t_900 t_700 t_300 t_100 t_300_700 t_100_300 '...
%     'cds dt argo_delayed_mode argo_float_id mdep wod_oclnum'])
% 


