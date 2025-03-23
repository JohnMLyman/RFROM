function [ht_estimate]=bagged_yearly_tree_temp_SSH_paige_eqbox_test(iyear_mod,...
                time_aviso,ssh_total,...
                nfiles,ht_estimate,TreePredictInfo,file_big_model_short,large_scale,tree_type) 


scale_box_deg_lat=TreePredictInfo.scale_box_deg_lat;
scale_box_eq=TreePredictInfo.scale_box_eq;
lat_change=TreePredictInfo.lat_change;



start_year=TreePredictInfo.start_year;
end_year=TreePredictInfo.end_year;
global_basins_aviso=TreePredictInfo.global_basins_aviso;
nlon_tpx=TreePredictInfo.nlon_tpx;
nlat_tpx=TreePredictInfo.nlat_tpx;
LON=TreePredictInfo.LON;
LAT=TreePredictInfo.LAT;
w_art=TreePredictInfo.w_art;
w_atl=TreePredictInfo.w_atl;
nbasins_use=TreePredictInfo.nbasin_use;
if ~exist("large_scale",'var')
    large_scale='none';
end
if ~exist("tree_type",'var')
    tree_type='none';
end





yr_av=time_aviso;

 pos_2d_pac_ind=global_basins_aviso(2).pos & global_basins_aviso(1).pos;
pos_2d_atl_ind=global_basins_aviso(5).pos & global_basins_aviso(1).pos;
pos_2d_pac_atl=global_basins_aviso(5).pos & global_basins_aviso(2).pos;

 
%% Section changed for speed up also change file_big_model to file_big_model_short 
% year_file_name=num2str(10*iyear_mod);
% file_big_model=[path_new_tree,tree_model,'_model_',layer_name,'_',year_file_name,'_split.mat'];

% 
% load(file_big_model,'model_all')
% n_mod_basin=length(model_all);

for ibasin=1:max(nbasins_use)
 
%  if ibasin<= n_mod_basin
     filename=[file_big_model_short,'basin_',num2str(ibasin),'.mat'];
 if exist(filename,'file')
     load(filename,'ModelTree')
     M=ModelTree.model;
%%
     
     if ~isempty(M)

        pos_2d=global_basins_aviso(ibasin).pos;
        
        
        npos_2d=length(find(pos_2d(:)));
        pos_3d=repmat(pos_2d,1,1,nfiles);

        jssh=double(ssh_total(pos_3d));
    
        jyr=repmat(yr_av,npos_2d,1);
        jyr=jyr(:);
       
        jlon=repmat(double(LON(pos_2d)),nfiles,1);
        jlat=repmat(double(LAT(pos_2d)),nfiles,1);
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
            good=isfinite(jyr) &isfinite(jssh)&good_yr;
            pos_use=find(pos_3d);
            pos_3d_use=pos_3d;
            pos_3d_use(pos_use(~good))=0;
            jyr_yearly=jyr(good);
        
            input_mat=nans(length(jyr_yearly),6);
            input_mat(:,1)=jyr_yearly;


            month_angle=(jyr_yearly-floor(jyr_yearly)).*2*pi;
            input_mat(:,4)=jssh(good);
            input_mat(:,5)=cos(month_angle);
           input_mat(:,6)=sin(month_angle);
           input_mat=smooth_lat_lon_eqbox_read(input_mat,jlon,jlat,good,ibasin,...
               large_scale,scale_box_deg_lat,scale_box_eq,lat_change);
   
            

            jw_use=jw(good);

            % now weight for the yearly overlap

            w_year=1-2.*abs(iyear_mod-jyr_yearly);

             %correct for the fact it is the last year and there is no
             %overlap
             if iyear_mod==end_year
                w_year(jyr_yearly>=end_year)=1;
            end
            if iyear_mod==start_year
                w_year(jyr_yearly<=start_year)=1;
            end

            if ~strcmp(tree_type,'all')
                jw_use=jw_use.*w_year;
            end
         

                 
         ht_junk=predict(M,input_mat).*jw_use;
         
         ht_estimate(pos_3d_use) =sum(cat(2,ht_estimate(pos_3d_use),ht_junk),2,'omitnan');
     end
end


end
