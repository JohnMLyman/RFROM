%% set the path and file names be ware

file_name_argo='pfloat_sal_greg_march_2023_QC'
path_OHCA_data_out='D:\';
path_OHCA_data_in='D:\';
%%  YOU MUST DOWNLOAD ARGO AND AVISO DATA AND PUT THEM IN THE CORRECT LOCATIONS!!!!
%%%%  Do I need the next line I dont think so!!!  11/14/2017

%%
% YOU MUST CHANE THE FILE_NAME TO THE CURRNET DATE EVERY TIME YOU CHANGE
% LAYERBOUNDS AND/OR FILE_NAME_ARGO SO THAT THE FILES DO NOT GET OVER WRITEN!!!!!
% file_nmae=argo_year_month_day_qc


file_name='argo_2023_03_23_QC_press'
file_name_season=[file_name,'_seasonal']
var_type='t'
%layer_bounds=[0,40,90,190,290,450,700,950,1450,1950,2000]% layer_bounds must be in assending order
%layer_bounds=[0,100,300,700,900,1800] % layer_bounds must be in assending order
layer_bounds=[0, 5, 15, 25, 35, 45, 55, 65, 75, 85, 95, 105, 115, 125,...
    135, 145, 155, 165, 175, 190, 210, 230, 250, 270, 290, 310, 330 , ...
    350, 370 , 390, 410,  430, 450, 475, 525, 575, 625, 675, 725, 775,...
    825, 875, 925, 975, 1025, 1075, 1125, 1175, 1225, 1275, 1325, 1375,...
    1450, 1550, 1650, 1750, 1850, 1950, 2000]% layer_bounds must be in assending order

% grid for first-order large scale mean
lon_grid_mean=[-180:5:180];
lat_grid_mean=[-90:5:90];

% range for the large scale mean in Avsio and Argo
%   it is also the time range for which the Aviso and Argo
%   are correlated for means of infilling

max_year_mean=2021;
min_year_mean=2005;


%range for annual maps


max_year_maps=2022;
min_year_maps=1990;

%% NEED TO CHANGE THE PLOT INFO AT THE BOTTOM OF THIS FILE!!!!!




