function [sst]=find_oisst(lon,lat,yr)

path_oisst='C:\data\oisst\';

nprof=length(lat);
sst=nan(1,nprof);

lat_sst=ncread([path_oisst,'sst.day.anom.1990.nc'],'lat');
lon_sst=ncread([path_oisst,'sst.day.anom.1990.nc'],'lon');

lon2_sst=repmat(lon_sst,1,length(lat_sst));
lat2_sst=repmat(lat_sst',length(lon_sst),1);
% % % time_sst=ncread([path_oisst,'sst.day.anom.1990.nc'],'time');
% % % 
% % % time_sst=time_sst+datenum(1800,1,1);
nprof
for iprof=2200528:2200528+100
    
    yr_value=(floor(yr(iprof)));
    if yr_value >= 1982
        iprof
        yr_name=num2str(yr_value);
        time_sst=ncread([path_oisst,'sst.day.anom.',yr_name,'.nc'],'time');
        % to find the time to use this code uses the fration of the
        % calender year and mutiplies it by the number of days in the sst.
        lonp=lon(iprof);
        latp=lat(iprof);
        % sst goes for 0-360 profile -180 to 180 
        if lonp<0 ;lonp=lonp+360; end

        

        time_index=ceil((yr(iprof)-floor(yr(iprof)))*yeardays(yr_value));
        sst_anom=ncread([path_oisst,'sst.day.anom.',yr_name,'.nc'],'anom');
        
        sst_anom=double(sst_anom(:,:,time_index));
        fill_pos=find(sst_anom<= -9.9692e+36);

        sst_anom(fill_pos)=nan;        
        dist=sqrt((cosd(latp).*(lon2_sst-lonp)).^2+(lat2_sst-latp).^2);
        dist(fill_pos)=nan;
        dist=dist(:);
        sst_anom=sst_anom(:);
        [~,pos_good]=min(dist);
        sst(iprof)=sst_anom(pos_good(1));
        




    end



end



