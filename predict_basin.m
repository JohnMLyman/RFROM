function [ht_estimate]=predict_basin(lon,lat,yr,ssh,sst,ilayer,tree_model_file_name)
% this code assumes lon goes from -180 to 180 and that all input arrays are
% 1-d


% tree_model_file_name='tree_sst_tpx_year_1993';
path_OHCA_data_out='C:\data\OHCA\'
path_tree=[path_OHCA_data_out,'OHCA_trees\'];
path_new_tree=[path_tree,tree_model_file_name,'\'];
 layer_bounds=[0,40,90,190,290,450,700,950,1450,1950,2000];

file_compact_model=[path_new_tree,tree_model_file_name,'_compact_model_',num2str(layer_bounds(ilayer-1)),'_',...
             num2str(layer_bounds(ilayer)),'.mat'];

'load model'    
tic
nprof=length(lon);
[global_basins_aviso]=find_basin_paige(lon,lat);
nbasin=length(global_basins_aviso);


pos_pac_ind=global_basins_aviso(2).pos & global_basins_aviso(1).pos;
pos_atl_ind=global_basins_aviso(5).pos & global_basins_aviso(1).pos;
pos_pac_atl=global_basins_aviso(5).pos & global_basins_aviso(2).pos;

load(file_compact_model,'compact_model_all')
toc./60
ht_estimate=nans(nprof,1);

pos_finite=isfinite(sst) & isfinite(ssh);


for ibasin=1:nbasin
    tic
    pos_basin=global_basins_aviso(ibasin).pos;
    good=pos_basin & pos_finite;
    
    global_basins_aviso(ibasin).name
    
   
    
    % compute weights so there is a linear transition at the overlaps of
    % the Atlantic, Pacific and Indian Oceans.

    weight_cross=ones(nprof,1);
    

    if ibasin==1
        
        ind_lon_atl_ind=12.0540;
        atl_lon_atl_ind=40.3434;
        length_lon_line_atl_ind=atl_lon_atl_ind-ind_lon_atl_ind;
        weight_cross(pos_atl_ind)=(lon(pos_atl_ind)-ind_lon_atl_ind)./length_lon_line_atl_ind;
        
        
        ind_lon_pac_ind=152.6829;
        pac_lon_pac_ind=125.0001;
        length_lon_line_pac_ind=ind_lon_pac_ind-pac_lon_pac_ind;
        weight_cross(pos_pac_ind)=(ind_lon_pac_ind-lon(pos_pac_ind))./length_lon_line_pac_ind;
        
    end

    if ibasin==2
        
        pac_lon_pac_atl=-57.3946;
        atl_lon_pac_atl=-74.6408;
        length_lon_line_pac_atl=pac_lon_pac_atl-atl_lon_pac_atl;

        weight_cross(pos_pac_atl)=(pac_lon_pac_atl-lon(pos_pac_atl))./length_lon_line_pac_atl;
        
        
        ind_lon_pac_ind=152.6829;
        pac_lon_pac_ind=125.0001;
        length_lon_line_pac_ind=ind_lon_pac_ind-pac_lon_pac_ind;
        weight_cross(pos_pac_ind)=(lon(pos_pac_ind)-pac_lon_pac_ind)./length_lon_line_pac_ind;

        
    end

    if ibasin==5
        
        pac_lon_pac_atl=-57.3946;
        atl_lon_pac_atl=-74.6408;
        length_lon_line_pac_atl=pac_lon_pac_atl-atl_lon_pac_atl;
        weight_cross(pos_pac_atl)=(lon(pos_pac_atl)-atl_lon_pac_atl)./length_lon_line_pac_atl;
        
        ind_lon_atl_ind=12.0540;
        atl_lon_atl_ind=40.3434;
        length_lon_line_atl_ind=atl_lon_atl_ind-ind_lon_atl_ind;
        weight_cross(pos_atl_ind)=(atl_lon_atl_ind-lon(pos_atl_ind))./length_lon_line_atl_ind;

        
    end
    
    jw=weight_cross(good);

    
    
    jyr=yr(good);

    input_mat=nans(length(jyr),5);
    input_mat(:,1)=jyr;
    input_mat(:,2)=lon(good);
    input_mat(:,3)=lat(good);
    input_mat(:,4)=ssh(good);
    input_mat(:,5)=sst(good);
    

    

    clear jyr
    

%     input_table=table(jyr(good),jlon(good),jlat(good),jssh(good),jsst(good),'VariableNames',var_names);
     toc./60
     'subsect basin model'
     tic
     M=compact_model_all(ibasin).model;
     toc./toc
%      ht_estimate(good) = predict(M,input_table);
     if ~isempty(M)

%          tic
%          Ginput_mat=gpuArray(input_mat);
%          Gjw=gpuArray(jw);
%          Ght_junk=predict(M,Ginput_mat).*Gjw(good);
%          ht_junk=gather(Ght_junk);
%          toc
        'predict'
         tic
         ht_junk=predict(M,input_mat).*jw;
         toc./60
         ht_estimate(good) =nansum(cat(2,ht_estimate(good),ht_junk),2);
     end

     


end
clear compact_model_all
tic


toc./60
end