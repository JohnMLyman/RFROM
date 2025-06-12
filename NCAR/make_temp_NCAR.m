function []=make_temp_NCAR(OcoSetUp)


layer_bounds=OcoSetUp.layer_bounds;

temp_var_name=OcoSetUp.temp_var_name;
file_name_season=OcoSetUp.file_name_season;
file_path_hdata=OcoSetUp.file_path_hdata;
file_WOD_suf=OcoSetUp.file_WOD_suf;
path_NCAR_profile_data=OcoSetUp.path_NCAR_profile_data;
file_name_NCAR_metadata=OcoSetUp.file_name_NCAR_metadata;
file_name_NCAR_profiles=OcoSetUp.file_name_NCAR_profiles;

fname_nc=[file_path_hdata,'tdata_new_layers_',file_WOD_suf,'_',file_name_season];

dz_file=ncread([path_NCAR_profile_data,'model_grid\NCAR_POP_0158-01-05.nc'],'dz');
load(file_name_NCAR_profiles,'yr_ncar','ptemp_prof_ncar','coords_ncar_prof')
load(file_name_NCAR_metadata,'max_depth_ncar_prof')

good=isfinite(yr_ncar);
yr_ncar=yr_ncar(good);
ptemp_prof_ncar=ptemp_prof_ncar(good,:);
% sal_prof_ncar=sal_prof_ncar(good,:);
coords_ncar_prof=coords_ncar_prof(good,:);
max_depth_ncar_prof=max_depth_ncar_prof(good);



yr=yr_ncar;
coords=coords_ncar_prof;
clear yr_ncar coords_ncar_prof
% find total_number of profiles
nprof=length(yr);








for ilayer=2:length(layer_bounds)
    temp_junk=nans(nprof,1);
    good=max_depth_ncar_prof>layer_bounds(ilayer);

   
    temp_junk(good)=ptemp_prof_ncar(good,ilayer-1);    
    eval(['temp_',num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer)),'=temp_junk;'])
    
end


eval(['save ',fname_nc,' yr coords ',temp_var_name])