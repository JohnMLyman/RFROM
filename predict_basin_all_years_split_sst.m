function [ht_estimate]=predict_basin_all_years_split_sst(lon,lat,yr,sst,...
    layer_name,tree_model_file_name,path_new_tree)
% this code assumes lon goes from -180 to 180 and that all input arrays are
% 1-d
% min_year is the first year that was mapped
% max_year is the last year that was mapped
% must run it over all years because the min_year ad max_year have
% different tapers



% tree_model_file_name='tree_sst_tpx_year_1993';

%  layer_bounds=[0,40,90,190,290,450,700,950,1450,1950,2000];
%  layer_name=[num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer))]

 
tic
nprof=length(lon);
[global_basins_aviso]=find_basin_paige(lon,lat);
nbasin=length(global_basins_aviso);
[w_art,w_atl]=find_atlantic_artic_overlap_weights(global_basins_aviso,lon,lat);


pos_pac_ind=global_basins_aviso(2).pos & global_basins_aviso(1).pos;
pos_atl_ind=global_basins_aviso(5).pos & global_basins_aviso(1).pos;
pos_pac_atl=global_basins_aviso(5).pos & global_basins_aviso(2).pos;



ht_estimate=nans(nprof,1);

pos_finite=isfinite(sst);

% max_year=floor(max(yr(:)));
% max_year=max_year(1);

% for iyear_mod=start_year:.5:end_year
%         year_file_name=num2str(10*iyear_mod);
%         file_big_model=[path_new_tree,tree_model_file_name,'_model_',layer_name,'_',year_file_name,'.mat'];
%         file_compact_model=[path_new_tree,tree_model_file_name,'_compact_model_',layer_name,'_',year_file_name,'.mat'];
        file_big_model=[path_new_tree,tree_model_file_name,'_model_',layer_name,'_split.mat'];
        load(file_big_model,'model_all')   
        n_mod_basin=length(model_all);

     for ibasin=1:nbasin
            if ibasin<= n_mod_basin

                 M=model_all(ibasin).model;
                
                
                 if ~isempty(M)
                
               
                
                global_basins_aviso(ibasin).name;
               
                pos_basin=global_basins_aviso(ibasin).pos;
                   
                    
                    % compute weights so there is a linear transition at the overlaps of
                    % the Atlantic, Pacific and Indian Oceans.
                
                % compute weights so there is a linear transition at the overlaps of
                % the Atlantic, Pacific and Indian Oceans.
            
                if ibasin==3
                        weight_cross=w_art;
                elseif ibasin==5
                     weight_cross=w_atl;
                else
                     weight_cross=ones(nprof,1);
                end
                    
                
            
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
                
            
               
                   
        %              good_yr=(yr>iyear_mod-.5 & yr<= iyear_mod+.5);
                     
                   
                    good=pos_basin & pos_finite;
                    jw=weight_cross(good);
                    
                    
                    jyr=yr(good);
                
                    input_mat=nans(length(jyr),5);
                    input_mat(:,1)=jyr;
                    if ibasin==2
                           % use lon 0 to 360 for the pacific basin
                           jj_lon=lon(good);
                           jj_lon(jj_lon<0)=jj_lon(jj_lon<0)+360;
                           input_mat(:,2)=jj_lon;
                           input_mat(:,3)=lat(good);
                   
                   else
                       input_mat(:,2)=lon(good);
                       input_mat(:,3)=lat(good);
                   end
                    
                    input_mat(:,4)=sst(good);
                  
        %             w_year=1-2.*abs(iyear_mod-jyr);
        %                  %correct for the fact it is the last year and there is no
        %                  %overlap
        %                 if iyear_mod==end_year
        %                     w_year(jyr>=end_year)=1;
        %                 end
        %                 if iyear_mod==start_year
        %                     w_year(jyr<=start_year)=1;
        %                 end
        % 
        %                 jw=jw.*w_year;
                
                    
                
                    clear jyr
                    
                
                  
               
                        
                         
                         ht_junk=predict(M,input_mat).*jw;
                         
                         ht_estimate(good) =sum(cat(2,ht_estimate(good),ht_junk),2,'omitnan');
                end
            end
      end
     


% end



toc./60
end