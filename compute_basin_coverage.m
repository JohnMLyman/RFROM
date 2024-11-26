function []=compute_basin_coverage(TreeSetUp)

% Loads Set up

nbasins_use=TreeSetUp.nbasins_use;
file_name=TreeSetUp.file_name;
var_type=TreeSetUp.var_type;

file_name_season=TreeSetUp.file_name_season;
file_name_season_anom=TreeSetUp.file_name_season_anom;
file_WOD_suf=TreeSetUp.file_WOD_suf;
file_path_hdata=TreeSetUp.file_path_hdata;
fname_nc_season=TreeSetUp.fname_nc_season;
fname_nc=TreeSetUp.fname_nc;
file_name_basin_coverage=TreeSetUp.file_name_basin_coverage;

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
ilayer_depth_use_sst=TreeSetUp.ilayer_depth_use_sst;
ilayer_depth_use_ssh=TreeSetUp.ilayer_depth_use_ssh;


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

fname_nc=fname_nc_season;


coords=[];
tpx=[];
yr=[];
sst=[];


load(fname_nc);

nlayer=length(layer_bounds);


if ~exist(path_new_tree_season,'dir')
    mkdir(path_new_tree_season)
end


for ilayer=2:nlayer
    layer_name=[num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer))];
    ht_all_junk{ilayer-1}=eval([var_type,'_',layer_name]);
     % hold out 10% of good data for each layer
  
end

% 
% 
% 
% 
global_basins=find_basin_paige(coords(:,1),coords(:,2));

time_basin=[start_year:.5:end_year];
ntime_basin=length(time_basin);
Nprof_basin=nans(max(nbasins_use),nlayer-1,length(time_basin));
bad_year_basin=ones(max(nbasins_use),nlayer-1,length(time_basin));
parfor ilayer=2:nlayer
% for ilayer=2:nlayer

   
    for iyear_index=1:ntime_basin
        iyear_mod=time_basin(iyear_index);
        
        for ibasin=nbasins_use
            good_yr=(yr>iyear_mod-.5 & yr<= iyear_mod+.5);
            ht_use=ht_all_junk{ilayer-1}; 
            good_prof=find(isfinite(ht_use)&good_yr&global_basins(ibasin).pos);
            if ~isempty(good_prof)
                ngood_prof=length(good_prof);
                Nprof_basin(ibasin,ilayer-1,iyear_index)=ngood_prof;
                switch ibasin
                    case 1 % Indian
                          bad_year_basin(ibasin,ilayer-1,iyear_index)=0;
                    case 2 %  Pacific
                          bad_year_basin(ibasin,ilayer-1,iyear_index)=0;
                    case 3 %  Artic
                          bad_year_basin(ibasin,ilayer-1,iyear_index)=0;
                           
                    case 4 % meditrain 
                         if ngood_prof>=100
                             bad_year_basin(ibasin,ilayer-1,iyear_index)=0;
                         end
                    case 5 %  Atlantic
                          bad_year_basin(ibasin,ilayer-1,iyear_index)=0;
                
                    case 6 % Black sea
                        if ngood_prof>=30
                            bad_year_basin(ibasin,ilayer-1,iyear_index)=0;
                        end
                    case 7 % red sea
                        if ngood_prof>=10
                            bad_year_basin(ibasin,ilayer-1,iyear_index)=0;
                        end
                    case 8 % gulf of Mexico and the caribian sea
                        if ngood_prof>=100
                            bad_year_basin(ibasin,ilayer-1,iyear_index)=0;
                        end
                    case 9 % Bafin Bay
                        if ngood_prof>=10
                            bad_year_basin(ibasin,ilayer-1,iyear_index)=0;
                        end
                    case 10 %Caspin Sea
                        if ngood_prof>=10
                            bad_year_basin(ibasin,ilayer-1,iyear_index)=0;
                        end

                end

            end
            

        end

    end




end



% file_name_basin_coverage=[path_tree,var_type,'data_new_layers_',file_WOD_suf,'_',file_name_season,'_basin_coverage.mat'];

save(file_name_basin_coverage,'bad_year_basin','Nprof_basin','time_basin')
end


