%% set the path and file names be ware
file_name_data='argo_2023_03_23_QC_press'
path_OHCA_data_out='N:\NCAR\';
path_OHCA_data_in='N:\data\NCAR\';

% Set up the where the model data is located

path_NCAR_SSH=[path_OHCA_data_in,'small_grid\'];
path_NCAR_SST=path_NCAR_SSH;

path_NCAR_SSH_out= [path_OHCA_data_out,'Mtpers\matlab_files\'];
path_oisst=[path_OHCA_data_out,'oisst\'];

path_NCAR_profiles= [path_OHCA_data_in,'profiles\'];


path_NCAR_profile_data='K:\data\NCAR\';
path_NCAR_metadata='D:\grided\t_grided\NCAR\';
file_name_NCAR_metadata=[path_NCAR_metadata,file_name_data,'_temp_NCAR_profile_metadata.mat'];
file_name_NCAR_profiles=[path_NCAR_profile_data,file_name_data,'_temp_NCAR_profile_data.mat'];
dz_file=ncread([path_NCAR_profile_data,'model_grid\NCAR_POP_0158-01-05.nc'],'dz');
load(file_name_NCAR_profiles,'depth')
good_depth=(depth<2000);% take the levels that have a mid point 2000 m or less
depth=depth+.5*dz_file;
depth=depth(good_depth);

file_SST='NCAR_POP_small_';
file_SSH=file_SST;

% Set up nanming for the mapping

file_name='NCAR_POP_small';
file_name_season=[file_name,'_seasonal']
var_type='t'
%layer_bounds=[0,40,90,190,290,450,700,950,1450,1950,2000]% layer_bounds must be in assending order
%layer_bounds=[0,100,300,700,900,1800] % layer_bounds must be in assending order
% % layer_bounds=[0, 5, 15, 25, 35, 45, 55, 65, 75, 85, 95, 105, 115, 125,...
% %     135, 145, 155, 165, 175, 190, 210, 230, 250, 270, 290, 310, 330 , ...
% %     350, 370 , 390, 410,  430, 450, 475, 525, 575, 625, 675, 725, 775,...
% %     825, 875, 925, 975, 1025, 1075, 1125, 1175, 1225, 1275, 1325, 1375,...
% %     1450, 1550, 1650, 1750, 1850, 1950, 2000]% layer_bounds must be in assending order
% layer_bounds=[0,40,90,190,290,450,700,950,1450,1950,2000] % layer_bounds must be in assending order
layer_bounds=round([0,depth']);

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

if ~exist(path_NCAR_SSH_out,'dir')
    mkdir(path_NCAR_SSH_out)
end

if ~exist(path_oisst,'dir')
    mkdir(path_oisst)
end

if ~exist(path_NCAR_profiles,'dir')
    mkdir(path_NCAR_profiles)
end
file_path_in=path_OHCA_data_in;
% I think you can change file_anme_mean if you want to run a diffent mean but not
% 100% sure doubble check
file_name_mean=file_name;
file_path_hdata=[path_OHCA_data_out,var_type,'_maps\'];
if ~exist(file_path_hdata,'dir')
    mkdir(file_path_hdata)
end


file_WOD_suf=[];


%%


% define the varibiles to be saved and read

 temp_var_name=[];

for ilayer=2:length(layer_bounds)
    
    temp_var_name=[temp_var_name,' temp_',num2str(layer_bounds(ilayer-1)),...
        '_',num2str(layer_bounds(ilayer))];
    
end
temp_var_name=[temp_var_name,' '];

t_var_name=[];

for ilayer=2:length(layer_bounds)
    
    t_var_name=[t_var_name,' t_',num2str(layer_bounds(ilayer-1)),...
        '_',num2str(layer_bounds(ilayer))];
    
end
t_var_name=[t_var_name,' '];
%%
OcoSetUp.path_OHCA_data_out=path_OHCA_data_out;
OcoSetUp.path_NCAR_SSH=path_NCAR_SSH;
OcoSetUp.path_NCAR_SST=path_NCAR_SST;

OcoSetUp.path_NCAR_SSH_out= path_NCAR_SSH_out;
OcoSetUp.path_oisst=path_oisst;

OcoSetUp.path_NCAR_profiles=path_NCAR_profiles;
OcoSetUp.path_NCAR_profile_data=path_NCAR_profile_data;
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


OcoSetUp.temp_var_name=temp_var_name;
OcoSetUp.t_var_name=t_var_name;


OcoSetUp.file_name_season=file_name_season;
OcoSetUp.file_name_NCAR_metadata=file_name_NCAR_metadata;
OcoSetUp.file_name_NCAR_profiles=file_name_NCAR_profiles;
%% YOU ONLY NEED TO UNCOMMENT THIS SECTION IF YOU HAVEN'T RUN THE NORMAL OLD VERSION FIRST WITH THE SAME file_name AND file_name_argo

% % % % Make the SSH snd SST files
% % % make_SSH_SST_files_NCAR(OcoSetUp)
% % % 
% % % % Make profile heatcontent files  

% NOT DONE YET!!
make_temp_NCAR(OcoSetUp) %NEED TO GO OVER THIS!!


% add mean SSH from CMEMS (new Aviso)

'interptpx_seasonal_orca_temp_NCAR'

interptpx_seasonal_orca_temp_NCAR(OcoSetUp)
