% % file_path='/Users/johnlyman/data/Globalhc/Floats/Argo/CORIOLIS/'
% % file_path_out='/Users/johnlyman/data/Globalhc/Floats/Argo/CORIOLIS/depth_grid/'
% % file_name='pfloat_sal_greg_june_2008'

eval(['load ',file_path_out,file_name,'_new_layers_heat_oco_100  ',...
    heat_var_name,...
    'coords date mdep npts time fptot fpkeep bdt bbas ind id qual ',...
	'press_mis_flag dac_centre wmo_inst cycle'])


eval(['load ',file_path_out,file_name,'_bad_oco_100_new_layers.mat ',...
    bad_heat_var_name])


eval(['load ',file_path_out,file_name_mean,'_mean_heat_oco_100_new_layers ',...
    mean_heat_var_name,' lon_grid lat_grid'])

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


%% extend the grid so it wraps around in longitude
for ilayer=2:length(layer_bounds)
     eval(['mean_heat_junk=',...
        'mean_heat_',num2str(layer_bounds(ilayer-1)),'_',...
         num2str(layer_bounds(ilayer)),';'])
     
     
     mean_heat_junk=[mean_heat_junk(end-21:end-1,:,:);mean_heat_junk;mean_heat_junk(2:22,:,:)];
     
     eval(['mean_heat_',num2str(layer_bounds(ilayer-1)),'_',...
         num2str(layer_bounds(ilayer)),...
         '=mean_heat_junk;'])
    
end

lon_grid=[lon_grid(end-21:end-1)-360 lon_grid lon_grid(2:22)+360];

%%  linearly interlopate the mean to the profile positions and remove it making new

for ilayer=2:length(layer_bounds)
     eval(['mean_heat_junk=',...
        'mean_heat_',num2str(layer_bounds(ilayer-1)),'_',...
         num2str(layer_bounds(ilayer)),';'])
     
     eval(['heat_junk=',...
        'heat_',num2str(layer_bounds(ilayer-1)),'_',...
         num2str(layer_bounds(ilayer)),';'])
     
     heat_grid_junk=interp2(lon_grid,lat_grid,mean_heat_junk',...
        coords(:,1),coords(:,2));
    heat_anom_junk=heat_junk-heat_grid_junk;
    
     
     eval(['heat_',num2str(layer_bounds(ilayer-1)),'_',...
         num2str(layer_bounds(ilayer)),...
         '_anom=heat_anom_junk;'])
    
end



   
%% save 

eval(['save ',file_path_out,file_name,'_heat_amon_oco_100_new_layers ',...
    heat_anom_var_name,heat_var_name,...
    'coords date mdep npts time fptot fpkeep bdt bbas ind id qual ',...
	'press_mis_flag dac_centre wmo_inst cycle'])


