function [sst]=find_oisst_4_orca_old(lonp,latp,yr,path_oisst)
% it is assumed that is input lon is -180 to 180
% lonp, latp and yr must all be the same size but can be 1,2 or 
%   3 demensional arrays.

sinput=size(yr);

if length(sinput)==3||(sinput(1)~=1 && sinput(2)~=1)
    lonp=lonp(:);
    latp=latp(:);
    yr=yr(:);
end


% path_oisst='C:\data\oisst\';
% min_year=1982;
% max_year=2021;
% sst_years=min_year:max_year;
% 
new_years=floor(min(yr)):floor(max(yr));
% load_years=intersect(new_years,sst_years);
load_years=new_years;
distancescale=100./111.; %in degress lat
timescale=30; % in days
nprof=length(latp);
sst=nan(nprof,1);

sst_files=dir([path_oisst,'sst.day.anom.*.nc']);

lat_sst=double(ncread([path_oisst,sst_files(1).name],'lat'));
lon_sst=double(ncread([path_oisst,sst_files(1).name],'lon'));


pos_shift=lon_sst>180;

lon_sst_180=[lon_sst(pos_shift)-360;lon_sst(~pos_shift)];
pos_use_180=lonp>-90 & lonp<90;
pos_use_360=~(lonp>-90 & lonp<90);
lonp_360=lonp;
lonp_360(lonp_360<0)=lonp_360(lonp_360<0)+360;
lonp_180=lonp;
timep=(yr-floor(yr)).*yeardays(floor(yr));




time=double(ncread([path_oisst,sst_files(1).name],'time'));
sst_anom_year=ncread([path_oisst,sst_files(1).name],'anom');
sst_anom_year(sst_anom_year<= -9.9692e+36)=nan;
sst_180_anom_year=[sst_anom_year(pos_shift,:,:);sst_anom_year(~pos_shift,:,:)];
      
for yr_value=load_years

   
%   disp(yr_value)
  pos_year=(floor(yr)==yr_value);
  good_prof_360=pos_year&pos_use_360;
  good_prof_180=pos_year&pos_use_180;

  
  yr_name_next=num2str(yr_value+1);


  if exist([path_oisst,'sst.day.anom.',yr_name_next,'.nc'],'file')
      sst_anom_year_next=double(ncread([path_oisst,'sst.day.anom.',yr_name_next,'.nc'],'anom'));
     
    
      sst_anom_year_next=double(sst_anom_year_next);
      sst_anom_year_next(sst_anom_year_next<= -9.9692e+36)=nan;   
      sst_180_anom_year_next=[sst_anom_year_next(pos_shift,:,:);sst_anom_year_next(~pos_shift,:,:)];
    
      time_next=double(ncread([path_oisst,'sst.day.anom.',yr_name_next,'.nc'],'time'));
      
      
     time_use=[time;time_next(1)];
   
     sst_anom_year_use=cat(3,sst_anom_year,sst_anom_year_next(:,:,1));
     sst_180_anom_year_use=cat(3,sst_180_anom_year,sst_180_anom_year_next(:,:,1));
  else
    time_use=time;
    sst_anom_year_use=sst_anom_year;
    sst_180_anom_year_use=sst_180_anom_year;
  end 

  time_use=(time_use-min(time_use));
  
%   time_use=time_use-(datenum(yr_value,1,1)-datenum(1800,1,1));
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
  time=time_next;
  sst_anom_year=sst_anom_year_next;
  sst_180_anom_year=sst_180_anom_year_next;
  
 
end


% convert pack to 3-d array
if length(sinput)==3
    sst=reshape(sst,sinput(1),sinput(2),sinput(3));
elseif (sinput(1)~=1 && sinput(2)~=1)
    sst=reshape(sst,sinput(1),sinput(2));
end
    



