path_nc_erddap='L:\erddap_filt\emp_novert_sulu_eqboxnetcdf\tree_heat_novert_eq_NCAR\yearly_withcycle\';
file_prefix='RFROMV22_TEMP_';

path_NCAR='N:\data\NCAR\small_grid\'

fdir=dir([path_NCAR,'*.nc']);

nfile=length(fdir);

diff_temp=nan(1440,720,20,nfile);
timeyr=nan(nfile);

for ifile=1:nfile

    file_NCAR=[path_NCAR, fdir(ifile).name];
     
    
    time_aviso=double(ncread(file_NCAR,'time_yrfrac'));
    timeyr(ifile)=time_aviso;

    year_aviso=floor(time_aviso)
    aviso_day=1+(time_aviso-year_aviso).*yeardays(year_aviso);
    sday=round(aviso_day+datenum(year_aviso,1,1)-1);
    time_model=sday-datenum(1950,1,1);
     [~,month_aviso]=datevec(time_model+datenum(1950,1,1));
    
     t_m=ncread(file_NCAR,'ptemp');
    
    
    if month_aviso>=10
          file_RFROM=[path_nc_erddap,file_prefix,num2str(year_aviso),'_',num2str(month_aviso),'.nc'];
       else
          file_RFROM= [path_nc_erddap,file_prefix,num2str(year_aviso),'_0',num2str(month_aviso),'.nc'];
    end
    
    file_RFROM
    t_r=ncread(file_RFROM,'ocean_temperature');
    time_r=ncread(file_RFROM,'time');
    
    s=size(t_r);
    good_time=find(time_r==time_model);
    
    t_r=squeeze(t_r(:,:,1:20,good_time));
    t_m=t_m(:,:,1:20);
    diff_temp(:,:,:,ifile)=t_r-t_m;


end