%set paths
% file_path='/Volumes/ThunderBay/Data/Globalhc/Floats/Argo/CORIOLIS/'
% file_path_out='/Volumes/ThunderBay/Data/Globalhc/Floats/Argo/CORIOLIS/depth_grid/'
file_path=[path_OHCA_data_out,'profiles\',var_type,'_profiles\'];
file_path_prof=[path_OHCA_data_out,'profiles\'];
file_path_out=[path_OHCA_data_out,'grided\',var_type,'_grided\'];
if ~exist(file_path,'dir')
    mkdir(file_path)
end
if ~exist(file_path_prof,'dir')
    mkdir(file_path_prof)
end
if ~exist(file_path_out,'dir')
    mkdir(file_path_out)
end
file_path_in=path_OHCA_data_in;
% I think you can change file_anme_mean if you want to run a diffent mean but not
% 100% sure doubble check
file_name_mean=file_name;
file_path_hdata=[path_OHCA_data_out,var_type,'_maps\'];
if ~exist(file_path_hdata,'dir')
    mkdir(file_path_hdata)
end

file_EN3_type='_cheng_EN4_2014'
path_EN4_in=[path_OHCA_data_in,'EN4\Cheng_2014\'];
path_EN4_out=[path_OHCA_data_out,'EN4\Cheng_2014\'];
alltemp_extra='_new'
file_WOD_suf=file_EN3_type;


%%
min_year=min_year_mean;
max_year=max_year_mean;

% define the varibiles to be saved and read

temp_var_name=[];

for ilayer=2:length(layer_bounds)
    
    temp_var_name=[temp_var_name,' temp_',num2str(layer_bounds(ilayer-1)),...
        '_',num2str(layer_bounds(ilayer))];
    
end
temp_var_name=[temp_var_name,' '];
    
ind_var_name=[];

for ilayer=2:length(layer_bounds)
    
    ind_var_name=[ind_var_name,' ind_',num2str(layer_bounds(ilayer-1)),...
        '_',num2str(layer_bounds(ilayer))];
    
end
ind_var_name=[ind_var_name,' '];

bad_temp_var_name=[];

for ilayer=2:length(layer_bounds)
    
    bad_temp_var_name=[bad_temp_var_name,' bad_temp_',num2str(layer_bounds(ilayer-1)),...
        '_',num2str(layer_bounds(ilayer))];
    
end
bad_temp_var_name=[bad_temp_var_name,' '];

mean_temp_var_name=[];

for ilayer=2:length(layer_bounds)
    
    mean_temp_var_name=[mean_temp_var_name,' mean_temp_',num2str(layer_bounds(ilayer-1)),...
        '_',num2str(layer_bounds(ilayer))];
    
end
mean_temp_var_name=[mean_temp_var_name,' '];


temp_anom_var_name=[];

for ilayer=2:length(layer_bounds)
    
    temp_anom_var_name=[temp_anom_var_name,' temp_',num2str(layer_bounds(ilayer-1)),...
        '_',num2str(layer_bounds(ilayer)),'_anom'];
    
end
temp_anom_var_name=[temp_anom_var_name,' '];
    
temp_wod_var_name=[];

for ilayer=2:length(layer_bounds)
    
    temp_wod_var_name=[temp_wod_var_name,' temp_',num2str(layer_bounds(ilayer-1)),...
        '_',num2str(layer_bounds(ilayer)),'_wod'];
    
end
temp_wod_var_name=[temp_wod_var_name,' '];
    
t_var_name=[];

for ilayer=2:length(layer_bounds)
    
    t_var_name=[t_var_name,' t_',num2str(layer_bounds(ilayer-1)),...
        '_',num2str(layer_bounds(ilayer))];
    
end
t_var_name=[t_var_name,' '];
    
mean_temp_oa_name=[];

for ilayer=2:length(layer_bounds)
    
    mean_temp_oa_name=[mean_temp_oa_name,' mean_temp_oa_',num2str(layer_bounds(ilayer-1)),...
        '_',num2str(layer_bounds(ilayer))];
    
end
mean_temp_oa_name=[mean_temp_oa_name,' '];

tdiffvar_name=[];

for ilayer=2:length(layer_bounds)
    
    tdiffvar_name=[tdiffvar_name,' tdiff',num2str(layer_bounds(ilayer-1)),...
        '_',num2str(layer_bounds(ilayer))];
    
end
tdiffvar_name=[tdiffvar_name,' '];

%%
OcoSetUp.file_path_prof=file_path_prof;
OcoSetUp.file_path=file_path;
OcoSetUp.file_path_out=file_path_out;
OcoSetUp.path_OHCA_data_out=path_OHCA_data_out;
OcoSetUp.file_name=file_name;
OcoSetUp.file_name_mean=file_name_mean;
OcoSetUp.file_path_hdata=file_path_hdata;
OcoSetUp.max_year=max_year;
OcoSetUp.min_year=min_year;
OcoSetUp.file_WOD_suf=file_WOD_suf; 
OcoSetUp.path_EN4_in=path_EN4_in;
OcoSetUp.path_EN4_out=path_EN4_out;
OcoSetUp.file_path_in=file_path_in;

OcoSetUp.max_year_maps=max_year_maps;
OcoSetUp.min_year_maps=min_year_maps;
OcoSetUp.alltemp_extra=alltemp_extra;
OcoSetUp.layer_bounds=layer_bounds;
OcoSetUp.bad_temp_var_name=bad_temp_var_name;
OcoSetUp.ind_var_name=ind_var_name;
OcoSetUp.temp_var_name=temp_var_name;
OcoSetUp.lon_grid_mean=lon_grid_mean;
OcoSetUp.lat_grid_mean=lat_grid_mean;
OcoSetUp.mean_temp_var_name=mean_temp_var_name;
OcoSetUp.temp_anom_var_name=temp_anom_var_name;
OcoSetUp.temp_wod_var_name=temp_wod_var_name;
OcoSetUp.t_var_name=t_var_name;
OcoSetUp.mean_temp_oa_name=mean_temp_oa_name;
OcoSetUp.tdiffvar_name=tdiffvar_name; 
OcoSetUp.file_EN3_type=file_EN3_type;
OcoSetUp.file_name_argo=file_name_argo;
OcoSetUp.min_year_mean=min_year_mean;
OcoSetUp.max_year_mean=max_year_mean;
OcoSetUp.file_name_season=file_name_season;

%% YOU ONLY NEED TO UNCOMMENT THIS SECTION IF YOU HAVEN'T RUN THE NORMAL OLD VERSION FIRST WITH THE SAME file_name AND file_name_argo

% Make the SSH files
'getalltp_oco_realtime_oco_2022_orca_new'
 getalltp_oco_realtime_oco_2022_orca_new(OcoSetUp)
 


% add mean SSH from CMEMS (new Aviso)

'interptpx_argo_mean_oco_WOD_2021_new_layers_seasonal_orca_temp'

interptpx_argo_mean_oco_WOD_2021_new_layers_seasonal_orca_temp(OcoSetUp)
