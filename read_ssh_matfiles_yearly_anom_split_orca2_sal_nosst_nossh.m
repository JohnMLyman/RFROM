function []=read_ssh_matfiles_yearly_anom_split_orca2_sal_nosst_nossh(TreeSetUp)

load_TreeSetUp


tic
%%


nbasins_use=TreeSetUp.nbasins_use;
file_name=TreeSetUp.file_name;

file_name_season=TreeSetUp.file_name_season;
file_name_season_anom=TreeSetUp.file_name_season_anom;
file_WOD_suf=TreeSetUp.file_WOD_suf;
file_path_hdata=TreeSetUp.file_path_hdata;
fname_nc_season=TreeSetUp.fname_nc_season;
fname_nc=TreeSetUp.fname_nc;


tree_prefix_temp=TreeSetUp.tree_prefix_temp;
path_mat_nc=TreeSetUp.path_mat_nc;


tree_prefix=TreeSetUp.tree_prefix;
tree_model_file_name_season=TreeSetUp.tree_model_file_name_season;
tree_model_file_name_yearly=TreeSetUp.tree_model_file_name_yearly;
tree_model_file_name_all_year=TreeSetUp.tree_model_file_name_all_year;
tree_model_file_name_combined=TreeSetUp.tree_model_file_name_combined;

tree_model_file_name_season_temp=TreeSetUp.tree_model_file_name_season_temp;
tree_model_file_name_combined_temp=TreeSetUp.tree_model_file_name_combined_temp;
% 
% file_name_season=[file_name,'_seasonal'];
% file_name_season_anom=[file_name_season,'_anom'];

path_oisst=TreeSetUp.path_oisst;
path_OHCA_data_out=TreeSetUp.path_OHCA_data_out;
path_OHCA_data_in=TreeSetUp.path_OHCA_data_in;
path_ssh=TreeSetUp.path_ssh;

path_tree=TreeSetUp.path_tree;
path_tree_temp=TreeSetUp.path_tree_temp;

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

mid_yearly_maps=(start_yearly_maps+end_yearly_maps)./2;











s_allfiles=dir([path_ssh,'matlab_files\new_ssh*.mat']);
s=s_allfiles(1:7:length(s_allfiles));
nfiles=length(s);
sday=strjust(strvcat(s(:).name),'right');
sday=str2num(sday(:,end-8:end-4));


sday=sday+datenum(1950,1,1);
datevec_sday=datevec(sday);
aviso_day=sday-datenum(datevec_sday(:,1),1,1)+1;
syr=datevec_sday(:,1)+(aviso_day-1)./yeardays(datevec_sday(:,1));

clear sday




syr_total=syr;
s_total=s;
aviso_day_total=aviso_day;

 load([path_tree,tree_model_file_name_season,'_seasonal_cycle_tpx_split.mat'],...
            'amp_annual_total','phase_annual_total','amp_semi_total','phase_semi_total',...
            'amp_third_total','phase_third_total','slope_total','mean_total',...
            'lon_tpx','lat_tpx')
        period=1;
        period2=1/2;
        period3=1/3;
