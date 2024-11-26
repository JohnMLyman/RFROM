% interptpx.m - matlab script to interpolate altimetric height 
% from merged T/P-ERS data onto each profile
% 
% eval(['load ',file_path_out,file_name,'_heat_oa_amon_oco_100 heat_1800 heat_900 heat_700 heat_300 heat_100 ',...
% 	'heat_1800_anom heat_900_anom  heat_700_anom heat_300_anom heat_100_anom coords date mdep npts time fptot fpkeep bdt bbas ind id qual ',...
% 	'press_mis_flag dac_centre wmo_inst cycle'])% this is the radius that is looked at

eval(['load ',file_path_out,file_name,'_heat_oa_amon_oco_bin_new_no_season heat_1800_anom heat_900_anom ',...
    'heat_700_anom heat_300_anom heat_100_anom heat_300_700_anom heat_100_300_anom coords ',...
    'date mdep npts time fptot fpkeep bdt bbas ind id qual ',...
	'press_mis_flag dac_centre wmo_inst cycle'])

day=datenum([date,time(:,1),time(:,2),time(:,3)])-datenum(1950,1,1);
topex=nans(length(date),2);

aviso_path='/Users/johnlyman/data/Globalhc/Mtpers/realtime_2013/';
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
aviso=ones(nlon_aviso,nlat_aviso,n_aviso_files).*NaN;
mask=ones(nlon_aviso,nlat_aviso)*0;
for i=1:length(d)
  load([aviso_path,d(i).name],'sshanom')
  

  % calculate week of interpolation and pick out appropriate profile times
  junk_day_aviso=str2num(d(i).name(end-8:end-4));
  
  [aviso_y,aviso_m,aviso_d]=datevec(junk_day_aviso+datenum(1950,1,1));
  
  if (aviso_y >= min_year) &(aviso_y <= max_year)
     
      n_mon_mean(:,:,aviso_m)=n_mon_mean(:,:,aviso_m)+~isnan(sshanom);
      mask=sshanom+mask;
      sshanom(isnan(sshanom))=0;
      aviso_mon_mean(:,:,aviso_m)=aviso_mon_mean(:,:,aviso_m)+sshanom;
      
  end
  aviso(:,:,i)=sshanom;
  date_aviso(i,:)=[aviso_y,aviso_m,aviso_d];
  day_aviso(i)=junk_day_aviso;
end

mask
aviso_mon_mean=aviso_mon_mean./n_mon_mean;
sshcyc=aviso_mon_mean;
clear aviso_mon_mean
eval(['save ',file_path_out,'aviso_mask lon lat mask']);
eval(['save ',file_path_out,'aviso_cycle lon lat sshcyc']);





%take out the season cycle
aviso_no_cycle=aviso;

for imon=1:12
    good_time=find(date_aviso(:,2)==imon);
    n_good=length(good_time);
    for igood=1:n_good
    aviso_no_cycle(:,:,good_time(igood))=aviso(:,:,good_time(igood))-sshcyc(:,:,imon);
    end
end

%take out the mean

aviso=aviso-repmat(nanmean(sshcyc,3),[1,1,n_aviso_files]);

eval(['save ',file_path_out,'aviso_2005_2009_oco -v7.3 aviso aviso_no_cycle lon lat sshcyc date_aviso day_aviso']);



% interpolate to Argo profile positions and times.
% loop through pairs of topex files and interpolate all
% profiles between those dates and remove the monthly mean

lon=[lon(542:end)-360;lon(1:541)];
lon=[lon(end-1:end)-360;lon;lon(1)+360];
aviso_no_cycle=[aviso_no_cycle(542:end,:,:);aviso_no_cycle(1:541,:,:)];
aviso_no_cycle=[aviso_no_cycle(end-1:end,:,:);aviso_no_cycle;aviso_no_cycle(1,:,:)];
aviso=[aviso(542:end,:,:);aviso(1:541,:,:)];
aviso=[aviso(end-1:end,:,:);aviso;aviso(1,:,:)];
topex=nans(length(day),2);


for i=1:length(d)-1
    
    
    ii=find(day>=day_aviso(i)&day<=day_aviso(i+1));
    w1=(day_aviso(i+1)-day(ii))/7;w2=(day(ii)-day_aviso(i))/7;
  topex(ii,1)=interp2(lon,lat,aviso_no_cycle(:,:,i)',coords(ii,1),coords(ii,2)).*w1+...
	  interp2(lon,lat,aviso_no_cycle(:,:,i+1)',coords(ii,1),coords(ii,2)).*w2;
  topex(ii,2)=interp2(lon,lat,aviso(:,:,i)',coords(ii,1),coords(ii,2)).*w1+...
	  interp2(lon,lat,aviso(:,:,i+1)',coords(ii,1),coords(ii,2)).*w2;

end

ht_100=heat_100_anom;
ht_300=heat_300_anom;
ht_100_300=heat_100_300_anom;
ht_300_700=heat_300_700_anom;

ht_700=heat_700_anom;
ht_900=heat_900_anom;
ht_1800=heat_1800_anom;
cds=coords;
dt=date;
tm=time(:,1);

eval(['save ',file_path_out,'allheat_100_300_700_900_1800_new ht_100 ht_300 ht_100_300 ht_300_700 ',...
    'ht_700 ht_900 ht_1800 topex cds dt tm mdep npts time fptot fpkeep bdt bbas ind id qual ',...
	'press_mis_flag dac_centre wmo_inst cycle'])%


 

