function [near,min_lon,max_lon,min_lat,max_lat]=find_wmo_square_floats(wmo,del_deg)

%   INPUTS
% wmo the World Meteorological Organization square that you are interested
%   in
%
% del_deg the distance in degrees away from the square that 
near=NaN;

current_dir=cd;
%cd('../../SAL/WOD05/');

   if exist(['grad_den_0_grid_aden_den_no_f',num2str(wmo),'.mat'])
    eval(['load grad_den_0_grid_aden_den_no_f',num2str(wmo),'.mat;']);
 
      
 % find the coners of the WMO square (kinda)
 if length(coords) >= 1
  min_lat=min(coords(:,2));
  max_lat=max(coords(:,2));
  
  min_lon=min(coords(:,1));
  max_lon=max(coords(:,1));

 lon=[min_lon-del_deg:.1:max_lon+del_deg];
 lat=[min_lat-del_deg:.1:max_lat+del_deg];
 
 nlon=length(lon);
 nlat=length(lat);
 
 lat2=repmat(lat,1,nlon);
 lon2=repmat(lon,nlat,1);
 lon2=lon2(:);
 
 big_lon=find(lon2 >= 180);
 if length(big_lon) >=1 
     lon2(big_lon)=lon2(big_lon)-360;
 end
 
 small_lon=find(lon2 <= -180);
 if length(small_lon)>=1 
    lon2(small_lon)=lon2(small_lon)+360;
 end
 
 coords_tot(:,1)=lon2;
 coords_tot(:,2)=lat2;

 iii=find(coords_tot(:,1)<=0&coords_tot(:,2)>0);
jjj=find(coords_tot(:,1)>0 &coords_tot(:,2)>0);
lll=find(coords_tot(:,1)<=0&coords_tot(:,2)<=0);
nnn=find(coords_tot(:,1)>0 &coords_tot(:,2)<=0);
wnum(iii)=abs(ceil(coords_tot(iii,1)/10))+100*(ceil(coords_tot(iii,2)/10)-1)+7000;
wnum(jjj)=ceil(coords_tot(jjj,1)/10)-1+100*(ceil(coords_tot(jjj,2)/10)-1)+1000;
wnum(lll)=abs(ceil(coords_tot(lll,1)/10))+100*abs(ceil(coords_tot(lll,2)/10))+5000;
wnum(nnn)=ceil(coords_tot(nnn,1)/10)-1+100*abs(ceil(coords_tot(nnn,2)/10))+3000;

w=unique(wnum);
  
  near=w;

    
 end
 end

  cd(current_dir);
  
 if length(coords) >= 1
  min_lon=lon2(1,1);
  max_lon=lon2(end,end);
  min_lat=lat2(1,1);
  max_lat=lat2(end,end);
 else 
    min_lon=NaN;
    max_lon=NaN;
    min_lat=NaN;
    max_lat=NaN;
    near=NaN;
 end