% file_path='/Users/lyman/data/Globalhc/Floats/Argo/CORIOLIS/'
% file_path_out='/Users/lyman/data/Globalhc/Floats/Argo/CORIOLIS/depth_grid/'
% file_name='pfloat_sal_greg_jan_2011_new'
% file_path_hdata='/Users/lyman/data/Globalhc/HC/'
tree_model_file_name='tree_sst_tpx_year_1993'
tree_model_file_name='tree_sst_tpx_yearly'

file_name_argo='pfloat_sal_greg_oct_2021_QC'
file_name='argo_2020_10_14_QC'
path_OHCA_data_out='C:\data\OHCA\'
path_OHCA_data_in='C:\OHCA\'
%%  YOU MUST DOWNLOAD ARGO AND AVISO DATA AND PUT THEM IN THE CORRECT LOCATIONS!!!!
%%%%  Do I need the next line I dont think so!!!  11/14/2017

%%
% YOU MUST CHANE THE FILE_NAME TO THE CURRNET DATE EVERY TIME YOU CHANGE
% LAYERBOUNDS AND/OR FILE_NAME_ARGO SO THAT THE FILES DO NOT GET OVER WRITEN!!!!!
% file_nmae=argo_year_month_day_qc


layer_bounds=[0,40,90,190,290,450,700,950,1450,1950,2000] % layer_bounds must be in assending order
%layer_bounds=[0,100,300,700,900,1800] % layer_bounds must be in assending order




lon_grid=[-180:.5:180];
lat_grid=[-90:.5:90];

max_year_maps=2021;
min_year_maps=1993;
%set paths
% file_path='/Volumes/ThunderBay/Data/Globalhc/Floats/Argo/CORIOLIS/'
% file_path_out='/Volumes/ThunderBay/Data/Globalhc/Floats/Argo/CORIOLIS/depth_grid/'
file_path=[path_OHCA_data_out,'OHCA_profiles\'];
file_path_out=[path_OHCA_data_out,'OHCA_grided\'];
file_path_in=path_OHCA_data_in;
% I think you can change file_anme_mean if you want to run a diffent mean but not
% 100% sure doubble check
file_name_mean=file_name;
file_path_hdata=[path_OHCA_data_out,'OHCA_maps\'];
file_WOD_suf='_cheng_EN4_2014'
file_EN3_type='_cheng_EN4_2014'
path_EN4_in=[path_OHCA_data_in,'EN4\Cheng_2014\'];
path_EN4_out=[path_OHCA_data_out,'EN4\Cheng_2014\'];
allheat_extra='_new'

time_grid=[min_year_maps:.5:max_year_maps]


tic
% % % for ilayer=2:length(layer_bounds)
for ilayer=2:length(layer_bounds)
     depth_layer=[num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer))];
     
     [iyear]=load_and_grid_matlab_realtime_gen_new_layers_1_half_tree_tuna(file_path_hdata,...
         ['hdata_new_layers_',file_WOD_suf,'_',file_name],tree_model_file_name,depth_layer,lat_grid,lon_grid,time_grid);
     

     ['maping time',toc./60./60./24,' days']

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

