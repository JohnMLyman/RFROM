function make_combined_files(TreeSetUp)

% Loads Set up
% load_TreeSetUp
%%

nbasins_use=TreeSetUp.nbasins_use;
nbasins_use_extra_all_years=TreeSetUp.nbasins_use_extra_all_years;

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
path_new_tree_combined=TreeSetUp.path_new_tree_combined;
path_new_tree_combined_withcycle=TreeSetUp.path_new_tree_combined_withcycle;


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



% file_basin_mask=[path_tree,var_type,'data_new_layers_',file_WOD_suf,'_',file_name_season,'_basin_coverage.mat'];
file_basin_mask=file_name_basin_coverage;
%
% % 

nlayer=length(layer_bounds);
start_year_load=floor(start_year);

end_year_load=floor(end_year);
time_load=start_year_load:end_year_load;







if ~exist(path_new_tree_combined,'dir')

    mkdir(path_new_tree_combined)
end

ilayer=2;
layer_name=[num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer))];
% tree_file_name_in_yearly=[tree_model_file_name_yearly,'_',layer_name,'_',num2str(time_load(end-2))];
tree_file_name_in_all_years=[tree_model_file_name_all_year,'_',layer_name,'_',num2str(year_load)];

load([path_new_tree_all_year,tree_file_name_in_all_years,'_split_7day.mat'] ,'lon_tpx', 'lat_tpx')
[LON,LAT]=ndgrid(lon_tpx,lat_tpx);
[global_basins_aviso]=find_basin_paige(LON,LAT);
% sss2=find(time_load==start_year_trans);

parfor year_load=time_load

% for year_load=time_load


    display(year_load)

   
    
   

    for ilayer=2:nlayer
    
        layer_name=[num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer))];
        tree_file_name_in_yearly=[tree_model_file_name_yearly,'_',layer_name,'_',num2str(year_load)];
        tree_file_name_in_all_years=[tree_model_file_name_all_year,'_',layer_name,'_',num2str(year_load)];
        tree_file_name_out_combine=[tree_model_file_name_combined,'_',layer_name,'_',num2str(year_load)];

        file_all_year=[path_new_tree_all_year,tree_file_name_in_all_years,'_split_7day.mat'];
        file_all_year_extra=[path_new_tree_all_year,tree_file_name_in_all_years,'_extra_split_7day.mat'];
%         file_all_year_extra=file_all_year;

        file_yearly=[path_new_tree_yearly,tree_file_name_in_yearly,'_split_7day.mat'];
        file_combine=[path_new_tree_combined,tree_file_name_out_combine,'_split_7day.mat'];
        
        if year_load<=end_all_year % This is in case you infil durring the transition times there are no extra maps then
            file_all_year_extra=file_all_year;
        end


%         tree_file_name_out_season=[tree_model_file_name_combined,'_season_',layer_name,'_',num2str(year_load)];
        if year_load<start_year_trans
            parcopyfile(file_all_year,file_combine)
        elseif year_load>end_year_trans
            parcopyfile(file_yearly,file_combine)
        else
            parcombine_files(file_all_year,file_yearly,file_combine,start_year_trans,end_year_trans)
            
        end

        if year_load>=start_year_trans
            parcombine_files_extra(file_all_year_extra,file_combine,...
                global_basins_aviso,nbasins_use_extra_all_years,file_basin_mask,ilayer,year_load)
        end

      



        
    end

end




end

function parsave_tree_year(filename,ht_estimate_year,lon_tpx, lat_tpx,time_aviso)
         ht_estimate_year=single(ht_estimate_year);

         save (filename,'ht_estimate_year','lon_tpx', 'lat_tpx','time_aviso','-v7')

end
function [ht_estimate_year,lon_tpx, lat_tpx,time_aviso]=parload_tree_year(filename)

         load (filename,'ht_estimate_year','lon_tpx', 'lat_tpx','time_aviso')

end


function parcopyfile(filein,fileout)
         copyfile(filein,fileout,'f')
