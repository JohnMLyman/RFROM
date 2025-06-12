function []=make_heat_NCAR(OcoSetUp)


layer_bounds=OcoSetUp.layer_bounds;
layer_bounds_NCAR=OcoSetUp.layer_bounds_NCAR;

h_var_name=OcoSetUp.h_var_name;
file_name_season=OcoSetUp.file_name_season;
file_path_hdata=OcoSetUp.file_path_hdata;
file_WOD_suf=OcoSetUp.file_WOD_suf;


path_NCAR_profile_data=OcoSetUp.path_NCAR_profile_data;
file_name_NCAR_metadata=OcoSetUp.file_name_NCAR_metadata;
file_name_NCAR_profiles=OcoSetUp.file_name_NCAR_profiles;

fname_nc=[file_path_hdata,'hdata_new_layers_',file_WOD_suf,'_',file_name_season];


load(file_name_NCAR_profiles,'yr_ncar','ptemp_prof_ncar','sal_prof_ncar','coords_ncar_prof')
load(file_name_NCAR_metadata,'max_depth_ncar_prof')

good=isfinite(yr_ncar);
yr_ncar=yr_ncar(good);
ptemp_prof_ncar=ptemp_prof_ncar(good,:);
sal_prof_ncar=sal_prof_ncar(good,:);
coords_ncar_prof=coords_ncar_prof(good,:);
max_depth_ncar_prof=max_depth_ncar_prof(good);


yr=yr_ncar;
coords=coords_ncar_prof;
clear yr_ncar coords_ncar_prof
% find total_number of profiles
nprof=length(yr);


dz_file=ncread([path_NCAR_profile_data,'model_grid\NCAR_POP_0158-01-05.nc'],'dz');
load(file_name_NCAR_profiles,'depth')

depth=depth+.5*dz_file;

ndepth=length(depth);
layer_bounds_NCAR=round([0,depth']);
depth_big=repmat(depth',[nprof 1]);
lon_big=repmat(coords(:,1),[1 ndepth]);
lat_big=repmat(coords(:,2),[1 ndepth]);
pres= gsw_p_from_z(-1.*depth_big,lat_big);

[SA, ~] = gsw_SA_from_SP(sal_prof_ncar,pres,lon_big,lat_big);
CT=gsw_CT_from_pt(SA,ptemp_prof_ncar);
       
heat= gsw_rho(SA,CT,pres).*gsw_cp0.*CT.*dz_file';

for ilayer=2:length(layer_bounds_NCAR)
    good=max_depth_ncar_prof>layer_bounds_NCAR(ilayer-1);
    heat(~good,ilayer-1)=nan;

end

layer_bounds_NCAR_out=layer_bounds;

start_ind=1;

for ilayer=2:length(layer_bounds)
    
    diff_bounds=abs(layer_bounds_NCAR-layer_bounds(ilayer));
    [~,end_ind]=min(diff_bounds);
    end_ind=end_ind-1;
    good_depth=start_ind:end_ind;
    

    
    heat_junk=sum(heat(:,good_depth),2);
    
    layer_bounds_NCAR_out(ilayer)=layer_bounds_NCAR(end_ind+1);
      
    eval(['h_',num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer)),'=heat_junk;'])
    
    start_ind=end_ind+1;
end


eval(['save ',fname_nc,' yr coords layer_bounds_NCAR_out ',h_var_name])