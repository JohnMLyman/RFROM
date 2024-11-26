tic
file_name='argo_2020_10_14_QC';
tree_model_file_name='baggedtree_sst_tpx_all2_year';
tree_model_file_name='tree_sst_tpx_year_1993';
tree_model_file_name='tree_sst_tpx_yearly';
path_oisst='C:\data\oisst\';
file_name_argo='pfloat_sal_greg_oct_2021_QC'
path_OHCA_data_out='C:\data\OHCA\'
path_OHCA_data_in='C:\OHCA\'

 layer_bounds=[0,40,90,190,290,450,700,950,1450,1950,2000];
file_name='argo_2020_10_14_QC';
path_tree=[path_OHCA_data_out,'OHCA_trees\'];
path_new_tree=[path_tree,tree_model_file_name,'\'];

file_path_out=[path_OHCA_data_out,'OHCA_grided\'];
path_ssh=[path_OHCA_data_in,'Mtpers\'];
% eval(['load  ',path_ssh,'meanssh_oco_realtime_',file_name,'.mat  lat lon gmo sshcyc '])
% eval(['load ',file_path_out,file_name,'_','aviso_oco aviso']);
eval(['load ',file_path_out,file_name,'_','aviso_cycle lon lat sshcyc']);


s=dir([path_ssh,'matlab_files\ssh*.mat']);
nfiles=length(s);
sday=strjust(strvcat(s(:).name),'right');
sday=str2num(sday(:,end-8:end-4));


sday=sday+datenum(1950,1,1);
datevec_sday=datevec(sday);
aviso_day=sday-datenum(datevec_sday(:,1),1,1)+1;
syr=datevec_sday(:,1)+(aviso_day-1)./yeardays(datevec_sday(:,1));
aviso_mon=datevec_sday(:,2);
clear sday

lat_tpx=lat;
lon_tpx=lon;
% lon=lon';
% lon_tpx=[lon(721:end)-360;lon(1:720)];
% sshcyc=[sshcyc(721:end,:,:);sshcyc(1:720,:,:)];

clear lon lat




% eval(['load ',path_ssh,'landmask msk2'])




min_tpx_year=min(datevec_sday(:,1));
max_tpx_year=max(datevec_sday(:,1));
tgrid=min_tpx_year+.5:max_tpx_year+.5;
nyears=length(tgrid);


nlat_tpx=length(lat_tpx);
nlon_tpx=length(lon_tpx);



ssh_total=nans(nlon_tpx,nlat_tpx,nfiles);
sst_total=ssh_total;
time_aviso=nans(1,nfiles);
for iyear=1:nyears 
    iyear
    yr_name=num2str(floor(tgrid(iyear)));
    sst_anom_year=double(ncread([path_oisst,'sst.day.anom.',yr_name,'.v2.nc'],'anom'));
    sst_anom_year(sst_anom_year<= -9.9692e+36)=nan;
    sst_time=double(ncread([path_oisst,'sst.day.anom.',yr_name,'.v2.nc'],'time'));
    sst_time=sst_time-min(sst_time)+1;
    max_sst_time=max(sst_time);
    sshave=zeros(length(lon_tpx),length(lat_tpx));
    
    ii=find(-.5<=(tgrid(iyear)-syr) & (tgrid(iyear)-syr)<.5);
  for j=1:length(ii)
     ifile=ii(j);
    load([s(ifile).folder,'\',s(ifile).name],'sshanom')

    junk_mon=aviso_mon(ii(j));
    junk_day=aviso_day(ii(j));
    sshc=squeeze(sshcyc(:,:,junk_mon));
    
%     sshanom=[sshanom(721:end,:);sshanom(1:720,:)];
    sshanom=sshanom-sshc;
    ssh_total(:,:,ifile)=sshanom;
    if junk_day<=max_sst_time
        sst_total(:,:,ifile)=sst_anom_year(:,:,junk_day);
    end
    
    time_aviso(ifile)=syr(ifile);
    
    
  end  %for months



  
  
end % for years  






% load('test_tree_model_mat.mat')

lon_model=lon_tpx;
lon_model(lon_model>180)=lon_model(lon_model>180)-360;

% LON is from -180 to 180 because that is what is used to make the bagged
% tree  MUST use lon_tpx to output array, becuse I didn't shift the array

[LON,LAT]=ndgrid(lon_model,lat_tpx);
[global_basins_aviso]=find_basin_paige(LON,LAT);



pos_2d_pac_ind=global_basins_aviso(2).pos & global_basins_aviso(1).pos;
pos_2d_atl_ind=global_basins_aviso(5).pos & global_basins_aviso(1).pos;
pos_2d_pac_atl=global_basins_aviso(5).pos & global_basins_aviso(2).pos;



% Ght=gpuArray(ht_estimate);
yr_av=time_aviso;

ht_year_total=[];
nlayer=length(layer_bounds);
nbasin=length(global_basins_aviso);
'data_loaded'
toc./60
start_year=1993;
end_year=2021;

for ilayer=2:nlayer
   
    tic
    layer_name=[num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer))]
    ht_estimate=nan(nlon_tpx,nlat_tpx,nfiles);
    tree_file_name=[tree_model_file_name,'_',layer_name];


    for iyear_mod=start_year:end_year
                year_file_name=num2str(iyear_mod)
                file_big_model=[path_new_tree,tree_model_file_name,'_model_',layer_name,'_',year_file_name,'.mat'];
%                 file_compact_model=[path_new_tree,tree_model_file_name,'_compact_model_',layer_name,'_',year_file_name,'.mat'];
                load(file_big_model,'model_all')     
                n_mod_basin=length(model_all);
    
        for ibasin=1:nbasin
           
            pos_2d=global_basins_aviso(ibasin).pos;
            
%             global_basins_aviso(ibasin).name
            
            npos_2d=length(find(pos_2d(:)));
            pos_3d=repmat(pos_2d,1,1,nfiles);
            jsst=sst_total(pos_3d);
            jssh=ssh_total(pos_3d);
        
        
            jyr=repmat(yr_av,npos_2d,1);
            jyr=jyr(:);
           
            jlon=repmat(LON(pos_2d),nfiles,1);
            jlat=repmat(LAT(pos_2d),nfiles,1);
            
            % compute weights so there is a linear transition at the overlaps of
            % the Atlantic, Pacific and Indian Oceans.
        
            weight_cross=ones(nlon_tpx,nlat_tpx);
            
        
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
        
    
               
                good_yr=floor(jyr)==iyear_mod;
                good=isfinite(jyr) & isfinite(jsst)&isfinite(jssh)&good_yr;
                pos_use=find(pos_3d);
                pos_3d_use=pos_3d;
                pos_3d_use(pos_use(~good))=0;
                jyr_yearly=jyr(good);
            
                input_mat=nans(length(jyr_yearly),5);
                input_mat(:,1)=jyr_yearly;
                input_mat(:,2)=jlon(good);
                input_mat(:,3)=jlat(good);
                input_mat(:,4)=jssh(good);
                input_mat(:,5)=jsst(good);
                jw_use=jw(good);
             
            
                
            
               
                
            
            %     input_table=table(jyr(good),jlon(good),jlat(good),jssh(good),jsst(good),'VariableNames',var_names);
                
                if ibasin<= n_mod_basin
                     M=model_all(ibasin).model;
                     
                %      ht_estimate(good) = predict(M,input_table);
                     if ~isempty(M)
                
                %          tic
                %          Ginput_mat=gpuArray(input_mat);
                %          Gjw=gpuArray(jw);
                %          Ght_junk=predict(M,Ginput_mat).*Gjw(good);
                %          ht_junk=gather(Ght_junk);
                %          toc
                        
                         
                         ht_junk=predict(M,input_mat).*jw_use;
                         
                         ht_estimate(pos_3d_use) =nansum(cat(2,ht_estimate(pos_3d_use),ht_junk),2);
                     end
                end
            
        end
        clear jyr jlon jlat jssh jsst
        toc./60
    end
    
    
    
    
    eval(['save -v7.3 ',path_tree,tree_file_name,'_10day.mat ht_estimate lon_tpx lat_tpx time_aviso'])
    % tgrid=min_tpx_year+.5:.5:max_tpx_year+.5;
    % nyears=length(tgrid);
    % ht_out=nans(nlon_tpx,nlat_tpx,nyears);
    % for itime=1:nyears
    %     jyear=tgrid(itime);
    %     ht_out(:,:,itime)=nansum(ht_estimate(:,:,time_aviso<jyear+.5&time_aviso>=jyear-.5),3);
    % 
    % end
    % eval([ht_year,'=ht_out;'])
    % 'average model'
    toc./60
end


'all done saving '
% eval(['save -v7.3 ',path_tree,tree_model_file_name,'_anual.mat',ht_year_total,' layer_bounds lon_tpx lat_tpx tgrid'])

% eval(['save -v7.3 ',path_tree,tree_model_file_name,'_anual_test.mat ht_0_40 ht_40_90 layer_bounds lon_tpx lat_tpx tgrid'])
