function []=make_ME4OH_files(TreeSetUp)

% MUST MAKE NETCDF WITH MEAN FIRST!!!!!

nbasins_use=TreeSetUp.nbasins_use;
file_name=TreeSetUp.file_name;
var_type=TreeSetUp.var_type;

file_name_season=TreeSetUp.file_name_season;
file_name_season_anom=TreeSetUp.file_name_season_anom;
file_WOD_suf=TreeSetUp.file_WOD_suf;
file_path_hdata=TreeSetUp.file_path_hdata;
fname_nc_season=TreeSetUp.fname_nc_season;
fname_nc=TreeSetUp.fname_nc;

path_ERDDAP=TreeSetUp.path_ERDDAP;


tree_prefix=TreeSetUp.tree_prefix;
tree_model_file_name_season=TreeSetUp.tree_model_file_name_season;
tree_model_file_name_yearly=TreeSetUp.tree_model_file_name_yearly;
tree_model_file_name_all_year=TreeSetUp.tree_model_file_name_all_year;
tree_model_file_name_combined=TreeSetUp.tree_model_file_name_combined;
tree_model_file_name_combined_withcycle=TreeSetUp.tree_model_file_name_combined_withcycle;

% 
% file_name_season=[file_name,'_seasonal'];
% file_name_season_anom=[file_name_season,'_anom'];

path_oisst=TreeSetUp.path_oisst;
path_OHCA_data_out=TreeSetUp.path_OHCA_data_out;
path_OHCA_data_in=TreeSetUp.path_OHCA_data_in;
path_ssh=TreeSetUp.path_ssh;

path_tree=TreeSetUp.path_tree;
path_new_tree_season=TreeSetUp.path_new_tree_season;
path_new_tree_yearly=TreeSetUp.path_new_tree_yearly;
path_new_tree_all_year=TreeSetUp.path_new_tree_all_year;
path_new_tree_combined=TreeSetUp.path_new_tree_combined;
path_new_tree_combined_withcycle=TreeSetUp.path_new_tree_combined_withcycle;


path_tree_junk=TreeSetUp.path_tree_junk;
path_curve=TreeSetUp.path_curve;

layer_bounds=TreeSetUp.layer_bounds;

start_year=TreeSetUp.start_year;
end_year=TreeSetUp.end_year;

start_year_mean=TreeSetUp.start_year_mean;
end_year_mean=TreeSetUp.end_year_mean;
max_year_fit=TreeSetUp.max_year_fit;
min_year_fit=TreeSetUp.min_year_fit;
center_year=TreeSetUp.center_year;

start_yearly_maps=TreeSetUp.start_yearly_maps;
end_yearly_maps=TreeSetUp.end_yearly_maps;

start_all_year=TreeSetUp.start_all_year;
end_all_year=TreeSetUp.end_all_year;

start_year_trans=TreeSetUp.start_year_trans;
end_year_trans=TreeSetUp.end_year_trans;
start_year_mean_remove=TreeSetUp.start_year_mean_remove;
end_year_mean_remove=TreeSetUp.end_year_mean_remove;


L1_ind1=TreeSetUp.L1_ind1;
L1_ind2=TreeSetUp.L1_ind2;

L2_ind1=TreeSetUp.L2_ind1;
L2_ind2=TreeSetUp.L2_ind2;

L3_ind1=TreeSetUp.L3_ind1;
L3_ind2=TreeSetUp.L3_ind2;

load([file_path_hdata,'layer_bounds_ME4OH_out.mat'],'layer_bounds_ME4OH_out')

mean_depth_bnds_layer_L1=[layer_bounds_ME4OH_out(L1_ind1),layer_bounds_ME4OH_out(L1_ind2)]';
mean_depth_layer_L1=mean(mean_depth_bnds_layer_L1);

mean_depth_bnds_layer_L2=[layer_bounds_ME4OH_out(L2_ind1),layer_bounds_ME4OH_out(L2_ind2)]';
mean_depth_layer_L2=mean(mean_depth_bnds_layer_L2);

mean_depth_bnds_layer_L3=[layer_bounds_ME4OH_out(L3_ind1),layer_bounds_ME4OH_out(L3_ind2)]';
mean_depth_layer_L3=mean(mean_depth_bnds_layer_L3);
%%
% tree_model=[tree_model_file_name_yearly,'_withcycle'];
% path_new_tree=[path_new_tree_yearly,'withcycle/'];

subdir='yearly_withcycle_no_mean';
start_year_file=start_year;
end_year_file=end_year;
path_new_tree=path_new_tree_combined_withcycle;
tree_model=tree_model_file_name_combined_withcycle;
% tree_file_name=tree_file_name_in;
%%

