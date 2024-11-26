

%% Load in the EN4 heat content without floats 


eval(['load ',path_EN4_out,'allheat_wod_new_layers_all_conv4',file_name,file_WOD_suf]);

% 
%% load in the Argo fields 
eval(['load ',file_path_out,'allheat_new_layers_seasonal_',allheat_extra,...
    ht_var_name,...
    'cds dt tm mdep npts time fptot fpkeep bdt bbas ind id qual ',...
	'press_mis_flag dac_centre wmo_inst cycle'])%


argo_delayed_mode=nans(size(qual))';
argo_delayed_mode(qual=='D')=1;
argo_delayed_mode(qual=='R')=0;
argo_float_id=id;
argo_cycle=cycle;


    
%% combine WOD and argo 
% ht_0_40=[heat_0_40_wod;ht_0_40];

for ilayer=2:length(layer_bounds)
     eval(['ht_junk=',...
        'ht_',num2str(layer_bounds(ilayer-1)),'_',...
         num2str(layer_bounds(ilayer)),';'])
     
     eval(['heat_wod_junk=',...
        'heat_',num2str(layer_bounds(ilayer-1)),'_',...
         num2str(layer_bounds(ilayer)),'_wod;'])
     
    ht_junk=[heat_wod_junk;ht_junk];
    
     
     eval(['ht_',num2str(layer_bounds(ilayer-1)),'_',...
         num2str(layer_bounds(ilayer)),...
         '=ht_junk;'])
    
end



% 
% ht_1800=[heat_1800_wod;ht_1800];
% ht_900=[heat_900_wod;ht_900];
% ht_700=[heat_700_wod;ht_700];
% ht_300=[heat_300_wod;ht_300];
% ht_100=[heat_100_wod;ht_100];
% ht_300_700=[heat_300_700_wod;ht_300_700];
% ht_100_300=[heat_100_300_wod;ht_100_300];


cds=[coords_wod;cds];
dt=[dt_wod;dt];
argo_delayed_mode=[nans(size(qual_wod));argo_delayed_mode];
argo_float_id=[nans(size(qual_wod));argo_float_id];
argo_cycle=[nans(size(qual_wod));argo_cycle];
mdep=[mdep_wod;mdep];
%time=[time_wod;time];

wod_oclnum=[oclnum_wod;nans(size(id))];

    




    
 eval(['save ',file_path_out,'allheat_new_layers_argo_WOD_new_',file_name_season,...
    ht_var_name,...
     'cds dt argo_delayed_mode argo_float_id mdep wod_oclnum'])
	
   


% 
% eval(['save /Volumes/ThunderBay/Data/Globalhc/WOD05/allheat_100_300_700_900_1800_argo_WOD_new_',file_name,' ht_1800 ht_900 ht_700 ht_300 ht_100 ht_300_700 ht_100_300 '...
%     'cds dt argo_delayed_mode argo_float_id mdep wod_oclnum'])
% 


