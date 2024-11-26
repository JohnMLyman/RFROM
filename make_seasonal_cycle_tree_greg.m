tic

tree_model_file_name_season='tree_sst_tpx_yearly_overlap_seasonal';
% tree_model_file_name_combined='tree_sst_tpx_yearly_overlap_seasonal';
tree_model_file_name_combined=['tree_sst_tpx_combined_seasonal_anom'];


tree_model_file_name_old=tree_model_file_name_season;

tree_model_file_name=tree_model_file_name_combined;
path_OHCA_data_out='C:\data\OHCA\'
file_path_out=[path_OHCA_data_out,'OHCA_grided\'];
path_tree=[path_OHCA_data_out,'OHCA_trees\'];
path_new_tree=[path_tree,tree_model_file_name,'\'];

%  get this year basied on when there is delayed mode Aviso SSH and where
%  there is good coverage of Argo floats
% 
max_year_fit=2020;
min_year_fit=2008;










% % % 

    tic
    ioff=50;
    maps_name=['maps_0_2000_max_old_',num2str(ioff),'.mat'];
    load ([path_tree,maps_name], 'tgrid', 'ohca_max', 'ohca_2000', 'lon_tpx','lat_tpx');
    ohca_diff=ohca_2000-ohca_max;
    time_aviso=tgrid;
    clearvars ohca_2000 ohca_max tgrid

    
    nlon=length(lon_tpx);
    nlat=length(lat_tpx);
    use_years=floor(time_aviso)>=min_year_fit & floor(time_aviso)<=max_year_fit;
    nyears_tot=length(find(use_years));

    model_map=nans(nlon,nlat,15);
    model_error_map=model_map;
    
    for ilon=1:nlon 
        for ilat=1:nlat 
             jyin=squeeze(ohca_diff(ilon,ilat,:));
             jtime=time_aviso;
             good=isfinite(jyin)&use_years';
             jyin=jyin(good)';
             jtime=jtime(good);

             if length(jtime)>.9*nyears_tot % only fit a seasonal cycle when there is 90% coverage
    
                 
                  [~,model,model_err]=j_fit_annual_tree_greg(jtime,jyin);
                 model_map(ilon,ilat,:)=model;
                 model_error_map(ilon,ilat,:)=model_err;
                 
             end
        end
        ilon./nlon
        toc./60
    end
    save([path_tree,'greg_seasonal_cycle_2000_minus_max_maps.mat'],...
        'model_map','model_error_map',...
        'time_aviso','lon_tpx','lat_tpx')
    toc./60


