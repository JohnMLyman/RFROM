function argo_remove_bad_profiles_layers_seasonal_orca_heat(OcoSetUp)

%%

file_path_out=OcoSetUp.file_path_out;

file_name=OcoSetUp.file_name;

allheat_extra=OcoSetUp.allheat_extra;
layer_bounds=OcoSetUp.layer_bounds;
bad_heat_var_name=OcoSetUp.bad_heat_var_name;

heat_var_name=OcoSetUp.heat_var_name;

h_var_name=OcoSetUp.h_var_name;

%%
date=[];%must define date as a varible so its not used as a function
eval(['load ',file_path_out,file_name,'_new_layers_heat_oco_100  ',...
    heat_var_name,...
    'coords date mdep npts time fptot fpkeep bdt bbas ind id qual ',...
	'press_mis_flag dac_centre wmo_inst cycle'])



eval(['load ',file_path_out,file_name,'_bad_oco_100_new_layers_heat.mat ',...
    bad_heat_var_name])


% take out bad data


for ilayer=2:length(layer_bounds)

     eval(['heat_',num2str(layer_bounds(ilayer-1)),'_',...
         num2str(layer_bounds(ilayer)),'(',...
         'bad_heat_',num2str(layer_bounds(ilayer-1)),'_',...
         num2str(layer_bounds(ilayer)),')=NaN;'])
end
 


% remove the mean
eval(['np=length(heat_',num2str(layer_bounds(1)),'_',...
         num2str(layer_bounds(2)),');'])
% extend the lon of the mean so that it wraps around assumes globally
% grided mean


for ilayer=2:length(layer_bounds)

         eval(['h_',num2str(layer_bounds(ilayer-1)),'_',...
         num2str(layer_bounds(ilayer)),'=heat_',...
         num2str(layer_bounds(ilayer-1)),'_',...
         num2str(layer_bounds(ilayer)),';'])
end


cds=coords;
dt=date;
tm=time(:,1);

% % % eval(['save ',file_path_out,'allheat_100_300_700_900_1800_new',allheat_extra,' ht_100 ht_300 ht_100_300 ht_300_700 ',...
% % %     'ht_700 ht_900 ht_1800 topex cds dt tm mdep npts time fptot fpkeep bdt bbas ind id qual ',...
% % % 	'press_mis_flag dac_centre wmo_inst cycle'])%
% % % 
% % % 

% took out topex from save John Lyman 11/12/2015
 eval(['save ',file_path_out,'allheat_new_layers_seasonal_',allheat_extra,...
    h_var_name,...
    'cds dt tm mdep npts time fptot fpkeep bdt bbas ind id qual ',...
	'press_mis_flag dac_centre wmo_inst cycle'])%


