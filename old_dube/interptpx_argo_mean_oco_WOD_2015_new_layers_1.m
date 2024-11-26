% interptpx.m - matlab script to interpolate altimetric height 
% from merged T/P-ERS data onto each profile
eval(['load /Volumes/ThunderBay/Data/Globalhc/WOD05/allheat_new_layers_argo_WOD_new_',file_name,...
    ht_var_name,...
    'cds dt argo_delayed_mode argo_float_id mdep wod_oclnum'])%

   

% eval(['load /Volumes/Data/Globalhc/WOD05/allheat_100_300_700_900_1800_argo_WOD_new_',file_name,' ht_100 ht_300 ht_700 ht_900 ht_1800 ht_100_300 ht_300_700 cds dt argo_delayed_mode argo_float_id mdep wod_oclnum'])
date=dt;
coords=cds;

time=date*0;

day=datenum([date,time(:,1),time(:,2),time(:,3)])-datenum(1950,1,1);
topex=nans(length(date),2);

aviso_path='/Volumes/ThunderBay/Data/Globalhc/Mtpers/realtime_2016/';
d=[sdir([aviso_path, 'ssh*.mat'])];
n_aviso_files=length(d);
% need to fix any coordinates that stray outside the range -180:180
ii=find(coords(:,1)>180);coords(ii,1)=coords(ii,1)-360;
ii=find(coords(:,1)<-180);coords(ii,1)=coords(ii,1)+360;

% compute,save and remove the mean (same as Argo)
load([aviso_path,d(1).name],'sshanom','lat','lon')
s_aviso=size(sshanom);
nlon_aviso=s_aviso(1);
nlat_aviso=s_aviso(2);

n_mon_mean=ones(nlon_aviso,nlat_aviso,12)*0;
aviso_mon_mean=n_mon_mean*0;
aviso=single(ones(nlon_aviso,nlat_aviso,n_aviso_files)).*NaN;
mask=ones(nlon_aviso,nlat_aviso)*0;
for i=1:length(d)
  load([aviso_path,d(i).name],'sshanom')
  

  % calculate week of interpolation and pick out appropriate profile times
  junk_day_aviso=str2num(d(i).name(end-8:end-4));
  
  [aviso_y,aviso_m,aviso_d]=datevec(junk_day_aviso+datenum(1950,1,1));
  
  if (aviso_y >= min_year) && (aviso_y <= max_year)
     
      n_mon_mean(:,:,aviso_m)=n_mon_mean(:,:,aviso_m)+~isnan(sshanom);
      mask=sshanom+mask;
      sshanom(isnan(sshanom))=0;
      aviso_mon_mean(:,:,aviso_m)=aviso_mon_mean(:,:,aviso_m)+sshanom;
      
  end
  aviso(:,:,i)=single(sshanom);
  date_aviso(i,:)=[aviso_y,aviso_m,aviso_d];
  day_aviso(i)=junk_day_aviso;
end

aviso_mon_mean=aviso_mon_mean./n_mon_mean;
sshcyc=aviso_mon_mean;
clear aviso_mon_mean
eval(['save ',file_path_out,file_name,'_','aviso_mask lon lat mask']);
eval(['save ',file_path_out,file_name,'_','aviso_cycle lon lat sshcyc']);


'aviso made'


%take out the season cycle


sshcyc=single(sshcyc);
aviso_no_cycle=aviso;
aviso=aviso-repmat(nanmean(sshcyc,3),[1,1,n_aviso_files]);
eval(['save ',file_path_out,file_name,'_','aviso_oco -v7.3 aviso lon lat sshcyc date_aviso day_aviso']);
clear aviso

for imon=1:12
    good_time=find(date_aviso(:,2)==imon);
    n_good=length(good_time);
    for igood=1:n_good
    aviso_no_cycle(:,:,good_time(igood))=aviso_no_cycle(:,:,good_time(igood))-sshcyc(:,:,imon);
    end
end

%take out the mean

'aviso_no_cycle made'
lon=lon';


% interpolate to Argo profile positions and times.
% loop through pairs of topex files and interpolate all
% profiles between those dates and remove the monthly mean

lon=[lon(721:end)-360;lon(1:720)];
lon=[lon(end-1:end)-360;lon;lon(1)+360];
aviso_no_cycle=[aviso_no_cycle(721:end,:,:);aviso_no_cycle(1:720,:,:)];
aviso_no_cycle=[aviso_no_cycle(end-1:end,:,:);aviso_no_cycle;aviso_no_cycle(1,:,:)];

topex=nans(length(day),2);


for i=1:length(d)-1
    
    
    ii=find(day>=day_aviso(i)&day<=day_aviso(i+1));
    w1=(day_aviso(i+1)-day(ii))/7;w2=(day(ii)-day_aviso(i))/7;
%   topex(ii,1)=interp2(lon,lat,aviso_no_cycle(:,:,i)',coords(ii,1),coords(ii,2)).*w1+...
% 	  interp2(lon,lat,aviso_no_cycle(:,:,i+1)',coords(ii,1),coords(ii,2)).*w2;

    aviso_junk=double(aviso_no_cycle(:,:,i));
    aviso_junk2=double(aviso_no_cycle(:,:,i+1));
    
    
    
    topex(ii,1)=interp2(lon,lat,aviso_junk',coords(ii,1),coords(ii,2)).*w1+...
	interp2(lon,lat,aviso_junk2',coords(ii,1),coords(ii,2)).*w2;
    
    if i==3 
        'go home!'
    end
end


clear aviso_no_cycle

eval(['load ',file_path_out,file_name,'_','aviso_oco aviso']);

aviso=[aviso(721:end,:,:);aviso(1:720,:,:)];
aviso=[aviso(end-1:end,:,:);aviso;aviso(1,:,:)];

for i=1:length(d)-1
    
    
    ii=find(day>=day_aviso(i)&day<=day_aviso(i+1));
    w1=(day_aviso(i+1)-day(ii))/7;w2=(day(ii)-day_aviso(i))/7;
%   topex(ii,1)=interp2(lon,lat,aviso_no_cycle(:,:,i)',coords(ii,1),coords(ii,2)).*w1+...
% 	  interp2(lon,lat,aviso_no_cycle(:,:,i+1)',coords(ii,1),coords(ii,2)).*w2;

   
    aviso_junk=double(aviso(:,:,i));
    aviso_junk2=double(aviso(:,:,i+1));
    topex(ii,2)=interp2(lon,lat,aviso_junk',coords(ii,1),coords(ii,2)).*w1+...
	interp2(lon,lat,aviso_junk2',coords(ii,1),coords(ii,2)).*w2;
    if i==3 
        'no really go home!'
    end
end

clear aviso

cds=coords;
dt=date;
tm=time(:,1);

% eval(['save ',file_path_out,'allheat_100_300_700_900_1800_argo_WOD_new_',file_name,' ht_100 ht_300 ht_700 ht_900 ht_1800 ht_100_300 ht_300_700 cds dt argo_delayed_mode argo_float_id mdep wod_oclnum topex'])%
% 
['hdata_new_layers_',file_WOD_suf,'_',file_name]
 eval(['save ',file_path_out,'allheat_new_layers_argo_WOD_new_',file_name,...
    ht_var_name,...
    'cds dt argo_delayed_mode argo_float_id mdep wod_oclnum topex'])%

   


