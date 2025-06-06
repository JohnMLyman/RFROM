OcoSetUp=make_OcoSetUp_predictors_Sockeye;

%% YOU ONLY NEED TO UNCOMMENT THIS SECTION IF YOU HAVEN'T RUN THE NORMAL OLD VERSION FIRST WITH THE SAME file_name AND file_name_argo


% Make the SSH files
'getalltp_oco_realtime_oco_2022_orca_new'
 getalltp_oco_realtime_oco_2024_orca_new(OcoSetUp)


'getprofiles_greg_QC_oco_orca_new'
  getprofiles_greg_QC_oco_orca_new(OcoSetUp)

%%
%% This section makes the heat files 

%Make the depth grided heaterature files for Argo 
'pfloat_heat_oco_itp_TEOS10_new_layers_1_orca_new'
 
