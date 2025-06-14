function interptpx_seasonal_orca_temp_NCAR(OcoSetUp)

%%



t_var_name=OcoSetUp.t_var_name;
path_NCAR_SSH_out=OcoSetUp.path_NCAR_SSH_out;

file_name_season=OcoSetUp.file_name_season;
file_path_hdata=OcoSetUp.file_path_hdata;
file_WOD_suf=OcoSetUp.file_WOD_suf;
fname_nc=[file_path_hdata,'tdata_new_layers_',file_WOD_suf,'_',file_name_season,'.mat'];

%%



eval(['load ',fname_nc,' yr coords ',t_var_name])



aviso_path=path_NCAR_SSH_out;
d=dir([aviso_path, 'new_ssh*.mat']);
time_aviso_files=strjust(strvcat(d(:).name),'right');
time_aviso_files=str2num(time_aviso_files(:,end-8:end-4));
n_aviso_files=length(d);
% need to fix any coordinates that stray outside the range -180:180
ii=find(coords(:,1)>180);coords(ii,1)=coords(ii,1)-360;
ii=find(coords(:,1)<-180);coords(ii,1)=coords(ii,1)+360;


yr_file=floor(yr);

time_aviso_argo=round(365*(yr_file)+((yr-yr_file).*365)+1);
   
%     
time_aviso_argo=time_aviso_argo-datenum(1950,1,1);

lon_argo=coords(:,1);
lat_argo=coords(:,2);
lon_180_argo=lon_argo;
lon_argo(lon_argo<0)=lon_argo(lon_argo<0)+360;
nprof=length(lon_argo);

good_180=lon_180_argo>-90 & lon_180_argo<90;


% compute,save and remove the mean (same as Argo)
load([aviso_path,d(1).name],'lat','lon')
lon=double(lon);
pos_aviso_180=lon>180;
lon_180=[lon(pos_aviso_180)-360 ; lon(~pos_aviso_180)];
lat=double(lat);

[LON,LAT]=ndgrid(lon,lat);
[LON_180,~]=ndgrid(lon_180,lat);
%JML 6/27/2023 to include black sea and caspin sea which dont have means
 [global_basins_aviso]=find_basin_paige(LON,LAT);


topex=nans(nprof,2);

tic
unq_aviso_day=unique(time_aviso_argo);
% don't try and find ssh before AVISO
% unq_aviso_day=unq_aviso_day(unq_aviso_day>=15000);
for iaviso_cycle=unq_aviso_day'
    [~,pos_good_cycle]=min(abs(time_aviso_files-iaviso_cycle));
    time_file=time_aviso_files(pos_good_cycle(1));
    diff_days=iaviso_cycle-time_file;

    ssh_file=[aviso_path,'new_ssh',num2str(time_file),'.mat'];
    if exist(ssh_file,'file') && abs(diff_days)<=10 % only grab ssh with in 10-days of profile
      
        load(ssh_file)
        %% linearly interpet in time before fitting
        if diff_days>0 && (pos_good_cycle(1)+1)<=n_aviso_files
            adt_old=adt;
            time_file_n=time_aviso_files(pos_good_cycle(1)+1);
            ssh_file_n=[aviso_path,'new_ssh',num2str(time_file_n),'.mat'];
            if exist(ssh_file_n,'file')
                load(ssh_file_n)
                
                w1=abs(time_file_n-iaviso_cycle);
                w2=abs(time_file-iaviso_cycle);
                adt=(w1.*adt_old+w2.*adt)./(w1+w2);
                clear adt_old
            end
        elseif diff_days<0 && (pos_good_cycle(1)-1)>=1
            adt_old=adt;
            time_file_n=time_aviso_files(pos_good_cycle(1)-1);
            ssh_file_n=[aviso_path,'new_ssh',num2str(time_file_n),'.mat'];
            if exist(ssh_file_n,'file')
                load(ssh_file_n)
                
                w1=abs(time_file_n-iaviso_cycle);
                w2=abs(time_file-iaviso_cycle);
                adt=(w1.*adt_old+w2.*adt)./(w1+w2);
                clear adt_old

            end
        end


            
% only use delyed mode aviso for the mean.  realitime adt is spikey
      if ~exist('offset_adt','var')
%JML 6/27/2023 to include black sea and caspin sea which dont have means 
          adt(global_basins_aviso(10).pos|global_basins_aviso(6).pos)=sshanom(global_basins_aviso(10).pos|global_basins_aviso(6).pos);
          good_time=time_aviso_argo ==iaviso_cycle;
          good_all=good_time & ~good_180;
          good_all_180=good_time & good_180;
          
    
          adt_180=[adt(pos_aviso_180,:);adt(~pos_aviso_180,:)];
          F=griddedInterpolant(LON,LAT,adt);
          F_180=griddedInterpolant(LON_180,LAT,adt_180);
          jlon=lon_argo(good_all);
          jlat=lat_argo(good_all);
          jlon_180=lon_180_argo(good_all_180);
          jlat_180=lat_argo(good_all_180);
        
          topex(good_all,1)=F(jlon,jlat);
          topex(good_all_180,1)=F_180(jlon_180,jlat_180);
      end
      clear offset_sla offset_adt
    end


  

  
  
end



topex(:,2)=topex(:,1);




tpx=topex(:,1);
% tpx(isnan(tpx))=0;


% day=datenum([dt,tm,tm*0,tm*0])-datenum(1950,1,1);




eval(['save ',fname_nc,' tpx yr coords ',t_var_name])
