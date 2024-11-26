path='H:\erddap\temp\netcdf';
path_out='H:\erddap\temp';

start_year=1993;
end_year=2022;

files=dir([path,'\R*.nc']);
Ntime=length(files);

lon=ncread([files(1).folder,'\',files(1).name],'longitude');
lat=ncread([files(1).folder,'\',files(1).name],'latitude');

pres=ncread([files(1).folder,'\',files(1).name],'mean_pressure');
ndepth=length(pres);

AreaAveTemp=nans(ndepth,Ntime);
Time=nans(Ntime,1);

arw=areavec(lon,lat);
ARW=repmat(arw,[1,1,58]);




Itime=0;
for iyear=start_year:end_year
    for imonth=1:12
           if imonth>=10
                      file_name_nc= [path,'\RFROM_TEMP_',num2str(iyear),'_',num2str(imonth),'.nc'];
                   else
                      file_name_nc= [path,'\RFROM_TEMP_',num2str(iyear),'_0',num2str(imonth),'.nc'];
           end
           if exist(file_name_nc,'file')
               
               time=ncread(file_name_nc,'time');
               ntime=length(time);

               temp=ncread(file_name_nc,'ocean_temperature');
               for itime=1:ntime
                   Itime=Itime+1;
                   jARW=ARW;
                   jtemp=squeeze(temp(:,:,:,itime));
                   bad=~isfinite(jtemp);
                   jARW(bad)=nan;
                   Area=squeeze(sum(jARW,[1 2],'omitnan'));
                   AreaTemp=squeeze(sum(jARW.*jtemp,[1 2],'omitnan'));
                   Time(Itime)=time(itime);
                   AreaAveTemp(:,Itime)=AreaTemp./Area;
               end

           end
               
        end
end

good=find(isfinite(Time));
Time=Time(good);
AreaAveTemp=AreaAveTemp(:,good);

save([path_out,'\RFROM_AreaAveTemp.mat'],"AreaAveTemp","Time","pres")

