OcoSetUp=make_OcoSetUp_temp_sockeye_2025;
%% YOU ONLY NEED TO UNCOMMENT THIS SECTION IF YOU HAVEN'T RUN THE NORMAL OLD VERSION FIRST WITH THE SAME file_name AND file_name_argo


% Make the depth grided temperature files for Argo 
'pfloat_temp_oco_itp_TEOS10_new_layers_1_orca_new'

 pfloat_temp_oco_itp_TEOS10_new_layers_1_ocra_new(OcoSetUp)

% QC the argo data temperature on depth levels
'qc_argo_temp_oco_new_layers_1_orca_new'
qc_argo_temp_oco_new_layers_1_orca_new(OcoSetUp) 

% % % Make EN4 files (I know the code is called En3 :) depth grided temperature
% % %   files
'getwod_temp_oco_EN3_teos10_new_layers_1_orca'
getwod_temp_oco_EN3_teos10_new_layers_1_orca_new(OcoSetUp)



% Remove bad argo profiles

'argo_remove_bad_profiles_layers_seasonal_orca_temp'

argo_remove_bad_profiles_layers_seasonal_orca_temp(OcoSetUp)


% combine EN4 and Argo
'bin_EN4_2021_new_layers_orca_seasonal_temp(OcoSetUp)'
bin_EN4_2021_new_layers_orca_seasonal_temp(OcoSetUp)

% add mean SSH from CMEMS (new Aviso)

'interptpx_argo_mean_oco_WOD_2021_new_layers_seasonal_orca_temp'
interptpx_argo_mean_oco_WOD_2021_new_layers_seasonal_orca_temp(OcoSetUp)



% make file form that works with 

'mapdiff_argo_mean_oco_EN4_2021_new_layers_seasonal_orca_temp'

mapdiff_argo_mean_oco_EN4_2021_new_layers_seasonal_orca_temp(OcoSetUp)
