function [sst]=find_oisst_2(lon,lat,yr)

path_oisst='C:\data\oisst\';

nprof=length(lat);
sst=nan(1,nprof);

lat_sst=ncread([path_oisst,'sst.day.anom.1990.v2.nc'],'lat');
lon_sst=ncread([path_oisst,'sst.day.anom.1990.v2.nc'],'lon');

lon2_sst=repmat(lon_sst,1,length(lat_sst));
lat2_sst=repmat(lat_sst',length(lon_sst),1);
% % % time_sst=ncread([path_oisst,'sst.day.anom.1990.nc'],'time');
% % % 
% % % time_sst=time_sst+datenum(1800,1,1);
tic
for yr_value=1982:2021

   
yr_value
  good_prof=find(floor(yr)==yr_value);
  yr_name=num2str(yr_value);
  sst_anom_year=ncread([path_oisst,'sst.day.anom.',yr_name,'.v2.nc'],'anom');
  fill_pos=find(sst_anom_year<= -9.9692e+36);
  sst_anom_year=double(sst_anom_year);
  sst_anom_year(fill_pos)=nan;        

  for ipos=1:length(good_prof)
      
        iprof=good_prof(ipos);
        
       
        % to find the time to use this code uses the fration of the
        % calender year and mutiplies it by the number of days in the sst.
        lonp=lon(iprof);
        latp=lat(iprof);
        % sst goes for 0-360 profile -180 to 180 
        if lonp<0 ;lonp=lonp+360; end
        
        yr_frac=yr(iprof)-yr_value;
            
        time_index=ceil(yr_frac.*yeardays(yr_value));
        
        if time_index ==0;time_index=1;end

        sst_anom=(sst_anom_year(:,:,time_index));
        
        dist=sqrt((cosd(latp).*(lon2_sst-lonp)).^2+(lat2_sst-latp).^2);
        dist(fill_pos)=nan;
        dist=dist(:);
        sst_anom=sst_anom(:);
        [~,pos_good]=min(dist);
        sst(iprof)=sst_anom(pos_good(1));

  end
 toc
end







