% % file_path='/Users/johnlyman/data/Globalhc/Floats/Argo/CORIOLIS/'
% % file_path_out='/Users/johnlyman/data/Globalhc/Floats/Argo/CORIOLIS/depth_grid/'
% % file_name='pfloat_sal_greg_june_2008'



eval(['load ',file_path_out,file_name,'_new_layers_heat_oco_100  ',...
    heat_var_name,...
    'coords date mdep npts time fptot fpkeep bdt bbas ind id qual ',...
	'press_mis_flag dac_centre wmo_inst cycle'])


eval(['load ',file_path_out,file_name,'_bad_oco_100_new_layers.mat ',...
    bad_heat_var_name])


for ilayer=2:length(layer_bounds)

     eval(['heat_',num2str(layer_bounds(ilayer-1)),'_',...
         num2str(layer_bounds(ilayer)),'(',...
         'bad_heat_',num2str(layer_bounds(ilayer-1)),'_',...
         num2str(layer_bounds(ilayer)),')=NaN;'])
end
 



%gird heatcontent to a 10x10 degree map, and then take the use it as the
%mean
lon_grid=lon_grid_mean;
lat_grid=lat_grid_mean;
gmap_scale=10;

% only grid 2004 to 2007 mean...

good_time=find((date(:,1)>= min_year) & (date(:,1)<=max_year));


for ilayer=2:2:length(layer_bounds)-1
    
   
    eval(['heat_junk1=',...
        'heat_',num2str(layer_bounds(ilayer-1)),'_',...
         num2str(layer_bounds(ilayer)),';'])
    eval(['heat_junk2=',...
        'heat_',num2str(layer_bounds(ilayer)),'_',...
         num2str(layer_bounds(ilayer+1)),';'])
    
   [mean_heat_junk1,mean_heat_junk2]=guass_smooth(heat_junk1(good_time),heat_junk2(good_time),coords(good_time,:),lon_grid,lat_grid,gmap_scale);
   
   eval(['mean_heat_',num2str(layer_bounds(ilayer-1)),'_',...
         num2str(layer_bounds(ilayer)),...
         '=mean_heat_junk1;'])
    eval(['mean_heat_',num2str(layer_bounds(ilayer)),'_',...
         num2str(layer_bounds(ilayer+1)),...
         '=mean_heat_junk2;'])
   
   
end
 
% take take of the case where there are an odd number of layers (even
% number of bounderies)

if mod(length(layer_bounds)-1,2)
    eval(['heat_junk1=',...
        'heat_',num2str(layer_bounds(length(layer_bounds)-1)),'_',...
         num2str(layer_bounds(length(layer_bounds))),';'])
     
     heat_junk2=heat_junk1;
    [mean_heat_junk1,mean_heat_junk2]=guass_smooth(heat_junk1(good_time),heat_junk1(good_time),coords(good_time,:),lon_grid,lat_grid,gmap_scale);
    eval(['mean_heat_',num2str(layer_bounds(length(layer_bounds)-1)),'_',...
         num2str(layer_bounds(length(layer_bounds))),...
         '=mean_heat_junk1;'])
end
    
  
eval(['save ',file_path_out,file_name_mean,'_mean_heat_oco_100_new_layers ',...
    mean_heat_var_name,' lon_grid lat_grid'])
