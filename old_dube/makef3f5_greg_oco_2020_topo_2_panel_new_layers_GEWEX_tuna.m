% makef3f5.m - matlab script to make figures 3 and 5 for the globahc paper
mycor = [

         0.88          0.31             0
         0.60             0             0
         0.30          0.31          0.99
            0          0.60          0.20
         0.28          0.77          0.96
         0.99          0.81             0
         1.00          0.20          0.80
         0.49          0.10          0.34
         0.60          0.60          0.60
         .7             .9             .2
         0             0             0];
     
     mycor=[27,158,119
217,95,2
117,112,179
231,41,138
124.9500,25.5000,86.7000]./255;

mycor=[228,26,28 
    55,126,184
    77,175,74
    152,78,163
    255,127,0
    55,78,0]./255;

% % 

path_curves='C:\data\OHCA\curves\';
path_figs='C:\data\OHCA\figs\';
min_year=2005;
min_year_deep=1993;
max_year=2022;
max_year_deep=2022;
%load in error bars
% 
% load '/Volumes/ThunderBay/Data/Globalhc/SAL/Floats/nature_2010_ohca_curve'
% 
% hc_se=[ohca_se ohca_se(end) ohca_se(end) ohca_se(end) ohca_se(end) ohca_se(end) ohca_se(end) ohca_se(end)]*10;
% hc_se=[repmat(hc_se(1),[1,26]),hc_se];
% 
% 
% time_se=[1967.5:2015.5];
% % 
load 'C:\data\OHCA\total_uncertainty_paper_2015_0_700_1800_oco.mat'  time_se total_se_0_700 samp_un_sd_700_1800 total_se_0_1800
del_time=max_year-2010-1;
time_se=[time_se' [2010.5:1:2010.5+del_time]];
hc_se=[total_se_0_700 repmat(total_se_0_700(end),1,del_time+1)];
hc_se_deep=[samp_un_sd_700_1800 repmat(samp_un_sd_700_1800(end),1,del_time+1)];

hc_se_total=[total_se_0_1800 repmat(total_se_0_1800(end),1,del_time+1)];


good_se=find(time_se>min_year);
hc_se=hc_se(good_se);
hc_se_total=hc_se_total(good_se);
se_one_deep_total=hc_se_total;

% good_se_deep=find(time_se>1992);
% hc_se_deep=hc_se_deep(good_se_deep);
%hc_se_deep=hc_se_deep(good_se);
%area of the earth used to compute w/m^2
area_of_earth=5.1e14;

year_of_oco_pub=2022;
slope_min_year=1993;
file_name='argo_2021_01_01_QC'
% this is the time range of the maps that are to be saved and outputted
max_year_maps_out=2021;
min_year_maps_out=2005;

% this is the time range of the maps that were made by oco_maps* and are in
% the file name that has to be read
max_year_maps=2021;
min_year_maps=1990;
layer_bounds=[0,40,90,190,290,450,700,950,1450,1950,2000];


depth_top_plot=0;
depth_bot_plot=2000;
 
 [hc_deep_total,hc_one_deep_total,hctpx_deep_total,time_grid_deep]=...
    oco_new_load_ohca_curves(file_name,min_year_maps,max_year_maps,...
    min_year_maps_out,max_year_maps_out,depth_top_plot,depth_bot_plot,layer_bounds);



write_ascii_GEWEX_error(hc_one_deep_total,se_one_deep_total,time_grid_deep,[path_curves,'PMEL_0_2000_insitu.txt'])

