%% set the path and file names be ware

path_OHCA_data_out='D:\ME4OH\';
path_OHCA_data_in='D:\ME4OH\';

% Set up the where the model data is located

path_ME4OH_SSH=[path_OHCA_data_in,'data\ofam3\sfc\'];
path_ME4OH_SST=path_ME4OH_SSH;

path_ME4OH_SSH_out= [path_OHCA_data_out,'Mtpers\matlab_files\'];
path_oisst=[path_OHCA_data_out,'oisst\'];

path_ME4OH_profiles= [path_OHCA_data_in,'data\en4.1.1\1979-2014\full\update\'];


file_SST='temp_ofam3_7d_197901-201412.0p25x0p25.nc';
file_SSH='etat_ofam3_7d_197901-201412.0p25x0p25.nc';

% Set up nanming for the mapping

file_name='ofam3_EN4';
file_name_season=[file_name,'_seasonal']
var_type='h'
%layer_bounds=[0,40,90,190,290,450,700,950,1450,1950,2000]% layer_bounds must be in assending order
%layer_bounds=[0,100,300,700,900,1800] % layer_bounds must be in assending order
% layer_bounds=[0, 5, 15, 25, 35, 45, 55, 65, 75, 85, 95, 105, 115, 125,...
%     135, 145, 155, 165, 175, 190, 210, 230, 250, 270, 290, 310, 330 , ...
%     350, 370 , 390, 410,  430, 450, 475, 525, 575, 625, 675, 725, 775,...
%     825, 875, 925, 975, 1025, 1075, 1125, 1175, 1225, 1275, 1325, 1375,...
%     1450, 1550, 1650, 1750, 1850, 1950, 2000]% layer_bounds must be in assending order
layer_bounds=[0,40,90,190,290,450,700,950,1450,1950,2000] % layer_bounds must be in assending order

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

if ~exist(path_ME4OH_SSH_out,'dir')
    mkdir(path_ME4OH_SSH_out)
end

if ~exist(path_oisst,'dir')
    mkdir(path_oisst)
end

if ~exist(path_ME4OH_profiles,'dir')
    mkdir(path_ME4OH_profiles)
end
file_path_in=path_OHCA_data_in;
% I think you can change file_anme_mean if you want to run a diffent mean but not
% 100% sure doubble check
file_name_mean=file_name;
file_path_hdata=[path_OHCA_data_out,var_type,'_maps\'];
if ~exist(file_path_hdata,'dir')
    mkdir(file_path_hdata)
end


file_WOD_suf=['mask'];


%%


% define the varibiles to be saved and read

    
h_var_name=[];

for ilayer=2:length(layer_bounds)
    
    h_var_name=[h_var_name,' h_',num2str(layer_bounds(ilayer-1)),...
        '_',num2str(layer_bounds(ilayer))];
    
end
h_var_name=[h_var_name,' '];
    
%%
OcoSetUp.path_OHCA_data_out=path_OHCA_data_out;
OcoSetUp.path_ME4OH_SSH=path_ME4OH_SSH;
OcoSetUp.path_ME4OH_SST=path_ME4OH_SST;

OcoSetUp.path_ME4OH_SSH_out= path_ME4OH_SSH_out;
OcoSetUp.path_oisst=path_oisst;

OcoSetUp.path_ME4OH_profiles=path_ME4OH_profiles;

OcoSetUp.file_SST=file_SST;
OcoSetUp.file_SSH=file_SSH;
OcoSetUp.file_path_prof=file_path_prof;
OcoSetUp.file_path=file_path;
OcoSetUp.file_path_out=file_path_out;

OcoSetUp.file_name=file_name;
OcoSetUp.file_name_mean=file_name_mean;
OcoSetUp.file_path_hdata=file_path_hdata;
OcoSetUp.file_WOD_suf=file_WOD_suf; 

OcoSetUp.file_path_in=file_path_in;


OcoSetUp.layer_bounds=layer_bounds;


OcoSetUp.h_var_name=h_var_name;

OcoSetUp.file_name_season=file_name_season;

%% YOU ONLY NEED TO UNCOMMENT THIS SECTION IF YOU HAVEN'T RUN THE NORMAL OLD VERSION FIRST WITH THE SAME file_name AND file_name_argo

% Make the SSH snd SST files
% % % make_SSH_SST_files_ME4OH(OcoSetUp)

% Make profile heatcontent files


make_heat_ME4OH_extra(OcoSetUp) %NEED TO GO OVER THIS!!


% add mean SSH from CMEMS (new Aviso)

'interptpx_argo_mean_oco_WOD_2021_new_layers_seasonal_orca_temp'

interptpx_seasonal_orca_heat_ME4OH(OcoSetUp)
