path_nc_erddap='L:\erddap_filt\emp_novert_sulu_eqboxnetcdf\tree_heat_novert_eq_NCAR\yearly_withcycle\';
file_prefix='RFROMV22_TEMP_';

path_NCAR='N:\data\NCAR\small_grid\'

fdir=dir([path_NCAR,'*.nc']);

nfile=length(fdir);


timeyr_file=nan(nfile,1);
year_file=nan(nfile,1);
month_file=nan(nfile,1);
for ifile=1:nfile

    file_NCAR=[path_NCAR, fdir(ifile).name];
     
    
    time_aviso=double(ncread(file_NCAR,'time_yrfrac'));
    timeyr_file(ifile)=time_aviso;

    year_aviso=floor(time_aviso)
    aviso_day=1+(time_aviso-year_aviso).*yeardays(year_aviso);
    sday=round(aviso_day+datenum(year_aviso,1,1)-1);
    time_model=sday-datenum(1950,1,1);
    [~,month_aviso]=datevec(time_model+datenum(1950,1,1));
    
     year_file(ifile)=year_aviso;
     month_file(ifile)=month_aviso;


end
 file_NCAR=[path_NCAR, fdir(1).name];
 lon=ncread(file_NCAR,'longitude');
 lat=ncread(file_NCAR,'latitude');
 depth=ncread(file_NCAR,'depth');

nyear=(year_file(end)-year_file(1))+1;
nmod=nyear*12;

months=repmat(1:12,1,nyear);
years=repmat(year_file(1):year_file(end),12,1);
years=years(:);


nt=nmod;
nlayers=47;
nlon=length(lon);
nlat=length(lat);
depth=depth(1:nlayers-1);
var_out=nan(360,180,nlayers-1,nt);



time_out=nan(1,nt);
n_Ln=ones(4,360,4,180,nlayers-1);

tic
for imod=1:nmod

  imonth=months(imod);
    iyear=years(imod);
    display(iyear)
    display(imonth)

    good_file=find(month_file==imonth & year_file==iyear);


if ~isempty(good_file)
    ntime=length(good_file);
    var=nan(nlon,nlat,nlayers-1,ntime);
    time_junk=nan(ntime,1);

            for ifile=good_file'
                  file_NCAR=[path_NCAR, fdir(ifile).name];
                  time_aviso=double(ncread(file_NCAR,'time_yrfrac'));
                  t_m=ncread(file_NCAR,'ptemp');
                  var(:,:,:,ifile-min(good_file)+1)=t_m(:,:,1:nlayers-1);
                  time_junk(ifile-min(good_file)+1)=time_aviso;
            end

               time_out(imod)=mean(time_junk);
    
    
                    var=squeeze(mean(var,4,'omitnan'));
                    var= reshape(var,4,360,4,180,nlayers-1);
                    n_var=n_Ln;
                    n_var(~isfinite(var))=0;
                    var=sum(sum(var,1,'omitnan'),3,'omitnan');
                    n_var=sum(sum(n_var,1,'omitnan'),3,'omitnan');
                    var=reshape(var./n_var,360,180,nlayers-1);
                    var_out(:,:,:,imod)=var;
                    max_mod=imod;


end

toc./60

end

 var_out=var_out(:,:,:,1:max_mod);
 time_out=time_out(1:max_mod);
 lon_out=(sum(reshape(lon,4,360),1)./4)';
 lat_out=(sum(reshape(lat,4,180),1)./4)';
toc./60
