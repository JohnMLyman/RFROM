function []=bagged_tree_ohca_combine_split_orca(TreeSetUp)


nbasins_use=TreeSetUp.nbasins_use;
file_name=TreeSetUp.file_name;

file_name_season=TreeSetUp.file_name_season;
file_name_season_anom=TreeSetUp.file_name_season_anom;
file_WOD_suf=TreeSetUp.file_WOD_suf;
file_path_hdata=TreeSetUp.file_path_hdata;
fname_nc_season=TreeSetUp.fname_nc_season;
fname_nc=TreeSetUp.fname_nc;

tree_prefix=TreeSetUp.tree_prefix;
tree_model_file_name_season=TreeSetUp.tree_model_file_name_season;
tree_model_file_name_yearly=TreeSetUp.tree_model_file_name_yearly;
tree_model_file_name_all_year=TreeSetUp.tree_model_file_name_all_year;
tree_model_file_name_combined=TreeSetUp.tree_model_file_name_combined;
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
%%





nlayer=length(layer_bounds);




delta_trans=end_year_trans-start_year_trans+1;

ilayer=2;
layer_name=[num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer))];
tree_file_name_all_year=[tree_model_file_name_all_year,'_',layer_name];
load([path_tree,tree_file_name_all_year,'_split_7day.mat'], 'lon_tpx' ,'lat_tpx','time_aviso')
nlon_tpx=length(lon_tpx);
nlat_tpx=length(lat_tpx);
% ntime_tpx=length(time_aviso);
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
load([path_tree,tree_file_name_yearly,'_split_7day.mat'], 'lon_tpx' ,'lat_tpx','time_aviso')

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

  % ngroup_layer: IF THE CODE RUNS OUT OF MEMEORY INCREASE ngroup_layer.  IT
         % DETERMINS HOW MANY GROUPS THE LAYERS ARE IN FOR PARALLELATION.
         % THE MORE GROUPS THE SMALLER THE NUMBER OF ELEMENTS IN EACH
         % PARFOR LOOP.


ngroup_layer=4;
    if nlayer>= 20
        n_sublayer=ceil(nlayer./ngroup_layer);
        start_sublayer=2:n_sublayer:nlayer;
        end_sublayer=n_sublayer+1:n_sublayer:nlayer;
        if end_sublayer(end)~= nlayer
            end_sublayer(end+1)=nlayer;
        end
    else
        start_sublayer=2;
        end_sublayer=nlayer;
        ngroup_layer=1;
    end

    for isublayer=1:ngroup_layer




        parfor ilayer=start_sublayer(isublayer):end_sublayer(isublayer)

% parfor ilayer=2:nlayer
   
    layer_name=[num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer))]
   
    tree_file_name_yearly=[tree_model_file_name_yearly,'_',layer_name];
    tree_file_name_all_year=[tree_model_file_name_all_year,'_',layer_name];
    tree_file_name_combined=[tree_model_file_name_combined,'_',layer_name];
    ht_out=nans(nlon_tpx,nlat_tpx,ntime_total);

%     load([path_tree,tree_file_name_yearly,'_split_7day.mat'], 'ht_estimate')
    [ht_estimate,~]=parload_tree([path_tree,tree_file_name_yearly,'_split_7day.mat'] );

    ht_overlap_yearly=ht_estimate(OVERLAP_YEARLY).*SCALE_YEARLY;
    ht_out(KEEP_YEARLY_BIG)=ht_estimate(KEEP_YEARLY);
    
%     clearvars ht_estiamte
%     load([path_tree,tree_file_name_all_year,'_split_7day.mat'], 'ht_estimate')
     [ht_estimate,~]=parload_tree([path_tree,tree_file_name_all_year,'_split_7day.mat'] );
    ht_overlap_all_year=ht_estimate(OVERLAP_ALL_YEAR).*SCALE_ALL_YEARS;
    
    ht_overlap=nans(length(ht_overlap_all_year),1);
    pos_use=isfinite(ht_overlap_yearly)|isfinite(ht_overlap_all_year);

    ht_overlap(pos_use)=sum(cat(2,ht_overlap_yearly(pos_use),ht_overlap_all_year(pos_use)),2,'omitnan');

    ht_out(KEEP_ALL_YEARS_BIG)=ht_estimate(KEEP_ALL_YEARS);
    ht_out(OVERLAP)=ht_overlap;
    ht_estimate=ht_out;
%     save([path_tree,tree_file_name_combined,'_split_7day.mat'],'ht_estimate','time_aviso','lon_tpx','lat_tpx','-v7.3')
    parsave_tree([path_tree,tree_file_name_combined,'_split_7day.mat'],ht_estimate,lon_tpx, lat_tpx,time_aviso)

    

  

  
  

        end
    end
toc./60

end

function parsave_tree(filename,ht_estimate,lon_tpx, lat_tpx,time_aviso)
         ht_estimate=single(ht_estimate);

         save (filename,'ht_estimate','lon_tpx', 'lat_tpx','time_aviso','-v7.3')

end
function pardelete_tree(filename)

         delete(filename)

end
function [model_all]=parload_model(filename)
    
    load(filename,'model_all')     
end

function [ht_estimate,time_aviso]=parload_tree(filename)
    
    load(filename,'ht_estimate','time_aviso')     
end