for isplit=1:2
        syr=syr_total;
        s=s_total;
        aviso_day=aviso_day_total;
        if isplit ==1
            min_tpx_year=start_yearly_maps-.5;
            max_tpx_year=floor(mid_yearly_maps)+1;
        else
            min_tpx_year=floor(mid_yearly_maps)-1;
            max_tpx_year=end_yearly_maps-.5;
        end

        tgrid=min_tpx_year+.5:max_tpx_year+.5;
        nyears=length(tgrid);
        good_tpx_files=find(-.5+tgrid(1)<=(syr) & (syr)<.5+tgrid(end));
        syr=syr(good_tpx_files);
        s=s(good_tpx_files);
        aviso_day=aviso_day(good_tpx_files);
        nfiles=length(syr);
        
        
        nlat_tpx=length(lat_tpx);
        nlon_tpx=length(lon_tpx);
        
        
       
        
        
        ssh_total=nans(nlon_tpx,nlat_tpx,nfiles);
        sst_total=ssh_total;
        time_aviso=nans(1,nfiles);
        for iyear=1:nyears 
            iyear
            yr_name=num2str(floor(tgrid(iyear)));
            sst_anom_year=double(ncread([path_oisst,'sst.day.anom.',yr_name,'.nc'],'anom'));
            sst_anom_year(sst_anom_year<= -9.9692e+36)=nan;
            sst_time=double(ncread([path_oisst,'sst.day.anom.',yr_name,'.nc'],'time'));
            sst_time=sst_time-min(sst_time)+1;
            max_sst_time=max(sst_time); 
            sshave=zeros(length(lon_tpx),length(lat_tpx));
            
            ii=find(-.5<=(syr-tgrid(iyear)) & (syr-tgrid(iyear))<.5);
            for j=1:length(ii)
                ifile=ii(j);
                load([s(ifile).folder,'\',s(ifile).name])
                junk_day=aviso_day(ifile);
                good_t=syr(ifile);
                ssh_seasonal_cycle=amp_annual_total.*sin((2*pi.*good_t./period)+phase_annual_total)+amp_semi_total.*sin((2.*good_t*pi./period2)+phase_semi_total)+...
                    amp_third_total.*sin((2*pi.*good_t./period3)+phase_third_total)+mean_total+slope_total.*center_year;
        
               
                    % only take delayed mode ssh for the means fine for the anomly
                    ssh_total(:,:,ifile)=sshanom-ssh_seasonal_cycle;
                    if junk_day<=max_sst_time
                        sst_total(:,:,ifile)=sst_anom_year(:,:,junk_day);
                    end
                    time_aviso(ifile)=syr(ifile);
                
            end
           
            
            
        
        
        
        
          
          
        end % for years  
        
        
        
        
        
        
        % load('test_tree_model_mat.mat')
        
        lon_model=lon_tpx;
        lon_model(lon_model>180)=lon_model(lon_model>180)-360;
        
        % LON is from -180 to 180 because that is what is used to make the bagged
        % tree  MUST use lon_tpx to output array, becuse I didn't shift the array
        
        [LON,LAT]=ndgrid(lon_model,lat_tpx);
        [global_basins_aviso]=find_basin_paige(LON,LAT);
        [w_art,w_atl]=find_atlantic_artic_overlap_weights(global_basins_aviso,LON,LAT);
        
        
        pos_2d_pac_ind=global_basins_aviso(2).pos & global_basins_aviso(1).pos;
        pos_2d_atl_ind=global_basins_aviso(5).pos & global_basins_aviso(1).pos;
        pos_2d_pac_atl=global_basins_aviso(5).pos & global_basins_aviso(2).pos;
        
        LON=single(LON);
        LAT=single(LAT);
        ssh_total=single(ssh_total);
        sst_total=single(sst_total);
        
        % Ght=gpuArray(ht_estimate);
        yr_av=time_aviso;
        
        ht_year_total=[];
        nlayer=length(layer_bounds);
        nbasin=length(global_basins_aviso);
        'data_loaded'
        toc./60
      
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
%           for ilayer=start_sublayer(isublayer):end_sublayer(isublayer)

            time_aviso=yr_av;
           
            layer_name=[num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer))]
            tree_file_name=[tree_model_file_name_yearly,'_',layer_name];
          
            ht_estimate=nan(nlon_tpx,nlat_tpx,nfiles);
            [temp_use,~]=load_monthly_anom_temp(layer_bounds,path_mat_nc,tree_model_file_name_combined_temp,ilayer,time_aviso);

            for iyear_mod=min_tpx_year+.5:.5:max_tpx_year+.5
                     
                   
        
                year_file_name=num2str(10*iyear_mod)
                file_big_model=[path_new_tree_yearly,tree_model_file_name_yearly,'_model_',layer_name,'_',year_file_name,'_split.mat'];
                [model_all]=parload_model(file_big_model);   
                n_mod_basin=length(model_all);
               
                
        
                 for ibasin=nbasins_use
                    if ibasin<= n_mod_basin
                         M=model_all(ibasin).model;
                         
                    %      ht_estimate(good) = predict(M,input_table);
                         if ~isempty(M)
                            
                %           ibasin=laindex;
                            pos_2d=global_basins_aviso(ibasin).pos;
                            
                    %         global_basins_aviso(ibasin).name
                            
                            npos_2d=length(find(pos_2d(:)));
                            pos_3d=repmat(pos_2d,1,1,nfiles);
