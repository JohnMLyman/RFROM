

path_curves='C:\data\OHCA\curves\';
file_name='argo_2021_01_01_QC_karina'

% this is the time range of the maps that are to be saved and outputted
max_year_maps_out=2021;
min_year_maps_out=1960;

% this is the time range of the maps that were made by oco_maps* and are in
% the file name that has to be read
max_year_maps=2021;
min_year_maps=1960;
layer_bounds=[0,40,90,190,300,450,700,950,1450,1950,2000];

%%
depth_top_plot=0;
depth_bot_plot=300;



 [~,hc_one_0_300,~,vol_0_300,time]=...
    oco_new_load_ohca_curves_karina_60S_60N(file_name,min_year_maps,max_year_maps,...
    min_year_maps_out,max_year_maps_out,depth_top_plot,depth_bot_plot,layer_bounds);

hc_one_0_300=hc_one_0_300./1e21;


%%
depth_top_plot=0;
depth_bot_plot=700;



 [~,hc_one_0_700,~,vol_0_700,time]=...
    oco_new_load_ohca_curves_karina_60S_60N(file_name,min_year_maps,max_year_maps,...
    min_year_maps_out,max_year_maps_out,depth_top_plot,depth_bot_plot,layer_bounds);

hc_one_0_700=hc_one_0_700./1e21;

 %%
depth_top_plot=0;
depth_bot_plot=2000;



 [~,hc_one_0_2000,~,vol_0_2000,time]=...
    oco_new_load_ohca_curves_karina_60S_60N(file_name,min_year_maps,max_year_maps,...
    min_year_maps_out,max_year_maps_out,depth_top_plot,depth_bot_plot,layer_bounds);

hc_one_0_2000=hc_one_0_2000./1e21;

%%
depth_top_plot=700;
depth_bot_plot=2000;
 
  [~,hc_one_700_2000,~,vol_700_2000,time]=...
    oco_new_load_ohca_curves_karina_60S_60N(file_name,min_year_maps,max_year_maps,...
    min_year_maps_out,max_year_maps_out,depth_top_plot,depth_bot_plot,layer_bounds);

hc_one_700_2000=hc_one_700_2000./1e21;
 



%%




pos_1960_mean=find(time >1960 & time<max_year_maps_out); % removes a mean that is one year short of the record length
pos_1993_mean=find(time >1993 & time<max_year_maps_out);
pos_2005_mean=find(time >2005 & time<max_year_maps_out);

pos_1960_curve=find(time >1960 & time<max_year_maps_out+1); % defines curves the length of the maps
pos_1993_curve=find(time >1993 & time<max_year_maps_out+1);
pos_2005_curve=find(time >2005 & time<max_year_maps_out+1);


time_1960=time(pos_1960_curve);
time_1993=time(pos_1993_curve);
time_2005=time(pos_2005_curve);

area_0_300=vol_0_300(pos_1960_curve)./300;
area_0_700=vol_0_700(pos_1960_curve)./700;
area_0_2000=vol_0_2000(pos_1960_curve)./2000;
area_700_2000=vol_700_2000(pos_1960_curve)./(2000-700);

hc_one_0_300_1960_60_60=hc_one_0_300(pos_1960_curve)-nanmean(hc_one_0_300(pos_1960_mean));
hc_one_0_700_1960_60_60=hc_one_0_700(pos_1960_curve)-nanmean(hc_one_0_700(pos_1960_mean));

hc_one_0_300_1993_60_60=hc_one_0_300(pos_1993_curve)-nanmean(hc_one_0_300(pos_1993_mean));
hc_one_0_700_1993_60_60=hc_one_0_700(pos_1993_curve)-nanmean(hc_one_0_700(pos_1993_mean));

hc_one_0_300_2005_60_60=hc_one_0_300(pos_2005_curve)-nanmean(hc_one_0_300(pos_2005_mean));
hc_one_0_700_2005_60_60=hc_one_0_700(pos_2005_curve)-nanmean(hc_one_0_700(pos_2005_mean));
hc_one_0_2000_2005_60_60=hc_one_0_2000(pos_2005_curve)-nanmean(hc_one_0_2000(pos_2005_mean));
hc_one_700_2000_2005_60_60=hc_one_700_2000(pos_2005_curve)-nanmean(hc_one_700_2000(pos_2005_mean));

save([path_curves,'karina_ohca_60S_60N_2021.mat'], 'hc_one_0_300_1960_60_60', 'hc_one_0_700_1960_60_60', ...
    'hc_one_0_700_1993_60_60', ...
    'hc_one_0_300_2005_60_60','hc_one_0_700_2005_60_60', ...
    'hc_one_700_2000_2005_60_60', 'hc_one_0_2000_2005_60_60',...
    'time_1960', 'time_1993', 'time_2005',...
    'area_0_300', 'area_0_700', 'area_0_2000' ,'area_700_2000')







