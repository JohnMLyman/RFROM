function [sst]=find_oisst_4_mean_orca_model(lonp,latp,yr,path_oisst,TreeSetUp)
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
load_years=new_years;
distancescale=100./111.; %in degress lat
timescale=30; % in days
nprof=length(latp);
sst=nan(nprof,1);

sst_files=dir([path_oisst,'sst.day.mean.*.nc']);

lat_sst=double(ncread([path_oisst,sst_files(1).name],'lat'));
lon_sst=double(ncread([path_oisst,sst_files(1).name],'lon'));

pos_shift=lon_sst>180;

lon_sst_180=[lon_sst(pos_shift)-360;lon_sst(~pos_shift)];
pos_use_180=lonp>-90 & lonp<90;
pos_use_360=~(lonp>-90 & lonp<90);
lonp_360=lonp;
lonp_360(lonp_360<0)=lonp_360(lonp_360<0)+360;
lonp_180=lonp;

[LON,LAT]=ndgrid(lon_sst,lat_sst);
[LON_180,~]=ndgrid(lon_sst_180,lat_sst);
% put time into days for 

if isfield(TreeSetUp,'data_type')
    switch TreeSetUp.data_type
        case ('NCAR') %no leapyear
              timep=(yr-floor(yr)).*365+(floor(yr))*365+1-datenum(1800,1,1);
        otherwise
            timep=(yr-floor(yr)).*yeardays(floor(yr))+datenum(floor(yr),1,1)-datenum(1800,1,1);
    end
else
    timep=(yr-floor(yr)).*yeardays(floor(yr))+datenum(floor(yr),1,1)-datenum(1800,1,1);
end

timep=floor(timep);



first_file=1;
      
for yr_value=load_years

   
%   disp(yr_value)
  pos_year=(floor(yr)==yr_value);
  good_prof_360_total=pos_year&pos_use_360;
  good_prof_180_total=pos_year&pos_use_180;

  yr_name=num2str(yr_value);
  yr_name_next=num2str(yr_value+1);
  file_name_year=[path_oisst,'sst.day.mean.',yr_name,'.nc'];

  if exist(file_name_year,'file')
      
      if first_file==1
          first_file=0;
    
         time=double(ncread(file_name_year,'time'));
         sst_anom_year=ncread(file_name_year,'sst');
         sst_anom_year(sst_anom_year<= -9.9692e+36)=nan;
         sst_180_anom_year=[sst_anom_year(pos_shift,:,:);sst_anom_year(~pos_shift,:,:)];
      end
 
  
 

  if exist([path_oisst,'sst.day.mean.',yr_name_next,'.nc'],'file')
      sst_anom_year_next=double(ncread([path_oisst,'sst.day.mean.',yr_name_next,'.nc'],'sst'));
     
    
      sst_anom_year_next=double(sst_anom_year_next);
      sst_anom_year_next(sst_anom_year_next<= -9.9692e+36)=nan;   
      sst_180_anom_year_next=[sst_anom_year_next(pos_shift,:,:);sst_anom_year_next(~pos_shift,:,:)];
    
      time_next=double(ncread([path_oisst,'sst.day.mean.',yr_name_next,'.nc'],'time'));
      
      
     time_use=[time;time_next(1)];
%      time_use=(time_use-min(time_use));
     sst_anom_year_use=cat(3,sst_anom_year,sst_anom_year_next(:,:,1));
     sst_180_anom_year_use=cat(3,sst_180_anom_year,sst_180_anom_year_next(:,:,1));
  else
    time_use=time;
    sst_anom_year_use=sst_anom_year;
    sst_180_anom_year_use=sst_180_anom_year;
  end 

   unq_sst_day=unique(timep(pos_year));
   ndays=length(time_use);
   for isstday=unq_sst_day'
          [~,pos_good_cycle]=min(abs(time_use-isstday));
          pos_close=pos_good_cycle(1);
          time_day=time_use(pos_close);
          diff_days=isstday-time_day;
          
       if abs(diff_days)<=30  % dont linear interp too far away in time
           
            if diff_days>0 && (pos_close+1)<=ndays
                pos_new=close+1;
                time_day_n=time_use(pos_new);
                w1=abs(time_day_n-isstday);
                w2=abs(time_day-isstday);
                sst_day=...
                    (w1.*sst_anom_year_use(:,:,pos_close)+...
                    w2.*sst_anom_year_use(:,:,pos_new))./(w1+w2);
                sst_day_180=...
                    (w1.*sst_180_anom_year_use(:,:,pos_close)+...
                    w2.*sst_180_anom_year_use(:,:,pos_new))./(w1+w2);
               
               
            elseif diff_days<0 && (pos_close-1)>=1
                pos_new=pos_close-1;
                time_day_n=time_use(pos_new);
                w1=abs(time_day_n-isstday);
                w2=abs(time_day-isstday);
                sst_day=...
                    (w1.*sst_anom_year_use(:,:,pos_close)+...
                    w2.*sst_anom_year_use(:,:,pos_new))./(w1+w2);
                sst_day_180=...
                    (w1.*sst_180_anom_year_use(:,:,pos_close)+...
                    w2.*sst_180_anom_year_use(:,:,pos_new))./(w1+w2);
                    
    
            else
                sst_day=sst_anom_year_use(:,:,pos_close);
                sst_day_180=sst_180_anom_year_use(:,:,pos_close);
            end
    
    
            
    
    
              
    
            
              F=griddedInterpolant(LON,LAT,sst_day);
              F_180=griddedInterpolant(LON_180,LAT,sst_day_180);
    
              good_prof_360=good_prof_360_total & (timep==isstday);
              good_prof_180=good_prof_180_total & (timep==isstday);
            
            
            
              
              
              jlonp_360=lonp_360(good_prof_360);
              jlatp_360=latp(good_prof_360);
    
              jlatp_180=latp(good_prof_180);
              jlonp_180=lonp_180(good_prof_180);
    
              sst(good_prof_180)=F_180(jlonp_180,jlatp_180);
              sst(good_prof_360)=F(jlonp_360,jlatp_360);
           
       end 
   end%end isstday
          % so you dont have to load the next year twice. also keeps
          % boundry values for linear interp
          time=[time(end);time_next];
          sst_anom_year=cat(3,sst_anom_year(:,:,end),sst_anom_year_next);
          sst_180_anom_year=cat(3,sst_180_anom_year(:,:,end),sst_180_anom_year_next);

   
   
  end %end year
end


% convert pack to 3-d array
if length(sinput)==3
    sst=reshape(sst,sinput(1),sinput(2),sinput(3));
elseif (sinput(1)~=1 && sinput(2)~=1)
    sst=reshape(sst,sinput(1),sinput(2));
end
    