end


function parcombine_files(file_all_year,file_yearly,file_combine,start_year_trans,end_year_trans)

    diff_trans=end_year_trans-start_year_trans+1;
    
    

    [ht_estimate_all_year,lon_tpx, lat_tpx,time_aviso]=parload_tree_year(file_all_year);
    [ht_estimate,~, ~,~]=parload_tree_year(file_yearly);

    nlon=length(lon_tpx);
    nlat=length(lat_tpx);
    ntime=length(time_aviso);

    w_yearly=(time_aviso-start_year_trans)./diff_trans;
    w_yearly=reshape(w_yearly,[1 1 ntime]);
    w_yearly=repmat(w_yearly,[nlon nlat 1]);

    ht_estimate=ht_estimate.*w_yearly+ht_estimate_all_year.*(1-w_yearly);
    
    
    parsave_tree_year(file_combine ,ht_estimate,lon_tpx, lat_tpx,time_aviso)
        

end


function parcombine_files_extra(file_all_year_extra,file_combine,...
    global_basins_aviso,nbasins_use_extra_all_years,file_basin_mask,ilayer,year_load)

    [ht_estimate_all_year,lon_tpx, lat_tpx,time_aviso]=parload_tree_year(file_all_year_extra);
    [ht_estimate,~, ~,~]=parload_tree_year(file_combine);
    
   

    load(file_basin_mask,'bad_year_basin','time_basin')

    pos_model=find(time_basin==year_load+.5,1,'first');

    % this is a catch if the model was stopped in the middle of the year

    if isempty(pos_model) 
        pos_model=find(time_basin==year_load,1,'first');
    end



    ntime_model=length(time_basin);


    pos_model_total=[pos_model-2:pos_model+2];
    pos_model_total(pos_model_total>ntime_model)=ntime_model;
    pos_model_total(pos_model_total<1)=1;

    
    for iyear=1:length(time_aviso)
        
        ht_junk=ht_estimate(:,:,iyear);
        ht_junk_all=ht_estimate_all_year(:,:,iyear);

        time_junk=time_aviso(iyear)-year_load;

        
        for ibasin=nbasins_use_extra_all_years
            bad_yearly= squeeze(bad_year_basin(ibasin,ilayer-1,pos_model_total));
           

            [w_allyear]=compute_weights_extra(bad_yearly,time_junk);
           

            ht_junk_small=...
                    sum(cat(2,(1-w_allyear).*ht_junk(global_basins_aviso(ibasin).pos),...
                    w_allyear.*ht_junk_all(global_basins_aviso(ibasin).pos)),...
                    2, 'omitnan');
            % force locaions of missing values to be missing
            ht_nan=~isfinite(ht_junk_all(global_basins_aviso(ibasin).pos));
            ht_junk_small(ht_nan)=nan;
            ht_junk(global_basins_aviso(ibasin).pos)=ht_junk_small;

        
        
        end
        ht_estimate(:,:,iyear)=ht_junk;
    end
   

    parsave_tree_year(file_combine ,ht_estimate,lon_tpx, lat_tpx,time_aviso)

end

function [w_allyear]=compute_weights_extra(bad_yearly,time)

% this functions compute the wights based on file created in
% compute_basin_coverage.m

            w_allyear=1;
            if sum(bad_yearly(2:4))==0
                w_allyear=(.5-time)./.5;
                if time>=.5
                    w_allyear=-1.*w_allyear;
                    w_allyear=w_allyear.*bad_yearly(5);
                else
                    w_allyear=w_allyear.*bad_yearly(1);
                end

            elseif sum(bad_yearly(2:3))==0
               
                if time<=.5
                    w_allyear=(time)./.5;
                    if bad_yearly(1)==1
                        w_allyear=1;
                    end

                end
            elseif sum(bad_yearly(3:4))==0

               if time>=.5
                    w_allyear=(1-time)./.5;
                    if bad_yearly(end)==1
                        w_allyear=1;
                    end

                end
           
            end




end
