function [sst]=find_oisst_4_test(lonp,latp,yr)
% it is assumed that is input lon is -180 to 180




path_oisst='C:\data\oisst\';
min_year=1982;
max_year=2021;
distancescale=100./111.; %in degress lat
timescale=30; % in days
nprof=length(latp);
sst=nan(nprof,1);

lat_sst=double(ncread([path_oisst,'sst.day.anom.1990.v2.nc'],'lat'));
lon_sst=double(ncread([path_oisst,'sst.day.anom.1990.v2.nc'],'lon'));

pos_shift=lon_sst>180;

lon_sst_180=[lon_sst(pos_shift)-360;lon_sst(~pos_shift)];
pos_use_180=lonp>-90 & lonp<90;
pos_use_360=~(lonp>-90 & lonp<90);
lonp_360=lonp;
lonp_360(lonp_360<0)=lonp_360(lonp_360<0)+360;
lonp_180=lonp;
timep=(yr-floor(yr)).*365;

tic

year_name_min=num2str(min_year);
time=double(ncread([path_oisst,'sst.day.anom.',year_name_min,'.v2.nc'],'time'));
sst_anom_year=ncread([path_oisst,'sst.day.anom.',year_name_min,'.v2.nc'],'anom');
sst_anom_year(sst_anom_year<= -9.9692e+36)=nan;
sst_180_anom_year=[sst_anom_year(pos_shift,:,:);sst_anom_year(~pos_shift,:,:)];
      
for yr_value=min_year:max_year

   
  disp(yr_value)
  pos_year=(floor(yr)==yr_value);
  good_prof_360=pos_year&pos_use_360;
  good_prof_180=pos_year&pos_use_180;

  
  yr_name_next=num2str(yr_value+1);


  if exist([path_oisst,'sst.day.anom.',yr_name_next,'.v2.nc'],'file')
      sst_anom_year_next=double(ncread([path_oisst,'sst.day.anom.',yr_name_next,'.v2.nc'],'anom'));
     
    
      sst_anom_year_next=double(sst_anom_year_next);
      sst_anom_year_next(sst_anom_year_next<= -9.9692e+36)=nan;   
      sst_180_anom_year_next=[sst_anom_year_next(pos_shift,:,:);sst_anom_year_next(~pos_shift,:,:)];
    
      time_next=ncread([path_oisst,'sst.day.anom.',yr_name_next,'.v2.nc'],'time');
      
      
     time_use=[time;time_next(1)];
     time_use=(time_use-min(time_use));
     sst_anom_year_use=cat(3,sst_anom_year,sst_anom_year_next(:,:,1));
     sst_180_anom_year_use=cat(3,sst_180_anom_year,sst_180_anom_year_next(:,:,1));
  else
    time_use=time;
    sst_anom_year_use=sst_anom_year;
    sst_180_anom_year_use=sst_180_anom_year;
  end 
  [LON,LAT,TIME]=ndgrid(lon_sst,lat_sst,time_use);
  %put grid into scaled distance 
  LON=LON./distancescale;
  LAT=LAT./distancescale;
  TIME=TIME./timescale;

  [LON_180,~,~]=ndgrid(lon_sst_180,lat_sst,time_use);
    %put grid into scaled distance 
  LON_180=LON_180./distancescale;
  

 % put time into scalled time

  F=griddedInterpolant(LON,LAT,TIME,sst_anom_year_use);
  F_180=griddedInterpolant(LON_180,LAT,TIME,sst_180_anom_year_use);



  
  
  jlonp_360=lonp_360(good_prof_360);
  jlatp_360=latp(good_prof_360);
  jtimep_360=timep(good_prof_360);

  jtimep_360=jtimep_360./timescale;
  jlatp_360=jlatp_360./distancescale;
  jlonp_360=jlonp_360./distancescale;

  
  jlatp_180=latp(good_prof_180);
  jlonp_180=lonp_180(good_prof_180);
  jtimep_180=timep(good_prof_180);
  
  jtimep_180=jtimep_180./timescale;
  jlatp_180=jlatp_180./distancescale;
  jlonp_180=jlonp_180./distancescale;

  sst(good_prof_180)=F_180(jlonp_180,jlatp_180,jtimep_180);
  sst(good_prof_360)=F(jlonp_360,jlatp_360,jtimep_360);

  
 toc
end







