tic

tree_model_file_name='tree_sst_tpx_yearly_overlap_seasonal';
path_oisst='C:\data\oisst\';
file_name_argo='pfloat_sal_greg_oct_2021_QC'
path_OHCA_data_out='C:\data\OHCA\'
path_OHCA_data_in='C:\OHCA\'

 layer_bounds=[0,40,90,190,290,450,700,950,1450,1950,2000];
 nlayer=length(layer_bounds);
% file_name='argo_2020_10_14_QC';
file_name_season=[file_name,'_seasonal'];
path_tree=[path_OHCA_data_out,'OHCA_trees\'];
path_new_tree=[path_tree,tree_model_file_name,'\'];

file_path_out=[path_OHCA_data_out,'OHCA_grided\'];
path_ssh=[path_OHCA_data_in,'Mtpers\'];

%  get this year basied on when there is delayed mode Aviso SSH and where
%  there is good coverage of Argo floats
% 
% max_year=max_year_fit;
% min_year=min_year_fit;










% % % 


    tic

    
    layer_name=[num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer))]
    tree_file_name=[tree_model_file_name,'_',layer_name];
    load([path_tree,tree_file_name,'_7day.mat'], 'ht_estimate','lon_tpx','lat_tpx', 'time_aviso')
    nlon=length(lon_tpx);
    nlat=length(lat_tpx);
    use_years=floor(time_aviso)>=min_year_fit & floor(time_aviso)<=max_year_fit;
    nyears_tot=length(find(use_years));

    for ilon=1:nlon 
        for ilat=1:nlat 
             jyin=squeeze(ht_estimate(ilon,ilat,:));
             jtime=time_aviso;
             good=isfinite(jyin)&use_years';
             jyin=jyin(good)';
             jtime=jtime(good);

             if length(jtime)>.9*nyears_tot % only fit a seasonal cycle when there is 90% coverage
    
                 [~,model,model_err]=...
                     j_fit_annual_tree(jtime,jyin);
                 [y_model,model,model_err]=j_fit_annual_tree_greg(jtime,jyin);



                 model_map(ilon,ilat,:)=model;
                 model_error_map(ilon,ilat,:)=model_err;
                 
%                  model_err_total(ilon,ilat)=model_err;
             end
        end
    end
    save([path_tree,tree_file_name,'_seasonal_cycle.mat'],...
        'model_error_map','model_map',...
        'time_aviso','lon_tpx','lat_tpx')
    toc./60




