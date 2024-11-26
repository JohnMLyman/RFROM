% % file_path='/Users/johnlyman/data/Globalhc/Floats/Argo/CORIOLIS/'
% % file_path_out='/Users/johnlyman/data/Globalhc/Floats/Argo/CORIOLIS/depth_grid/'
% % file_name='pfloat_sal_greg_june_2008'

eval(['load ',file_path_out,file_name,'_new_layers_heat_oco_100  ',...
    heat_var_name,...
    'coords date mdep npts time fptot fpkeep bdt bbas ind id qual ',...
	'press_mis_flag dac_centre wmo_inst cycle'])


eval(['load ',file_path_out,file_name,'_bad_oco_100_new_layers.mat ',...
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

         eval(['ht_',num2str(layer_bounds(ilayer-1)),'_',...
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
    ht_var_name,...
    'cds dt tm mdep npts time fptot fpkeep bdt bbas ind id qual ',...
	'press_mis_flag dac_centre wmo_inst cycle'])%


