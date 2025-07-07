OcoSetUp=make_OcoSetUp_heat_2025_mid;

%% YOU ONLY NEED TO UNCOMMENT THIS SECTION IF YOU HAVEN'T RUN THE NORMAL OLD VERSION FIRST WITH THE SAME file_name AND file_name_argo


% Make the SSH files
'getalltp_oco_realtime_oco_2022_orca_new'
 getalltp_oco_realtime_oco_2024_orca_new(OcoSetUp)
 
% % % % make fiels for gregs deep profiles
% % % 
% % %  getprofiles_greg_QC_oco_orca_new_temp_12_psal_123(OcoSetUp)
% % %  getprofiles_greg_QC_oco_orca_new_temp_all(OcoSetUp)
% Make the argo float filedata
'getprofiles_greg_QC_oco_orca_new'
  getprofiles_greg_QC_oco_orca_new(OcoSetUp)

%%
%% This section makes the heat files 

%Make the depth grided heaterature files for Argo 
'pfloat_heat_oco_itp_TEOS10_new_layers_1_orca_new'
 
pfloat_heat_oco_itp_TEOS10_new_layers_1_ocra_new(OcoSetUp)

% QC the argo data temperature on depth levels
'qc_argo_temp_oco_new_layers_1_orca_new'
qc_argo_heat_oco_new_layers_1_orca_new(OcoSetUp) 
   
% Make EN4 files (I know the code is called En3 :) depth grided temperature
%   files
'getwod_heat_oco_EN3_teos10_new_layers_1_orca'
getwod_heat_oco_EN3_teos10_new_layers_1_orca_new(OcoSetUp)



% Remove bad argo profiles

'argo_remove_bad_profiles_layers_seasonal_orca_heat'

argo_remove_bad_profiles_layers_seasonal_orca_heat(OcoSetUp)


% combine EN4 and Argo
'bin_EN4_2021_new_layers_orca_seasonal_heat(OcoSetUp)'
bin_EN4_2021_new_layers_orca_seasonal_heat(OcoSetUp)

% add mean SSH from CMEMS (new Aviso)

'interptpx_argo_mean_oco_WOD_2021_new_layers_seasonal_orca_heat'

interptpx_argo_mean_oco_WOD_2021_new_layers_seasonal_orca_heat(OcoSetUp)
% make file form that works with 

'mapdiff_argo_mean_oco_EN4_2021_new_layers_seasonal_orca_heat'

mapdiff_argo_mean_oco_EN4_2021_new_layers_seasonal_orca_heat(OcoSetUp)
