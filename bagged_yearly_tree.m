function [ht_estimate]=bagged_yearly_tree_temp_SSH_SST(iyear_mod,...
                time_aviso,ssh_total,sst_total,...
                nfiles,layer_name,ht_estimate,TreePredictInfo) ;
yr_av=time_aviso;

 pos_2d_pac_ind=global_basins_aviso(2).pos & global_basins_aviso(1).pos;
pos_2d_atl_ind=global_basins_aviso(5).pos & global_basins_aviso(1).pos;
pos_2d_pac_atl=global_basins_aviso(5).pos & global_basins_aviso(2).pos;

        nbasin=length(global_basins_aviso);
%             for iyear_mod=min_tpx_year+.5:.5:max_tpx_year+.5
                     
%                    iyear_mod,toc./60
        
                year_file_name=num2str(10*iyear_mod);
                file_big_model=[path_new_tree_season,tree_model_file_name_season,'_model_',layer_name,'_',year_file_name,'_split.mat'];
                
%                 load(file_big_model,'model_all')     
                [model_all]=parload_model(file_big_model);
                n_mod_basin=length(model_all);
                
                for ibasin=nbasins_use
                     
                     if ibasin<= n_mod_basin
                         M=model_all(ibasin).model;
                         
                    %      ht_estimate(good) = predict(M,input_table);
                         if ~isempty(M)
                   
                            pos_2d=global_basins_aviso(ibasin).pos;
                            
                    %         global_basins_aviso(ibasin).name
                            
                            npos_2d=length(find(pos_2d(:)));
                            pos_3d=repmat(pos_2d,1,1,nfiles);
                            jsst=double(sst_total(pos_3d));
                            jssh=double(ssh_total(pos_3d));
%                             jssh=ssh_total_c.Value(pos_3d);
%                             jsst=sst_total_c.Value(pos_3d);
%                         
                        
                            jyr=repmat(yr_av,npos_2d,1);
                            jyr=jyr(:);
                           
                            jlon=repmat(double(LON(pos_2d)),nfiles,1);
                            jlat=repmat(double(LAT(pos_2d)),nfiles,1);
%                             jlon=repmat(LON_c.Value(pos_2d),nfiles,1);
%                             jlat=repmat(LAT_c.Value(pos_2d),nfiles,1);
                            % compute weights so there is a linear transition at the overlaps of
                            % the Atlantic, Pacific and Indian Oceans.
                
                
                            if ibasin==3
                                weight_cross=w_art;
                            elseif ibasin==5
                                 weight_cross=w_atl;
                            else
                                 weight_cross=ones(nlon_tpx,nlat_tpx);
                            end
                            
                        
                            if ibasin==1
                                
                                ind_lon_atl_ind=12.0540;
                                atl_lon_atl_ind=40.3434;
                                length_lon_line_atl_ind=atl_lon_atl_ind-ind_lon_atl_ind;
                                weight_cross(pos_2d_atl_ind)=(LON(pos_2d_atl_ind)-ind_lon_atl_ind)./length_lon_line_atl_ind;
                                
                                
                                ind_lon_pac_ind=152.6829;
                                pac_lon_pac_ind=125.0001;
                                length_lon_line_pac_ind=ind_lon_pac_ind-pac_lon_pac_ind;
                                weight_cross(pos_2d_pac_ind)=(ind_lon_pac_ind-LON(pos_2d_pac_ind))./length_lon_line_pac_ind;
                                
                            end
                        
                            if ibasin==2
                                
                                pac_lon_pac_atl=-57.3946;
                                atl_lon_pac_atl=-74.6408;
                                length_lon_line_pac_atl=pac_lon_pac_atl-atl_lon_pac_atl;
                        
                                weight_cross(pos_2d_pac_atl)=(pac_lon_pac_atl-LON(pos_2d_pac_atl))./length_lon_line_pac_atl;
                                
                                
                                ind_lon_pac_ind=152.6829;
                                pac_lon_pac_ind=125.0001;
                                length_lon_line_pac_ind=ind_lon_pac_ind-pac_lon_pac_ind;
                                weight_cross(pos_2d_pac_ind)=(LON(pos_2d_pac_ind)-pac_lon_pac_ind)./length_lon_line_pac_ind;
                        
                                
                            end
                        
                            if ibasin==5
                                
                                pac_lon_pac_atl=-57.3946;
                                atl_lon_pac_atl=-74.6408;
                                length_lon_line_pac_atl=pac_lon_pac_atl-atl_lon_pac_atl;
                                weight_cross(pos_2d_pac_atl)=(LON(pos_2d_pac_atl)-atl_lon_pac_atl)./length_lon_line_pac_atl;
                                
                                ind_lon_atl_ind=12.0540;
                                atl_lon_atl_ind=40.3434;
                                length_lon_line_atl_ind=atl_lon_atl_ind-ind_lon_atl_ind;
                                weight_cross(pos_2d_atl_ind)=(atl_lon_atl_ind-LON(pos_2d_atl_ind))./length_lon_line_atl_ind;
                        
                                
                            end
                            
                
                
                            jw=repmat(weight_cross(pos_2d),nfiles,1);
                        
                                 
                                good_yr=(jyr>=iyear_mod-.5 & jyr< iyear_mod+.5);
                                good=isfinite(jyr) & isfinite(jsst)&isfinite(jssh)&good_yr;
                                pos_use=find(pos_3d);
                                pos_3d_use=pos_3d;
                                pos_3d_use(pos_use(~good))=0;
                                jyr_yearly=jyr(good);
                            
                                input_mat=nans(length(jyr_yearly),5);
                                input_mat(:,1)=jyr_yearly;
                                if ibasin==2
                                   % use lon 0 to 360 for the pacific basin
                                   jj_lon=jlon(good);
                                   jj_lon(jj_lon<0)=jj_lon(jj_lon<0)+360;
                                   input_mat(:,2)=jj_lon;
                                   input_mat(:,3)=jlat(good);
                               
                               else
                                   input_mat(:,2)=jlon(good);
                                   input_mat(:,3)=jlat(good);
                               end
                                
                                input_mat(:,4)=jssh(good);
                                input_mat(:,5)=jsst(good);
                                jw_use=jw(good);
                
                                % now weight for the yearly overlap
                
                                w_year=1-2.*abs(iyear_mod-jyr_yearly);
                
                                 %correct for the fact it is the last year and there is no
                                 %overlap
                                if iyear_mod==end_year_mean
                                    w_year(jyr_yearly>=end_year)=1;
                                end
                                if iyear_mod==start_year_mean
                                    w_year(jyr_yearly<=start_year)=1;
                                end
                
                                jw_use=jw_use.*w_year;
                             
                  
                                     
                             ht_junk=predict(M,input_mat).*jw_use;
                             
                             ht_estimate(pos_3d_use) =sum(cat(2,ht_estimate(pos_3d_use),ht_junk),2,'omitnan');
                         end
                    end
               
                 
                end
%                  clear jyr jlon jlat jssh jsst
% %                  toc./60
        
%             end