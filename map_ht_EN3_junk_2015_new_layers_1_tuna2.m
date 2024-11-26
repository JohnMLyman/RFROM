% file_path='/Users/lyman/data/Globalhc/Floats/Argo/CORIOLIS/'
% file_path_out='/Users/lyman/data/Globalhc/Floats/Argo/CORIOLIS/depth_grid/'
% file_name='pfloat_sal_greg_jan_2011_new'
% file_path_hdata='/Users/lyman/data/Globalhc/HC/'

%% make the yearly maps

lon_grid=[-180:.5:180];
lat_grid=[-90:.5:90];

time_grid=[min_year_maps+.5:max_year_maps+.5];


tic
for ilayer=2:length(layer_bounds)

     eval(['depth_layer=''',...
         num2str(layer_bounds(ilayer-1)),'_',...
         num2str(layer_bounds(ilayer)),''';'])
     
     [iyear]=load_and_grid_matlab_realtime_gen_new_layers_1_tuna2(file_path_hdata,...
         ['hdata_new_layers_',file_WOD_suf,'_',file_name],depth_layer,lat_grid,lon_grid,time_grid);
end
['maping time',toc./60./60./24,' days']
%time_grid=[2004.5:2010.5];
%[iyear]=load_and_grid_matlab_realtime_700(file_path_hdata,['hdata_new_',file_WOD_suf,'_',file_name],lat_grid,lon_grid,time_grid);
%[iyear]=load_and_grid_matlab_realtime_gen_new_layer(file_path_hdata,['hdata_new_',file_WOD_suf,'_',file_name],'0_40',lat_grid,lon_grid,time_grid);
% [iyear]=load_and_grid_matlab_realtime_100_300(file_path_hdata,['hdata_new_',file_WOD_suf,'_',file_name],lat_grid,lon_grid,time_grid);
% [iyear]=load_and_grid_matlab_realtime_300_700(file_path_hdata,['hdata_new_',file_WOD_suf,'_',file_name],lat_grid,lon_grid,time_grid);
% % 
%  [iyear]=load_and_grid_matlab_realtime_900(file_path_hdata,['hdata_new_',file_WOD_suf,'_',file_name],lat_grid,lon_grid,time_grid);
%    [iyear]=load_and_grid_matlab_realtime_1800(file_path_hdata,['hdata_new_',file_WOD_suf,'_',file_name],lat_grid,lon_grid,time_grid);
% % % 
  
%  [iyear]=load_and_grid_matlab_realtime_300(file_path_hdata,['hdata_new_',file_WOD_suf,'_',file_name],lat_grid,lon_grid,time_grid);
 

% %% make the monthly maps
% 
% [iyear]=load_and_grid_matlab_mon(file_path_hdata,['hdata_100_',file_name]);
% 
% 
% 
% %% Now height
% 
% 
% %% make the yearly maps
% 
% [iyear]=load_and_grid_matlab_realtime_1800(file_path_hdata,['hdata_new_height_',file_name],lat_grid,lon_grid,time_grid);
% 
% [iyear]=load_and_grid_matlab_realtime_900(file_path_hdata,['hdata_new_height_',file_name],lat_grid,lon_grid,time_grid);
% [iyear]=load_and_grid_matlab_realtime_700(file_path_hdata,['hdata_new_height_',file_name],lat_grid,lon_grid,time_grid);
% [iyear]=load_and_grid_matlab_realtime_300(file_path_hdata,['hdata_new_height_',file_name],lat_grid,lon_grid,time_grid);
% [iyear]=load_and_grid_matlab_realtime_100(file_path_hdata,['hdata_new_height_',file_name],lat_grid,lon_grid,time_grid);
% 
% %% make the monthly maps
% 
% [iyear]=load_and_grid_matlab_mon(file_path_hdata,['hdata_100_height_',file_name]);

