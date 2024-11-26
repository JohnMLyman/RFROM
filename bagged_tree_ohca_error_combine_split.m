
function []=bagged_tree_ohca_error_combine_split(TreeSetUp)
load_TreeSetUp


nlayers=length(layer_bounds);




delta_trans=end_year_trans-start_year_trans+1;

ilayer=2;
layer_name=[num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer))];

tree_file_name_all_years_error=[tree_model_file_name_all_year,'_error_',layer_name];

load([path_tree,tree_file_name_all_years_error,'_2xweight_7day_split.mat'], ...
     'lon_tpx', 'lat_tpx', 'time_aviso')
nlon_tpx=length(lon_tpx);
nlat_tpx=length(lat_tpx);
ntime_tpx=length(time_aviso);
TIME=[];
time2=[];

TIME(1,1,:)=time_aviso;
time2(1,:)=time_aviso;

TIME=repmat(TIME,nlon_tpx,nlat_tpx,1);
time2=repmat(time2,10,1);


OVERLAP_ALL_YEAR=TIME>=start_year_trans & TIME<=(end_year_trans+1);
overlap_all_year=time2>=start_year_trans & time2<=(end_year_trans+1);

KEEP_ALL_YEARS=TIME<start_year_trans;
keep_all_years=time2<start_year_trans;

time_aviso_all_year=...
    [time_aviso(time_aviso<start_year_trans),...
    time_aviso(time_aviso>=start_year_trans & time_aviso<=(end_year_trans+1))];


SCALE_ALL_YEARS=(start_year_trans-TIME(OVERLAP_ALL_YEAR)+delta_trans)./(delta_trans);
scale_all_years=(start_year_trans-time2(overlap_all_year)+delta_trans)./(delta_trans);


tree_file_name_yearly_error=[tree_model_file_name_yearly,'_error_',layer_name];
load([path_tree,tree_file_name_yearly_error,'_2xweight_7day_split.mat'], ...
    'lon_tpx' ,'lat_tpx','time_aviso')

TIME=[];
time2=[];
TIME(1,1,:)=time_aviso;
time2(1,:)=time_aviso;

TIME=repmat(TIME,nlon_tpx,nlat_tpx,1);
time2=repmat(time2,10,1);

OVERLAP_YEARLY=TIME>=start_year_trans & TIME<=(end_year_trans+1);
overlap_yearly=time2>=start_year_trans & time2<=(end_year_trans+1);

KEEP_YEARLY=TIME>end_year_trans+1;
keep_yearly=time2>end_year_trans+1;


SCALE_YEARLY=(TIME(OVERLAP_YEARLY)-start_year_trans)./(delta_trans);
scale_yearly=(time2(overlap_yearly)-start_year_trans)./(delta_trans);

time_aviso=[time_aviso_all_year,time_aviso(time_aviso>end_year_trans+1)];
TIME=[];
time2=[];

TIME(1,1,:)=time_aviso;
time2(1,:)=time_aviso;

TIME=repmat(TIME,nlon_tpx,nlat_tpx,1);
time2=repmat(time2,10,1);

OVERLAP=TIME>=start_year_trans & TIME<=(end_year_trans+1);
overlap=time2>=start_year_trans & time2<=(end_year_trans+1);

KEEP_YEARLY_BIG=TIME>end_year_trans+1;
keep_yearly_big=time2>end_year_trans+1;

KEEP_ALL_YEARS_BIG=TIME<start_year_trans;
keep_all_years_big=time2<start_year_trans;

ntime_total=length(time_aviso);

clearvars time_aviso_all_year TIME time2

tic
for ilayer=2:nlayers
   
    layer_name=[num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer))]
   
    tree_file_name_yearly_error=[tree_model_file_name_yearly,'_error_',layer_name];
    tree_file_name_all_years_error=[tree_model_file_name_all_year,'_error_',layer_name];
    tree_file_name_combined_error=[tree_model_file_name_combined,'_error_',layer_name];
    
    ht_out_error=nans(nlon_tpx,nlat_tpx,ntime_total);
    scale_out_total=nans(10,ntime_total);
    scale_out_median_total=scale_out_total;
   
    load([path_tree,tree_file_name_yearly_error,'_2xweight_7day_split.mat'], 'ht_error', ...
     'scale_total','scale_total_median')

    ht_overlap_yearly=ht_error(OVERLAP_YEARLY).*SCALE_YEARLY;
    scale_overlap_yearly=scale_total(overlap_yearly).*scale_yearly;
    scale_overlap_median_yearly=scale_total_median(overlap_yearly).*scale_yearly;

    ht_out_error(KEEP_YEARLY_BIG)=ht_error(KEEP_YEARLY);
    scale_out_total(keep_yearly_big)=scale_total(keep_yearly);
    scale_out_median_total(keep_yearly_big)=scale_total_median(keep_yearly);
    
    clearvars ht_error scale_total scale_total_median
   

    
    load([path_tree,tree_file_name_all_years_error,'_2xweight_7day_split.mat'], 'ht_error', ...
     'scale_total','scale_total_median')


    ht_overlap_all_year=ht_error(OVERLAP_ALL_YEAR).*SCALE_ALL_YEARS;
    ht_overlap=nans(length(ht_overlap_all_year),1);
    pos_use=isfinite(ht_overlap_all_year)|isfinite(ht_overlap_all_year);
    ht_overlap(pos_use)=sum(cat(2,ht_overlap_yearly(pos_use),ht_overlap_all_year(pos_use)),2,'omitnan');

    scale_overlap_all_year=scale_total(overlap_all_year).*scale_all_years;
    scale_overlap=sum(cat(2,scale_overlap_yearly,scale_overlap_all_year),2,'omitnan');

    scale_overlap_median_all_year=scale_total_median(overlap_all_year).*scale_all_years;
    scale_overlap_median=sum(cat(2,scale_overlap_median_yearly,scale_overlap_median_all_year),2,'omitnan');

    ht_out_error(KEEP_ALL_YEARS_BIG)=ht_error(KEEP_ALL_YEARS);
    scale_out_total(keep_all_years_big)=scale_total(keep_all_years);
    scale_out_median_total(keep_all_years_big)=scale_total_median(keep_all_years);


    ht_out_error(OVERLAP)=ht_overlap;
    scale_out_total(overlap)=scale_overlap;
    scale_out_median_total(overlap)=scale_overlap_median;



    ht_error=ht_out_error;
    scale_total=scale_out_total;
    scale_total_median=scale_out_median_total;
    clearvars ht_error_out scale_out_total scale_out_median_total
    
    save([path_tree,tree_file_name_combined_error,'_2xweight_7day_split.mat'], 'ht_error', ...
     'scale_total','scale_total_median','lon_tpx', 'lat_tpx', 'time_aviso',...
    '-v7.3')
    clear ht_error scale_total scale_total_median


  

  
   toc./60

end




