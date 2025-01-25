OcoSetUp=make_OcoSetUp_sal_2025
%%
%% This section makes the temp files 

% % % % Make the depth grided temperature files for Argo 
% % % 'pfloat_sal_oco_itp_TEOS10_new_layers_1_orca_new'
% % %  
% % %  pfloat_sal_oco_itp_TEOS10_new_layers_1_ocra_new(OcoSetUp)
% % % 
% % % % QC the argo data temperature on depth levels
% % % 'qc_argo_sal_oco_new_layers_1_orca_new'
% % %     qc_argo_sal_oco_new_layers_1_orca_new(OcoSetUp) 
% % %    
% % % % Make EN4 files (I know the code is called En3 :) depth grided temperature
% % % %   files
% % % 'getwod_sal_oco_EN3_teos10_new_layers_1_orca'
% % % getwod_sal_oco_EN3_teos10_new_layers_1_orca_new(OcoSetUp)
% % % 
% % % 
% % % 
% % % % Remove bad argo profiles
% % % 
% % % 'argo_remove_bad_profiles_layers_seasonal_orca_sal'
% % % 
% % % argo_remove_bad_profiles_layers_seasonal_orca_sal(OcoSetUp)
% % 
% % 
% % % combine EN4 and Argo
% % 'bin_EN4_2021_new_layers_orca_seasonal_sal'
% % bin_EN4_2021_new_layers_orca_seasonal_sal(OcoSetUp)

% add mean SSH from CMEMS (new Aviso)

'interptpx_argo_mean_oco_WOD_2021_new_layers_seasonal_orca_sal'
interptpx_argo_mean_oco_WOD_2021_new_layers_seasonal_orca_sal(OcoSetUp)



% make file form that works with 

'mapdiff_argo_mean_oco_EN4_2021_new_layers_seasonal_orca_sal'

mapdiff_argo_mean_oco_EN4_2021_new_layers_seasonal_orca_sal(OcoSetUp)

'mapdiff_seasonal_orca_sal_topo_deep'
mapdiff_seasonal_orca_sal_topo_deep(OcoSetUp)
