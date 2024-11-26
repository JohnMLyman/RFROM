
function karina_wmo_60S_60N_files_2023_orca(TreeSetUp)

% [TreeSetUp]=TreeSetUp_2023_orca_heat_vert_test_nosshsst_karina;



path_figs=TreeSetUp.path_Figs;


% this is the time range of the maps that were made by oco_maps* and are in
% the file name that has to be read


%%
depth_top_plot=0;
depth_bot_plot=300;
[ht_curve_mon,vol_0_300,tgrid_mon]=bagged_tree_ohca_curve_7_day_errdp_ohca_60N_60S(TreeSetUp,depth_top_plot,depth_bot_plot);

[time,hc_0_300,~]=compute_tree_ohca_nocycle(tgrid_mon,ht_curve_mon);


hc_0_300=hc_0_300./1e21;


%%
depth_top_plot=0;
depth_bot_plot=700;



[ht_curve_mon,vol_0_700,tgrid_mon]=bagged_tree_ohca_curve_7_day_errdp_ohca_60N_60S(TreeSetUp,depth_top_plot,depth_bot_plot);

[~,hc_0_700,~]=compute_tree_ohca_nocycle(tgrid_mon,ht_curve_mon);


hc_0_700=hc_0_700./1e21;


%%
depth_top_plot=0;
depth_bot_plot=2000;



 [ht_curve_mon,vol_0_2000,tgrid_mon]=bagged_tree_ohca_curve_7_day_errdp_ohca_60N_60S(TreeSetUp,depth_top_plot,depth_bot_plot);

[~,hc_0_2000,~]=compute_tree_ohca_nocycle(tgrid_mon,ht_curve_mon);


hc_0_2000=hc_0_2000./1e21;

%%
depth_top_plot=700;
depth_bot_plot=2000;
 
 [ht_curve_mon,vol_700_2000,tgrid_mon]=bagged_tree_ohca_curve_7_day_errdp_ohca_60N_60S(TreeSetUp,depth_top_plot,depth_bot_plot);

[~,hc_700_2000,~]=compute_tree_ohca_nocycle(tgrid_mon,ht_curve_mon);



hc_700_2000=hc_700_2000./1e21;
 



%%




 % removes a mean that is one year short of the record length
pos_1993_mean=find(time >=1993 & time<=time(end)-1);
pos_2005_mean=find(time >=2005 & time<=time(end-1));

% defines curves the length of the maps
pos_1993_curve=find(time >=1993 );
pos_2005_curve=find(time >=2005 );



time_1993=time(pos_1993_curve);
time_2005=time(pos_2005_curve);

area_0_300=vol_0_300./300;
area_0_700=vol_0_700./700;
area_0_2000=vol_0_2000./2000;
area_700_2000=vol_700_2000./(2000-700);



hc_0_300_1993_60_60=hc_0_300(pos_1993_curve)-nanmean(hc_0_300(pos_1993_mean));
hc_0_700_1993_60_60=hc_0_700(pos_1993_curve)-nanmean(hc_0_700(pos_1993_mean));

hc_0_300_2005_60_60=hc_0_300(pos_2005_curve)-nanmean(hc_0_300(pos_2005_mean));
hc_0_700_2005_60_60=hc_0_700(pos_2005_curve)-nanmean(hc_0_700(pos_2005_mean));
hc_0_2000_2005_60_60=hc_0_2000(pos_2005_curve)-nanmean(hc_0_2000(pos_2005_mean));
hc_700_2000_2005_60_60=hc_700_2000(pos_2005_curve)-nanmean(hc_700_2000(pos_2005_mean));

save([path_figs,'data\karina_ohca_60S_60N_2023.mat'],  ...
    'hc_0_700_1993_60_60', 'hc_0_300_1993_60_60',...
    'hc_0_300_2005_60_60','hc_0_700_2005_60_60', ...
    'hc_700_2000_2005_60_60', 'hc_0_2000_2005_60_60',...
     'time_1993', 'time_2005',...
    'area_0_300', 'area_0_700', 'area_0_2000' ,'area_700_2000')







