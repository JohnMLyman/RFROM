function read_ssh_matfiles_yearly_overlap_seasonal_split_new_sal(TreeSetUp)
%%
% Loads Set up
load_TreeSetUp_new_sal

tic
% mid_mean_maps=(start_year_mean+end_year_mean)./2;
% tree_model_file_name='tree_sst_tpx_yearly_overlap_seasonal';
% path_oisst='C:\data\oisst\';
% file_name_argo='pfloat_sal_greg_oct_2021_QC'
% path_OHCA_data_out='C:\data\OHCA\'
% path_OHCA_data_in='C:\OHCA\'
% 
%  layer_bounds=[0,40,90,190,290,450,700,950,1450,1950,2000];
% file_name='argo_2020_10_14_QC';
% file_name_season=[file_name,'_seasonal'];
% path_tree=[path_OHCA_data_out,'OHCA_trees\'];
% path_new_tree=[path_tree,tree_model_file_name_season,'\'];
% 
% file_path_out=[path_OHCA_data_out,'OHCA_grided\'];
% path_ssh=[path_OHCA_data_in,'Mtpers\'];



s_allfiles=dir([path_ssh,'matlab_files\new_ssh*.mat']);
s=s_allfiles(1:7:length(s_allfiles));
% nfiles=length(s);
sday=strjust(strvcat(s(:).name),'right');
sday=str2num(sday(:,end-8:end-4));


sday=sday+datenum(1950,1,1);
datevec_sday=datevec(sday);
aviso_day=sday-datenum(datevec_sday(:,1),1,1)+1;
syr=datevec_sday(:,1)+(aviso_day-1)./yeardays(datevec_sday(:,1));
aviso_mon=datevec_sday(:,2);
clear sday

load([s(1).folder,'\',s(1).name],'lat','lon')
lat_tpx=lat;
lon_tpx=lon;
% lon=lon';
% lon_tpx=[lon(721:end)-360;lon(1:720)];
% sshcyc=[sshcyc(721:end,:,:);sshcyc(1:720,:,:)];

clear lon lat




% eval(['load ',path_ssh,'landmask msk2'])




% min_tpx_year=min(datevec_sday(:,1));
% max_tpx_year=max(datevec_sday(:,1));
% tgrid=min_tpx_year+.5:max_tpx_year+.5;
% nyears=length(tgrid);


nlat_tpx=length(lat_tpx);
nlon_tpx=length(lon_tpx);

syr_total=syr;
s_total=s;
aviso_day_total=aviso_day;

sst_total_old=[];
ssh_total_old=[];
time_aviso_old=[];
%%
nlayer=length(layer_bounds);

for ilayer=2:nlayer
    eval(['ht_estimate_old_',num2str(ilayer),'=[];'])

end

for iyear=start_year_mean:.5:end_year_mean
        
        if iyear==start_year_mean || mod(iyear,1)==0
               
                
                syr=syr_total;
                s=s_total;
                aviso_day=aviso_day_total;
        
                tgrid=iyear;
                if mod(iyear,1)==0
                    tgrid=iyear+.5;
                end
               
                
                good_tpx_files=find(-.5+tgrid<=(syr) & (syr)<.5+tgrid);
                syr=syr(good_tpx_files);
                s=s(good_tpx_files);
                aviso_day=aviso_day(good_tpx_files);
                nfiles_new=length(syr);
        
                ssh_total=nans(nlon_tpx,nlat_tpx,nfiles_new);
                sst_total=ssh_total;
                time_aviso=nans(1,nfiles_new);
        
                
                yr_name=num2str(floor(tgrid));
                sst_anom_year=double(ncread([path_oisst,'sst.day.mean.',yr_name,'.nc'],'sst'));
                sst_anom_year(sst_anom_year<= -9.9692e+36)=nan;
                sst_time=double(ncread([path_oisst,'sst.day.mean.',yr_name,'.nc'],'time'));
                sst_time=sst_time-min(sst_time)+1;
                max_sst_time=max(sst_time);
        %             sshave=zeros(length(lon_tpx),length(lat_tpx));
                    
                ii=find(-.5<=(syr-tgrid) & (syr-tgrid)<.5);
                for j=1:length(ii)
                    ifile=ii(j);
                    load([s(ifile).folder,'\',s(ifile).name])
                    junk_day=aviso_day(ii(j));
            
                    if ~exist('offset_adt','var') 
                        % only take delayed mode ssh for the means fine for the anomly
                        ssh_total(:,:,ifile)=adt;
                        if junk_day<=max_sst_time
                            sst_total(:,:,ifile)=sst_anom_year(:,:,junk_day);
                        end
                        time_aviso(ifile)=syr(ifile);
                    end
                    clear offsset_adt
                end
    
                % add on the bit from the year before
           sst_total=cat(3,sst_total_old,sst_total);
           ssh_total=cat(3,ssh_total_old,ssh_total);
           time_aviso=cat(2,time_aviso_old,time_aviso);
           % new sice of 
    
%             s_sst_total=size(sst_total);
            

%             nfiles=s_sst_total(3);
    
                
        else
            sst_total=sst_total_old;
           ssh_total=ssh_total_old;
           time_aviso=time_aviso_old;
%            s_sst_total=size(sst_total);
%            nfiles=s_sst_total(3);
        
        end
        good_aviso= isfinite(time_aviso);
        sst_total=sst_total(:,:,good_aviso);
        ssh_total=ssh_total(:,:,good_aviso);
        time_aviso=time_aviso(good_aviso);
        s_sst_total=size(sst_total);
        nfiles=s_sst_total(3);
        clearvars good_aviso
        
        
        
  %%        
          
         
        
        
        
        
        
        
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
        
        
        
        % Ght=gpuArray(ht_estimate);
        yr_av=time_aviso;
        
        ht_year_total=[];
        
        nbasin=length(global_basins_aviso);
        'data_loaded'
        toc./60
        clearvars temp_use*
            for ilayer=2:nlayer 
                time_aviso=yr_av;
                tic
                layer_name=[num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer))]
                tree_file_name_season=[tree_model_file_name_season,'_',layer_name];
              %CHECK THIS SECTION!!! MAKE SURE IT MAKES SENSE!!!
    
               if iyear==start_year_mean || mod(iyear,1)==0 
    
                ht_estimate=nan(nlon_tpx,nlat_tpx,nfiles_new);
                eval(['ht_estimate=cat(3,ht_estimate_old_',num2str(ilayer),',ht_estimate);'])
               else
                   eval(['ht_estimate=ht_estimate_old_',num2str(ilayer),';'])
               end
    
                iyear_mod=iyear;
            %     start_year=2004;
            %     end_year=2021;
    
            %%  load in the mean temperature maps
            
            top_level_use=min(ilayer-1,nlayer_use+1)-1;
            bot_level_use=min(nlayer-ilayer,nlayer_use);
            nextra_layers=top_level_use+bot_level_use;
            
            if exist('temp_use_deep_1','var')
                temp_use_old=temp_use;
                temp_use=temp_use_deep_1;
            else
                [temp_use,~]=load_monthly_mean_temp(layer_bounds,path_mat_nc,tree_prefix_temp,ilayer,time_aviso);
            end
    
            if exist('temp_use_old','var')
                temp_use_shallow_1=temp_use_old;
            elseif ilayer>=3
                ilayer_off=ilayer-1;
                [temp_use_shallow_1,~]=load_monthly_mean_temp(layer_bounds,path_mat_nc,tree_prefix_temp,ilayer_off,time_aviso);
            end
    
            for ilayer_extra=2:top_level_use
                    ilayer_off=ilayer-ilayer_extra;
                if exist(['temp_use_shallow_',num2str(ilayer_extra-1)],'var')
                    eval(['temp_use_shallow_',num2str(ilayer_extra),'=','temp_use_shallow_',num2str(ilayer_extra-1),';'])
                else
                        [temp,~]=load_monthly_mean_temp(layer_bounds,path_mat_nc,tree_prefix_temp,ilayer_off,time_aviso);
                        eval(['temp_use_shallow_',num2str(ilayer_extra),'=temp;'])
                end
                    
             end
    
            % compute the deep layer temp
            for ilayer_extra=1:bot_level_use
                ilayer_off=ilayer+ilayer_extra;
    %             layer_name_extra=[num2str(layer_bounds(ilayer_off-1)),'_',num2str(layer_bounds(ilayer_off))]
    %             [temp,~]=load_monthly_mean_temp(layer_bounds,path_mat_nc,tree_prefix_temp,ilayer_off,time_aviso);
    %             eval(['temp_use_deep_',num2str(ilayer_extra),'=temp;'])
    
                if exist(['temp_use_deep_',num2str(ilayer_extra+1)],'var')
                    eval(['temp_use_deep_',num2str(ilayer_extra),'=','temp_use_deep_',num2str(ilayer_extra+1),';'])
                else
                        [temp,~]=load_monthly_mean_temp(layer_bounds,path_mat_nc,tree_prefix_temp,ilayer_off,time_aviso);
                        eval(['temp_use_deep_',num2str(ilayer_extra),'=temp;'])
                end
            end
            
            %%
            
            
    %              for iyear_mod=min_tpx_year+.5:.5:max_tpx_year+.5
                    year_file_name=num2str(10*iyear_mod)
                    file_big_model=[path_new_tree_season,tree_model_file_name_season,'_model_',layer_name,'_',year_file_name,'_split.mat'];
                    load(file_big_model,'model_all')     
    
                    %% load in temperature data
                 
                         
                       
            
                   
                    n_mod_basin=length(model_all);
                    for ibasin=nbasins_use
                         tic
                         if ibasin<= n_mod_basin
                             M=model_all(ibasin).model;
                             
                        %      ht_estimate(good) = predict(M,input_table);
                             if ~isempty(M)
                       
                                pos_2d=global_basins_aviso(ibasin).pos;
                                
                        %         global_basins_aviso(ibasin).name
                                
                                npos_2d=length(find(pos_2d(:)));
                                pos_3d=repmat(pos_2d,1,1,nfiles);
                                jsst=sst_total(pos_3d);
                                jssh=ssh_total(pos_3d);
                                jtemp_use=temp_use(pos_3d);
    
                                for ilayer_extra=1:top_level_use
                                    eval(['jtemp_use_shallow_',num2str(ilayer_extra),'=temp_use_shallow_',num2str(ilayer_extra),'(pos_3d);'])
                                end
                    
                            % compute the deep layer temp
                                for ilayer_extra=1:bot_level_use
                                    eval(['jtemp_use_deep_',num2str(ilayer_extra),'=temp_use_deep_',num2str(ilayer_extra),'(pos_3d);'])
                                    
                                end
                            
                            
                                jyr=repmat(yr_av,npos_2d,1);
                                jyr=jyr(:);
                               
                                jlon=repmat(LON(pos_2d),nfiles,1);
                                jlat=repmat(LAT(pos_2d),nfiles,1);
                                
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
                                
                                    input_mat=nans(length(jyr_yearly),6+nextra_layers);
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
                                    input_mat(:,6)=jtemp_use(good);
                                    ilayer_extra_tot=6;
                                    for ilayer_extra=1:top_level_use
                                        ilayer_extra_tot=ilayer_extra_tot+1;
                                        eval(['input_mat(:,ilayer_extra_tot)=jtemp_use_shallow_',num2str(ilayer_extra),'(good);'])
                                    end
                            
                                    % input the deep layer temp for holdout
                                    for ilayer_extra=1:bot_level_use
                                         ilayer_extra_tot=ilayer_extra_tot+1;
                                        eval(['input_mat(:,ilayer_extra_tot)=jtemp_use_deep_',num2str(ilayer_extra),'(good);'])
                                    end
    
    
    
    
    
                                    jw_use=jw(good);
                    
                                    % now weight for the yearly overlap
                    
                                    w_year=1-2.*abs(iyear_mod-jyr_yearly);
                    
                                     %correct for the fact it is the last year and there is no
                                     %overlap
                                    if iyear_mod==end_year_mean
                                        w_year(jyr_yearly>=end_year_mean)=1;
                                    end
                                    if iyear_mod==start_year_mean
                                        w_year(jyr_yearly<=start_year_mean)=1;
                                    end
                    
                                    jw_use=jw_use.*w_year;
                                 
                      
                                         
                                 ht_junk=predict(M,input_mat).*jw_use;
                                 
                                 ht_estimate(pos_3d_use) =sum(cat(2,ht_estimate(pos_3d_use),ht_junk),2,'omitnan');
                             end
                        end
                   
                     
                    end
                     clearvars jyr jlon jlat jssh jsst jtemp_use*
                     toc./60
    
                     % this part makes the subsects the 
    
    
    
                     
                     if mod(iyear,1)==0 || iyear==end_year_mean
                         if iyear==end_year_mean
                             name_year=num2str(floor(iyear));
                             good_old=time_aviso>=iyear+.5;
                         else
                             name_year=num2str(floor(iyear)-1);
                             good_old=time_aviso>=floor(iyear);
                         end
                        
                        
                        time_aviso_old=time_aviso(good_old);
                      
                        eval(['ht_estimate_old_',num2str(ilayer),'=ht_estimate(:,:,good_old);'])
                        ht_estimate=ht_estimate(:,:,~good_old);
                        time_aviso_hold=time_aviso;
                        time_aviso=time_aviso(~good_old);
                        % CHANGE THE FILE NAME IN THE SAVE STATEMENT!!!! ALSO
                        % CHECK TO MAKE SUER THAT HT_ESTIMATE AND TIME_AVISO
                        % ARE CORRECT
    
                      save ([path_tree_junk,'netcdf\sal\matlab\mean_sal_yearly\',tree_file_name_season,'_',name_year,'.mat'] ,'ht_estimate','lon_tpx', 'lat_tpx','time_aviso','-v7.3')
                       time_aviso=time_aviso_hold;
                     else
                         eval(['ht_estimate_old_',num2str(ilayer),'=ht_estimate;'])
                     end


            end
                  if mod(iyear,1)==0
                      good_old=time_aviso>=iyear;
                     time_aviso_old=time_aviso(good_old);
                     ssh_total_old=ssh_total(:,:,good_old);
                     sst_total_old=sst_total(:,:,good_old);
                  else
                      time_aviso_old=time_aviso;
                     ssh_total_old=ssh_total;
                     sst_total_old=sst_total;
                  end

          clear model_all

end % end of year
        
        

            toc./60
      