path_nc_erddap=[path_ERDDAP,'netcdf\',tree_prefix,'\',subdir,'\'];
path_nc_erddap_ME4OH=[path_nc_erddap,'\ME4OH\'];
file_name_L1=[path_nc_erddap_ME4OH,'OHC_1993_2014_lev0_286.6_expRFROM.nc']; 
file_name_L2=[path_nc_erddap_ME4OH,'OHC_1993_2014_lev286.6_685.9_expRFROM.nc'];
file_name_L3=[path_nc_erddap_ME4OH,'OHC_1993_2014_lev685.9_1985.3_expRFROM.nc'];



if var_type=='s'
     file_prefix='RFROM_SAL_';
elseif var_type=='t'
     file_prefix='RFROM_TEMP_';
elseif var_type=='h'
     file_prefix='RFROM_OHC_';
end

if ~exist(path_nc_erddap_ME4OH,'dir')
    mkdir(path_nc_erddap_ME4OH)
end

% because the data is geroup by year if the start year is a whole number
% then the files will start in the pervious year
start_year_ssh=floor(start_year_file);
if floor(start_year_file)==start_year_file
    start_year_ssh=start_year_file-1;
end
end_year_ssh=floor(end_year_file);
time_ssh_load=start_year_ssh:end_year_ssh;




%%
nt=(end_year_ssh-start_year_ssh+1).*12;
ohc_L1=nan(360,180,nt);
ohc_L2=ohc_L1;
ohc_L3=ohc_L1;
time_out=nan(1,nt);
n_Ln=ones(4,360,4,180);
itime=0;
for year_load=time_ssh_load

    
  
    
    for imonth=1:12
        

        itime=itime+1;

            



            if imonth>=10
                  file_name_nc= [path_nc_erddap,file_prefix,num2str(year_load),'_',num2str(imonth),'.nc'];
               else
                  file_name_nc= [path_nc_erddap,file_prefix,num2str(year_load),'_0',num2str(imonth),'.nc'];
            end
            if var_type =='t'
                break ;'NOT WRITTEN FOR TEMPERATURE'
         
                 
            elseif var_type=='s'
                break ;'NOT WRITTEN FOR SALINITY'

            elseif var_type=='h'
                ohc=ncread(file_name_nc,'ocean_heat_content_anomaly');
                lon=ncread(file_name_nc,'longitude');
                lat=ncread(file_name_nc,'latitude');
                time_junk=ncread(file_name_nc,'time');

                % sumup the heat in each layer
                ohc_L1_junk=squeeze(jnansum(ohc(:,:,L1_ind1:L1_ind2,:),3));
                ohc_L2_junk=squeeze(jnansum(ohc(:,:,L2_ind1:L2_ind2,:),3));
                ohc_L3_junk=squeeze(jnansum(ohc(:,:,L3_ind1:L3_ind2,:),3));

                % take the monthly mean
                ohc_L1_junk=squeeze(mean(ohc_L1_junk,3,'omitnan'));
                ohc_L2_junk=squeeze(mean(ohc_L2_junk,3,'omitnan'));
                ohc_L3_junk=squeeze(mean(ohc_L3_junk,3,'omitnan'));


                lon_out=(sum(reshape(lon,4,360),1)./4)';
                lat_out=(sum(reshape(lat,4,180),1)./4)';
                time_out(itime)=mean(time_junk);

                lon_mov=lon_out<20.5;
                lon_out=[lon_out(~lon_mov);lon_out(lon_mov)+360];


                
                % regrid 1/4 x 1/4 to a 1x1 grid by using a 1 degree box
                % car

                ohc_L1_junk= reshape(ohc_L1_junk,4,360,4,180);
                n_L1=n_Ln;
                n_L1(~isfinite(ohc_L1_junk))=0;
                ohc_L1_junk=sum(sum(ohc_L1_junk,1,'omitnan'),3,'omitnan');
                n_L1=sum(sum(n_L1,1,'omitnan'),3,'omitnan');
                ohc_L1_junk=reshape(ohc_L1_junk./n_L1,360,180);
                ohc_L1_junk=[ohc_L1_junk(~lon_mov,:);ohc_L1_junk(lon_mov,:)];
                ohc_L1(:,:,itime)=ohc_L1_junk;

                ohc_L2_junk= reshape(ohc_L2_junk,4,360,4,180);
                n_L2=n_Ln;
                n_L2(~isfinite(ohc_L2_junk))=0;
                ohc_L2_junk=sum(sum(ohc_L2_junk,1,'omitnan'),3,'omitnan');
                n_L2=sum(sum(n_L2,1,'omitnan'),3,'omitnan');
                ohc_L2_junk=reshape(ohc_L2_junk./n_L2,360,180);
                ohc_L2_junk=[ohc_L2_junk(~lon_mov,:);ohc_L2_junk(lon_mov,:)];
                ohc_L2(:,:,itime)=ohc_L2_junk;


                ohc_L3_junk= reshape(ohc_L3_junk,4,360,4,180);
                n_L3=n_Ln;
                n_L3(~isfinite(ohc_L3_junk))=0;
                ohc_L3_junk=sum(sum(ohc_L3_junk,1,'omitnan'),3,'omitnan');
                n_L3=sum(sum(n_L3,1,'omitnan'),3,'omitnan');
                ohc_L3_junk=reshape(ohc_L3_junk./n_L3,360,180);
                ohc_L3_junk=[ohc_L3_junk(~lon_mov,:);ohc_L3_junk(lon_mov,:)];
                ohc_L3(:,:,itime)=ohc_L3_junk;
            end
    end
end
       
    



write_netcfd_cf_heat_ME4OH_file(ohc_L1,time_out,lon_out,...
    lat_out,mean_depth_layer_L1,mean_depth_bnds_layer_L1,start_year_mean_remove,...
    end_year_mean_remove,file_name_L1)

write_netcfd_cf_heat_ME4OH_file(ohc_L2,time_out,lon_out,...
    lat_out,mean_depth_layer_L2,mean_depth_bnds_layer_L2,start_year_mean_remove,...
                   end_year_mean_remove,file_name_L2)

write_netcfd_cf_heat_ME4OH_file(ohc_L3,time_out,lon_out,...
    lat_out,mean_depth_layer_L3,mean_depth_bnds_layer_L3,start_year_mean_remove,...
                   end_year_mean_remove,file_name_L3)