%                             jsst=double(sst_total(pos_3d));
                            jssh=double(ssh_total(pos_3d));
                            jtemp_use=double(temp_use(pos_3d));
                        
                        
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
                        
                                 
                                good_yr=(jyr>iyear_mod-.5 & jyr<= iyear_mod+.5);
                                good=isfinite(jyr) &isfinite(jssh)&good_yr;
                                pos_use=find(pos_3d);
                                pos_3d_use=pos_3d;
                                pos_3d_use(pos_use(~good))=0;
                                jyr_yearly=jyr(good);
                            
                                input_mat=nans(length(jyr_yearly),4);
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
                                
%                                 input_mat(:,4)=jssh(good);
%                                 input_mat(:,5)=jsst(good);
                                input_mat(:,4)=jtemp_use(good);
                                jw_use=jw(good);
                
                                % now weight for the yearly overlap
                
                                w_year=1-2.*abs(iyear_mod-jyr_yearly);
                                 %correct for the fact it is the last year and there is no
                                 %overlap
                                 if iyear_mod==end_yearly_maps
                                    w_year(jyr_yearly>=end_year)=1;
                                end
                                if iyear_mod==start_yearly_maps
                                    w_year(jyr_yearly<=start_year)=1;
                                end
                
                                jw_use=jw_use.*w_year;
                             
                                 ht_junk=predict(M,input_mat).*jw_use;
                                 
                                 ht_estimate(pos_3d_use) =sum(cat(2,ht_estimate(pos_3d_use),ht_junk),2,'omitnan');
                         end
                    end
                 

                end
                
                
            end
            
        
        
           
         
            if isplit==1
                good_split_1=time_aviso<=floor(mid_yearly_maps)+.5;
                ht_estimate=ht_estimate(:,:,good_split_1);
                time_aviso=time_aviso(good_split_1);

                %save ([path_tree_junk,tree_file_name,'_split_7day_junk.mat'] ,'ht_estimate','lon_tpx', 'lat_tpx','time_aviso','-v7.3')
                parsave_tree ([path_tree_junk,tree_file_name,'_split_7day_junk.mat'] ,ht_estimate,lon_tpx, lat_tpx,time_aviso)      
            else

                good_split_2=time_aviso>floor(mid_yearly_maps)+.5;
                
                ht_estimate=ht_estimate(:,:,good_split_2);
                time_aviso=time_aviso(good_split_2);
                ht_estimate_end=ht_estimate;
                time_aviso_end=time_aviso;
%                 load ([path_tree_junk,tree_file_name,'_split_7day_junk.mat'] ,'ht_estimate','time_aviso');
               
                [ht_estimate,time_aviso]=parload_tree([path_tree_junk,tree_file_name,'_split_7day_junk.mat'] );
                ht_estimate=cat(3,ht_estimate,ht_estimate_end);
                time_aviso=cat(2,time_aviso,time_aviso_end);
                


%                 save ([path_tree,tree_file_name,'_split_7day.mat'] ,'ht_estimate','lon_tpx', 'lat_tpx','time_aviso','-v7.3')
                 parsave_tree([path_tree,tree_file_name,'_split_7day.mat'],ht_estimate,lon_tpx, lat_tpx,time_aviso)
%                 delete([path_tree_junk,tree_file_name,'_split_7day_junk.mat'])
                pardelete_tree([path_tree_junk,tree_file_name,'_split_7day_junk.mat'])
               

            end
            
          end
    end
end
toc./60
'all done saving '

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
% % % end





