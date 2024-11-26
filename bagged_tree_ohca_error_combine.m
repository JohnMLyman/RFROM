




tree_model_file_name_old='tree_sst_tpx_yearly_overlap_seasonal';
tree_model_file_name_yearly=[tree_model_file_name_old,'_anom'];
tree_model_file_name_all_years=['tree_sst_tpx_all_year_seasonal_anom'];
tree_model_file_name_combined=['tree_sst_tpx_combined_seasonal_anom'];

path_OHCA_data_out='C:\data\OHCA\'
path_OHCA_data_in='C:\OHCA\'

 layer_bounds=[0,40,90,190,290,450,700,950,1450,1950,2000];
% file_name='argo_2020_10_14_QC';
path_tree=[path_OHCA_data_out,'OHCA_trees\'];

file_path_out=[path_OHCA_data_out,'OHCA_grided\'];e
path_ssh=[path_OHCA_data_in,'Mtpers\'];
nlayers=length(layer_bounds);



start_year_trans=2006;
end_year_trans=2007;
delta_trans=end_year_trans-start_year_trans+1;

ilayer=2;
layer_name=[num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer))];

tree_file_name_all_years_error=[tree_model_file_name_all_years,'_error_',layer_name];

load([path_tree,tree_file_name_all_years_error,'_2xweight_7day.mat'], ...
     'scale_total','scale_total_median','lon_tpx', 'lat_tpx', 'time_aviso')
nlon_tpx=length(lon_tpx);
nlat_tpx=length(lat_tpx);
ntime_tpx=length(time_aviso);
TIME=[];
TIME(1,1,:)=time_aviso;
time2(1,:)=time_aviso;
TIME=repmat(TIME,nlon_tpx,nlat_tpx,1);
time2=repmat(time2,10,1);
SCALE_ALL_YEARS=ones(nlon_tpx,nlat_tpx,ntime_tpx);
scale_all_years2=ones(10,ntime_tpx);
OVERLAP=TIME>=start_year_trans & TIME<=(end_year_trans+1);
overlap2=time2>=start_year_trans & time2<=(end_year_trans+1);
SCALE_YEARLY=SCALE_ALL_YEARS;
scale_yearly2=scale_all_years2;
SCALE_ALL_YEARS(OVERLAP)=(start_year_trans-TIME(OVERLAP)+delta_trans)./(delta_trans);
scale_all_years2(overlap2)=(start_year_trans-time2(overlap2)+delta_trans)./(delta_trans);
SCALE_ALL_YEARS(TIME>end_year_trans+1)=0;
scale_all_years2(time2>end_year_trans+1)=0;
SCALE_YEARLY(OVERLAP)=(TIME(OVERLAP)-start_year_trans)./(delta_trans);
scale_yearly2(overlap2)=(time2(overlap2)-start_year_trans)./(delta_trans);
SCALE_YEARLY(TIME<start_year_trans)=0;
scale_yearly2(time2<start_year_trans)=0;

clear TIME OVERLAP time2 overlap2
tic
for ilayer=2:nlayers
   
    layer_name=[num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer))]
   
    tree_file_name_yearly_error=[tree_model_file_name_yearly,'_error_',layer_name];
    tree_file_name_all_years_error=[tree_model_file_name_all_years,'_error_',layer_name];
    tree_file_name_combined_error=[tree_model_file_name_combined,'_error_',layer_name];
    
    
   
    load([path_tree,tree_file_name_yearly_error,'_2xweight_7day.mat'], 'ht_error', ...
     'scale_total','scale_total_median')
    ht_out_error=ht_error.*SCALE_YEARLY;
    scale_out_total=scale_total.*scale_yearly2;
    scale_out_total_median=scale_total_median.*scale_yearly2;
    clear ht_error scale_total scale_total_median


    
    load([path_tree,tree_file_name_all_years_error,'_2xweight_7day.mat'], 'ht_error', ...
     'scale_total','scale_total_median')
   
%     ht_error=ht_out_error+ht_error.*SCALE_ALL_YEARS;
    ht_error=nansum(cat(4,ht_out_error,ht_error.*SCALE_ALL_YEARS),4);
    scale_total=nansum(cat(3,scale_out_total,scale_total.*scale_all_years2),3);
    scale_total_median=nansum(cat(3,scale_out_total_median,scale_total_median.*scale_all_years2),3);
%     scale_total=scale_out_total+scale_total.*scale_all_years2;
%     scale_total_median=scale_out_total_median+scale_total_median.*scale_all_years2;

    clear ht_error_out scale_out_total_median scale_out_total
    
    save([path_tree,tree_file_name_combined_error,'_2xweight_7day.mat'], 'ht_error', ...
     'scale_total','scale_total_median','lon_tpx', 'lat_tpx', 'time_aviso',...
    '-v7.3')
    clear ht_error scale_total scale_total_median


  

  
   toc./60

end




