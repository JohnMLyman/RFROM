aviso_path='/Users/johnlyman/data/Globalhc/Mtpers/';
path='/Users/johnlyman/data/Globalhc/HC/'
d=[sdir([aviso_path, 'ssh*.mat'])];
n_aviso_files=length(d);

load([aviso_path,d(1).name],'sshanom','lat','lon')
s_aviso=size(sshanom);
nlon_aviso=s_aviso(1);
nlat_aviso=s_aviso(2);


aviso=ones(nlon_aviso,nlat_aviso,n_aviso_files).*NaN;
for i=1:length(d)
  load([aviso_path,d(i).name],'sshanom')
  

  % calculate week of interpolation and pick out appropriate profile times
  junk_day_aviso=str2num(d(i).name(end-8:end-4));
  
  [aviso_y,aviso_m,aviso_d]=datevec(junk_day_aviso+datenum(1950,1,1));
  
  
  aviso(:,:,i)=sshanom;
  date_aviso(i,:)=[aviso_y,aviso_m,aviso_d];
  day_aviso(i)=junk_day_aviso;
end





eval(['save ',path,'aviso_clim_2004_2007 -v7.3 aviso  lon lat  date_aviso day_aviso']);
