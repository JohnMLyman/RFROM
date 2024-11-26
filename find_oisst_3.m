function [sst]=find_oisst_3(lon,lat,yr)

path_oisst='C:\data\oisst\';
min_year=1982;
max_year=2021;
nprof=length(lat);
sst=nan(nprof,1);

lat_sst=double(ncread([path_oisst,'sst.day.anom.1990.v2.nc'],'lat'));
lon_sst=double(ncread([path_oisst,'sst.day.anom.1990.v2.nc'],'lon'));

pos_shift=find(lon_sst>180);

lon_sst_180=[lon_sst(pos_shift)-360;lon_sst(1:pos_shift(1)-1)];

% % % time_sst=ncread([path_oisst,'sst.day.anom.1990.nc'],'time');
% % % 
% % % time_sst=time_sst+datenum(1800,1,1);
tic
yr_name=num2str(min_year-1);
sst_old=ncread([path_oisst,'sst.day.anom.',yr_name,'.v2.nc'],'anom');
  

  sst_old=double(sst_old);
  sst_old(sst_old<= -9.9692e+36)=nan;   
  sst_old_180=[sst_old(pos_shift,:,:);sst_old(1:pos_shift(1)-1,:,:)];

for yr_value=min_year:max_year

   
  disp(yr_value)
  good_prof=find(floor(yr)==yr_value);
  

  yr_name=num2str(yr_value);
  


  
  sst_anom_year=ncread([path_oisst,'sst.day.anom.',yr_name,'.v2.nc'],'anom');
 

  sst_anom_year=double(sst_anom_year);
  sst_anom_year(sst_anom_year<= -9.9692e+36)=nan;   
  sst_180_anom_year=[sst_anom_year(pos_shift,:,:);sst_anom_year(1:pos_shift(1)-1,:,:)];

  time=ncread([path_oisst,'sst.day.anom.',yr_name,'.v2.nc'],'time');
  time=time-min(time)+1;
  ntime=length(time);

 
 sst_anom_year=cat(3,sst_old(:,:,end),sst_anom_year);
 sst_180_anom_year=cat(3,sst_old_180(:,:,end),sst_180_anom_year);
 time=[0;time];
 
  [LON,LAT,TIME]=ndgrid(lon_sst,lat_sst,time);
  [LON_180,~,~]=ndgrid(lon_sst_180,lat_sst,time);
  F=griddedInterpolant(LON,LAT,TIME,sst_anom_year);
  F_180=griddedInterpolant(LON_180,LAT,TIME,sst_180_anom_year);


  lonp_pick=lon(good_prof);
  
  pos_junk_180=good_prof((lonp_pick>-90 & lonp_pick<90));
  pos_junk=good_prof(~(lonp_pick>-90 & lonp_pick<90));
  lonp=lon(pos_junk);
  lonp(lonp<0)=lonp(lonp<0)+360;
  latp=lat(pos_junk);
  timep=(yr(pos_junk)-yr_value).*ntime;
  

  lonp_180=lon(pos_junk_180);
  latp_180=lat(pos_junk_180);
  timep_180=(yr(pos_junk_180)-yr_value).*ntime;
  timep_180(timep_180<1)=1;
  

  sst(pos_junk_180)=F_180(lonp_180,latp_180,timep_180);
  sst(pos_junk)=F(lonp,latp,timep);

  sst_old=sst_anom_year;
  sst_old_180=sst_180_anom_year;
 toc
end







