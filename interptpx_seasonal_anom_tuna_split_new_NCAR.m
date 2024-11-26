% tree_model_file_name='tree_sst_tpx_yearly_overlap_seasonal';
% path_OHCA_data_in='C:\OHCA\';
% file_path_in=path_OHCA_data_in;
% path_OHCA_data_out='C:\data\OHCA\'
% file_path_out=[path_OHCA_data_out,'OHCA_grided\'];
% path_tree=[path_OHCA_data_out,'OHCA_trees\'];
% path_new_tree=[path_tree,tree_model_file_name,'\'];
% file_name='argo_2020_10_14_QC';
% file_name_season=[file_name,'_seasonal'];
% file_name_season_anom=[file_name_season,'_anom'];
% file_WOD_suf='_cheng_EN4_2014';
% file_path_hdata=[path_OHCA_data_out,'OHCA_maps\'];
% layer_bounds=[0,40,90,190,290,450,700,950,1450,1950,2000];
% nlayer=length(layer_bounds);
% max_year=2019;
% min_year=2005;
% center_year=(max_year+min_year)./2;
% 
% 
% fname_nc_season=[file_path_hdata,'hdata_new_layers_',file_WOD_suf,'_',file_name_season];
% fname_nc=[file_path_hdata,'hdata_new_layers_',file_WOD_suf,'_',file_name_season_anom];
% load(fname_nc_season);

%%

varinfo=who('-file',fname_nc_season);
varnames=[];
for iname=1:length(varinfo)
    junk_name=varinfo{iname};
    if ~contains(junk_name,'diff')
        varnames=[varnames,junk_name,' '];

    end


end

eval(['load ',fname_nc_season,' ',varnames])



aviso_path=[path_ssh,'matlab_files/'];
d=dir([aviso_path, 'new_ssh*.mat']);
time_aviso_files=strjust(strvcat(d(:).name),'right');
time_aviso_files=str2num(time_aviso_files(:,end-8:end-4));
n_aviso_files=length(d);
% need to fix any coordinates that stray outside the range -180:180
ii=find(coords(:,1)>180);coords(ii,1)=coords(ii,1)-360;
ii=find(coords(:,1)<-180);coords(ii,1)=coords(ii,1)+360;

% time_aviso_argo=datenum(date(:,1),date(:,2),date(:,3))-datenum(1950,1,1);
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

[LON,LAT]=ndgrid(lon,lat);
[LON_180,~]=ndgrid(lon_180,lat);
  
% convert yeardays into aviso cycle
%  time_aviso_argo=((yr-floor(yr)).*yeardays(floor(yr)))+datenum(floor(yr),1,1)-datenum(1950,1,1);
%  time_aviso_argo=((yr-floor(yr)).*yeardays(floor(yr)))+datenum(floor(yr),1,1)-datenum(1950,1,1);
 time_aviso_argo=yr.*365+1-datenum(1950,1,1);
time_aviso_argo=floor(time_aviso_argo);
% time_aviso_argo=(yr-1992)*365.25+datenum(1992,1,1)-datenum(1950,1,1);



tpx=nans(nprof,1);


unq_aviso_day=unique(time_aviso_argo);
% don't try and find ssh before AVISO
% unq_aviso_day=unq_aviso_day(unq_aviso_day>=15000);
% sday=unq_aviso_day;


load([path_tree,tree_model_file_name_season,'_seasonal_cycle_tpx_split.mat'],...
    'amp_annual_total','phase_annual_total','amp_semi_total','phase_semi_total',...
    'amp_third_total','phase_third_total','slope_total','mean_total',...
    'time_aviso','lon_tpx','lat_tpx')
period=1;
period2=1/2;
period3=1/3;

% make grided INTERPOLANTS FOR BOTH 


% y_model=amp_annual*sin((2*pi*t./period)+phase_annual)+amp_semi*sin((2*t*pi./period2)+phase_semi)+...
%   amp_third*sin((2*pi*t./period3)+phase_third)+slope*t+mean;


for iaviso_cycle=unq_aviso_day'
    [~,pos_good_cycle]=min(abs(time_aviso_files-iaviso_cycle));
    time_file=time_aviso_files(pos_good_cycle(1));
    diff_days=iaviso_cycle-time_file;
    ssh_file=[aviso_path,'new_ssh',num2str(time_file),'.mat'];


    if exist(ssh_file,'file')&& abs(diff_days)<=10 % only grab ssh with in 10-days of profile
      load(ssh_file)
      %% linearly interpet in time before fitting
        if diff_days>0 && (pos_good_cycle(1)+1)<=n_aviso_files
            sshanom_old=sshanom;
            time_file_n=time_aviso_files(pos_good_cycle(1)+1);
            ssh_file_n=[aviso_path,'new_ssh',num2str(time_file_n),'.mat'];
            if exist(ssh_file_n,'file')
                load(ssh_file_n)
                
                w1=abs(time_file_n-iaviso_cycle);
                w2=abs(time_file-iaviso_cycle);
                sshanom=(w1.*sshanom_old+w2.*sshanom)./(w1+w2);
                clear sshanom_old
            end
        elseif diff_days<0 && (pos_good_cycle(1)-1)>=1
            sshanom_old=sshanom;
            time_file_n=time_aviso_files(pos_good_cycle(1)-1);
            ssh_file_n=[aviso_path,'new_ssh',num2str(time_file_n),'.mat'];
            if exist(ssh_file_n,'file')
                load(ssh_file_n)
                
                w1=abs(time_file_n-iaviso_cycle);
                w2=abs(time_file-iaviso_cycle);
                adt=(w1.*sshanom_old+w2.*sshanom)./(w1+w2);
                clear sshanom_old

            end
        end

      good_time=time_aviso_argo ==iaviso_cycle;
      good_all=good_time & ~good_180;
      good_all_180=good_time & good_180;
      good_t=yr(good_time);
      good_t=good_t(1);
      

      % remove the fitted mean and cycle but keep in the trend, however
      % because I fit the cycles with a mean and trend, must avaluate
      % season cycle for a given year
      ssh_seasonal_cycle=amp_annual_total.*sin((2*pi.*good_t./period)+phase_annual_total)+amp_semi_total.*sin((2.*good_t*pi./period2)+phase_semi_total)+...
            amp_third_total.*sin((2*pi.*good_t./period3)+phase_third_total)+mean_total+slope_total.*center_year;

      sshanom=sshanom-ssh_seasonal_cycle;

      sshanom_180=[sshanom(pos_aviso_180,:);sshanom(~pos_aviso_180,:)];
      F=griddedInterpolant(LON,LAT,sshanom);
      F_180=griddedInterpolant(LON_180,LAT,sshanom_180);
      jlon=lon_argo(good_all);
      jlat=lat_argo(good_all);
      jlon_180=lon_180_argo(good_all_180);
      jlat_180=lat_argo(good_all_180);
    
      tpx(good_all,1)=F(jlon,jlat);
      tpx(good_all_180,1)=F_180(jlon_180,jlat_180);
    
    end
  
end



% tpx(:,2)=tpx(:,1);

%  now remove the annual cycle from heat content data and compute
%  differnece estimats

'HT estiamte'
good_all= ~good_180;
good_all_180= good_180;
good_t=yr(good_all);
good_t_180=yr(good_all_180);

jlon=lon_argo(good_all);
jlat=lat_argo(good_all);
jlon_180=lon_180_argo(good_all_180);
jlat_180=lat_argo(good_all_180);
     

for ilayer=2:nlayer
    layer_name=[num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer))];
    tree_file_name=[tree_model_file_name_season,'_',layer_name];
    load([path_tree,tree_file_name,'_seasonal_cycle_split.mat'],...
        'amp_annual_total','phase_annual_total','amp_semi_total','phase_semi_total',...
        'amp_third_total','phase_third_total','slope_total','mean_total',...
        'time_aviso','lon_tpx','lat_tpx');
    eval(['jht=',var_type,'_',layer_name,';'])
    lon_tpx=double(lon_tpx);
    ht_seasonal_cycle=nans(nprof,1);

    pos_aviso_180=lon_tpx>180;
    lon_180=[lon_tpx(pos_aviso_180)-360 ; lon_tpx(~pos_aviso_180)];
    [LON,LAT]=ndgrid(lon_tpx,lat_tpx);
    [LON_180,~]=ndgrid(lon_180,lat);
    
    amp_annual_total_180=[amp_annual_total(pos_aviso_180,:);amp_annual_total(~pos_aviso_180,:)];
    amp_annual_F=griddedInterpolant(LON,LAT,amp_annual_total);
    amp_annual_F_180=griddedInterpolant(LON_180,LAT,amp_annual_total_180);
    amp_annual_ht=amp_annual_F(jlon,jlat);
    amp_annual_ht_180=amp_annual_F_180(jlon_180,jlat_180);
    
    
    phase_annual_total_180=[phase_annual_total(pos_aviso_180,:);phase_annual_total(~pos_aviso_180,:)];
    phase_annual_F=griddedInterpolant(LON,LAT,phase_annual_total);
    phase_annual_F_180=griddedInterpolant(LON_180,LAT,phase_annual_total_180);
    phase_annual_ht=phase_annual_F(jlon,jlat);
    phase_annual_ht_180=phase_annual_F_180(jlon_180,jlat_180);
    
    amp_semi_total_180=[amp_semi_total(pos_aviso_180,:);amp_semi_total(~pos_aviso_180,:)];
    amp_semi_F=griddedInterpolant(LON,LAT,amp_semi_total);
    amp_semi_F_180=griddedInterpolant(LON_180,LAT,amp_semi_total_180);
    amp_semi_ht=amp_semi_F(jlon,jlat);
    amp_semi_ht_180=amp_semi_F_180(jlon_180,jlat_180);
    
    phase_semi_total_180=[phase_semi_total(pos_aviso_180,:);phase_semi_total(~pos_aviso_180,:)];
    phase_semi_F=griddedInterpolant(LON,LAT,phase_semi_total);
    phase_semi_F_180=griddedInterpolant(LON_180,LAT,phase_semi_total_180);
    phase_semi_ht=phase_semi_F(jlon,jlat);
    phase_semi_ht_180=phase_semi_F_180(jlon_180,jlat_180);
    
    amp_third_total_180=[amp_third_total(pos_aviso_180,:);amp_third_total(~pos_aviso_180,:)];
    amp_third_F=griddedInterpolant(LON,LAT,amp_third_total);
    amp_third_F_180=griddedInterpolant(LON_180,LAT,amp_third_total_180);
    amp_third_ht=amp_third_F(jlon,jlat);
    amp_third_ht_180=amp_third_F_180(jlon_180,jlat_180);
    
    phase_third_total_180=[phase_third_total(pos_aviso_180,:);phase_third_total(~pos_aviso_180,:)];
    phase_third_F=griddedInterpolant(LON,LAT,phase_third_total);
    phase_third_F_180=griddedInterpolant(LON_180,LAT,phase_third_total_180);
    phase_third_ht=phase_third_F(jlon,jlat);
    phase_third_ht_180=phase_third_F_180(jlon_180,jlat_180);
    
    mean_total_180=[mean_total(pos_aviso_180,:);mean_total(~pos_aviso_180,:)];
    mean_F=griddedInterpolant(LON,LAT,mean_total);
    mean_F_180=griddedInterpolant(LON_180,LAT,mean_total_180);
    mean_ht=mean_F(jlon,jlat);
    mean_ht_180=mean_F_180(jlon_180,jlat_180);
    
    slope_total_180=[slope_total(pos_aviso_180,:);slope_total(~pos_aviso_180,:)];
    slope_F=griddedInterpolant(LON,LAT,slope_total);
    slope_F_180=griddedInterpolant(LON_180,LAT,slope_total_180);
    slope_ht=slope_F(jlon,jlat);
    slope_ht_180=slope_F_180(jlon_180,jlat_180);


    ht_seasonal_cycle(good_all,1)=amp_annual_ht.*sin((2*pi.*good_t./period)+phase_annual_ht)+amp_semi_ht.*sin((2.*good_t*pi./period2)+phase_semi_ht)+...
            amp_third_ht.*sin((2*pi.*good_t./period3)+phase_third_ht)+mean_ht+slope_ht.*center_year;

    ht_seasonal_cycle(good_all_180,1)=amp_annual_ht_180.*sin((2*pi.*good_t_180./period)+phase_annual_ht_180)+amp_semi_ht_180.*sin((2.*good_t_180*pi./period2)+phase_semi_ht_180)+...
            amp_third_ht_180.*sin((2*pi.*good_t_180./period3)+phase_third_ht_180)+mean_ht_180+slope_ht_180.*center_year;

    jht=jht-ht_seasonal_cycle;





    eval([var_type,'_',layer_name,'=jht;'])

    

end



eval(['save ',fname_nc,' ',varnames,'-v7.3'])



