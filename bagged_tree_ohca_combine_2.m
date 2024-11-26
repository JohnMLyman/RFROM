% function []=bagged_tree_ohca_combine_split(TreeSetUp)
% 
% load_TreeSetUp
% 








tree_model_file_name_old='tree_sst_tpx_yearly_overlap_seasonal';
tree_model_file_name_yearly=[tree_model_file_name_old,'_anom'];
tree_model_file_name_all_years=['tree_sst_tpx_all_year_seasonal_anom'];
tree_model_file_name_combined=['tree_sst_tpx_combined_seasonal_anom'];

path_OHCA_data_out='C:\data\OHCA\'
path_OHCA_data_in='C:\OHCA\'

 layer_bounds=[0,40,90,190,290,450,700,950,1450,1950,2000];
% file_name='argo_2020_10_14_QC';
path_tree=[path_OHCA_data_out,'OHCA_trees\'];

file_path_out=[path_OHCA_data_out,'OHCA_grided\'];
path_ssh=[path_OHCA_data_in,'Mtpers\'];
nlayers=length(layer_bounds);



start_year_trans=2006;
end_year_trans=2007;
delta_trans=end_year_trans-start_year_trans+1;

ilayer=2;
layer_name=[num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer))];
tree_file_name_all_year=[tree_model_file_name_all_years,'_',layer_name];
load([path_tree,tree_file_name_all_year,'_7day.mat'], 'lon_tpx' ,'lat_tpx','time_aviso')
nlon_tpx=length(lon_tpx);
nlat_tpx=length(lat_tpx);
ntime_tpx=length(time_aviso);
TIME=[];
TIME(1,1,:)=time_aviso;
TIME=repmat(TIME,nlon_tpx,nlat_tpx,1);

OVERLAP_ALL_YEAR=TIME>=start_year_trans & TIME<=(end_year_trans+1);
KEEP_ALL_YEARS=TIME<start_year_trans;
time_aviso_all_year=...
    [time_aviso(time_aviso<start_year_trans),...
    time_aviso(time_aviso>=start_year_trans & time_aviso<=(end_year_trans+1))];


SCALE_ALL_YEARS=(start_year_trans-TIME(OVERLAP_ALL_YEAR)+delta_trans)./(delta_trans);

tree_file_name_yearly=[tree_model_file_name_yearly,'_',layer_name];
load([path_tree,tree_file_name_yearly,'_7day.mat'], 'lon_tpx' ,'lat_tpx','time_aviso')

TIME=[];
TIME(1,1,:)=time_aviso;
TIME=repmat(TIME,nlon_tpx,nlat_tpx,1);
OVERLAP_YEARLY=TIME>=start_year_trans & TIME<=(end_year_trans+1);
KEEP_YEARLY=TIME>end_year_trans+1;


SCALE_YEARLY=(TIME(OVERLAP_YEARLY)-start_year_trans)./(delta_trans);
time_aviso=[time_aviso_all_year,time_aviso(time_aviso>end_year_trans+1)];
TIME=[];
TIME(1,1,:)=time_aviso;
TIME=repmat(TIME,nlon_tpx,nlat_tpx,1);
OVERLAP=TIME>=start_year_trans & TIME<=(end_year_trans+1);
KEEP_YEARLY_BIG=TIME>end_year_trans+1;
KEEP_ALL_YEARS_BIG=TIME<start_year_trans;
ntime_total=length(time_aviso);

clearvars time_aviso_all_year TIME
tic
for ilayer=2:nlayers
   
    layer_name=[num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer))]
   
    tree_file_name_yearly=[tree_model_file_name_yearly,'_',layer_name];
    tree_file_name_all_year=[tree_model_file_name_all_years,'_',layer_name];
    tree_file_name_combined=[tree_model_file_name_combined,'_',layer_name];
    ht_out=nans(nlon_tpx,nlat_tpx,ntime_total);

    load([path_tree,tree_file_name_yearly,'_7day.mat'], 'ht_estimate')
    ht_overlap_yearly=ht_estimate(OVERLAP_YEARLY).*SCALE_YEARLY;
    ht_out(KEEP_YEARLY_BIG)=ht_estimate(KEEP_YEARLY);
    
    clearvars ht_estiamte
    load([path_tree,tree_file_name_all_year,'_7day.mat'], 'ht_estimate')
    ht_overlap_all_year=ht_estimate(OVERLAP_ALL_YEAR).*SCALE_ALL_YEARS;
    
    ht_overlap=nans(length(ht_overlap_all_year),1);
    pos_use=isfinite(ht_overlap_yearly)|isfinite(ht_overlap_all_year);

    ht_overlap(pos_use)=sum(cat(2,ht_overlap_yearly(pos_use),ht_overlap_all_year(pos_use)),2,'omitnan');

    ht_out(KEEP_ALL_YEARS_BIG)=ht_estimate(KEEP_ALL_YEARS);
    ht_out(OVERLAP)=ht_overlap;
    ht_estimate=ht_out;
    save([path_tree,tree_file_name_combined,'_2_7day.mat'],'ht_estimate','time_aviso','lon_tpx','lat_tpx','-v7.3')

    

  

  
   toc./60

end




