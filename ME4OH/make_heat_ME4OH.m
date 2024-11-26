function []=make_heat_ME4OH(OcoSetUp)


layer_bounds=OcoSetUp.layer_bounds;
path_ME4OH_profiles=OcoSetUp.path_ME4OH_profiles;
h_var_name=OcoSetUp.h_var_name;
file_name_season=OcoSetUp.file_name_season;
file_path_hdata=OcoSetUp.file_path_hdata;
file_WOD_suf=OcoSetUp.file_WOD_suf;
fname_nc=[file_path_hdata,'hdata_new_layers_',file_WOD_suf,'_',file_name_season];

good_files=dir([path_ME4OH_profiles,'ofam3-jra55.all.EN.4.1.1.f.profiles.g10.*.update.nc']);


nfiles=length(good_files);

% find total_number of profiles
nprof=0;
for ifile=1:nfiles
    file=[good_files(ifile).folder,'\',good_files(ifile).name];
    temp=ncread(file,'temp')';
    s_temp=size(temp);
    nprof=nprof+s_temp(1);
end

coords=nan(nprof,2);
dt=nan(nprof,3);
dohc=nan(nprof,s_temp(2));

start_ind=1;

for ifile=1:nfiles
    file=[good_files(ifile).folder,'\',good_files(ifile).name]
    [jdohc,~,dz,jlon,jlat,jdt]=read_profiles_ME4OH(file);
    jnprof=length(jlon);
%     figure(1)
%     pcolor([1:jnprof],-1.*depth,jdohc')
%     shading flat
%     figure(2)
%     plot(jlon,jlat,'.')
    % make sure the 
    jlon(jlon>180)=jlon(jlon>180)-360;

    end_ind=start_ind+jnprof-1;
    coords(start_ind:end_ind,1)=jlon;
    coords(start_ind:end_ind,2)=jlat;
    dt(start_ind:end_ind,:)=jdt;
    dohc(start_ind:end_ind,:)=jdohc;
    start_ind=end_ind+1;
end

layer_bounds_ME4OH=cumsum(dz);
layer_bounds_ME4OH_out=layer_bounds;
start_ind=1;
for ilayer=2:length(layer_bounds)
    diff_bounds=abs(layer_bounds_ME4OH-layer_bounds(ilayer));
%     diff_bounds(diff_bounds<0)=max(diff_bounds);
    [~,end_ind]=min(diff_bounds);
    good=start_ind:end_ind;
    layer_bounds(ilayer)
    layer_bounds_ME4OH(good)'
    layer_bounds_ME4OH_out(ilayer)=layer_bounds_ME4OH(end_ind);

   
    heat_junk=sum(dohc(:,good),2); % Km(kg/m^3)(J/kg C)/10^12 = TJ/m^2
    eval(['h_',num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer)),'=heat_junk;'])
    
    start_ind=end_ind+1;
end

save([file_path_hdata,'layer_bounds_ME4OH_out.mat'],'layer_bounds_ME4OH_out')
eval(['save ',fname_nc,' dt coords ',h_var_name])