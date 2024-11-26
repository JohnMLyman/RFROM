% interptpx.m - matlab script to interpolate altimetric height 
% from merged T/P-ERS data onto each profile
file_path='/Users/johnlyman/data/Globalhc/Floats/Argo/CORIOLIS/'
file_path_out='/Users/johnlyman/data/Globalhc/Floats/Argo/CORIOLIS/depth_grid/'
file_name='pfloat_sal_greg_jan_2011'
file_path_hdata='/Users/johnlyman/data/Globalhc/HC/'

max_year=2011;
min_year=2004;
max_year_topex=2010;
% this matlab file was made with make_argo_mean_heat_oco


time_grid=[2004.5:1:2010.5];

fname_nc=[file_path_hdata,'hdata_',file_name];
eval(['load ',fname_nc,'  tpx yr coords ht_300 ht_700 ht_900 ht_1800 ;']);

% need to fix any coordinates that stray outside the range -180:180
ii=find(coords(:,1)>180);coords(ii,1)=coords(ii,1)-360;
ii=find(coords(:,1)<-180);coords(ii,1)=coords(ii,1)+360;
cd ''/Users/johnlyman/data/Globalhc/HC/
for idepth=[300,700,900,1800];
    eval(['ht_anom=ht_', num2str(idepth)]);
    
for iyear=time_grid


max_year=(iyear)+.5;
min_year=(iyear)-.5;





d=[sdir('../Mtpers/realtime_2011/ssh*.mat')];

% change cds tm and dt so that topex is sampled such that every year is the
% same as iyear expect do not look at leap year day Feb, 29th
good_points=find((yr > min_year) & (yr <= max_year) & (isfinite(ht_anom)==1));



cds_first_year=coords(good_points,:);
yr_first_year=yr(good_points)-floor(yr(good_points));

% duplicate the subsampling of iyear for all years

cds_proxy=cds_first_year;
yr_proxy=yr_first_year+1993;



for pack_year=1994:max_year_topex
    
   
    cds_proxy=[cds_proxy',cds_first_year']';
    yr_proxy=[yr_proxy',yr_first_year'+pack_year]';
        
    
    
    
end

    
day=datenum([floor(yr_proxy),yr_proxy*0,yr_proxy*0])-datenum(1950,1,1)+365.25*(yr_proxy-floor(yr_proxy));
topex=nans(length(yr_proxy),2);
% loop through pairs of topex files and interpolate all
% profiles between those dates

% USED TO BE load ../Mtpers/meanssh gmo sshcyc lon lat

load ../Mtpers/meanssh_oco_realtime gmo sshcyc lon lat
lon=[lon(542:end)-360;lon(1:541)];
lon=[lon(end-1:end)-360;lon;lon(1)+360];
sshcyc=[sshcyc(542:end,:,:);sshcyc(1:541,:,:)];
sshcyc=[sshcyc(end-1:end,:,:);sshcyc;sshcyc(1,:,:)];
s=zeros(size(sshcyc,1),size(sshcyc,2),2);
tic,for i=1:length(d)-1
  load(['../Mtpers/realtime_2011/',d(i).name],'sshanom')
  poo=[sshanom(542:end,:);sshanom(1:541,:)];
  s(:,:,1)=[poo(end-1:end,:);poo;poo(1,:)];
  load(['../Mtpers/realtime_2011/',d(i+1).name],'sshanom')
  poo=[sshanom(542:end,:);sshanom(1:541,:)];
  s(:,:,2)=[poo(end-1:end,:);poo;poo(1,:)];
  clear poo

  % calculate week of interpolation and pick out appropriate profile times
  dy=[str2num(d(i).name(end-8:end-4)),str2num(d(i+1).name(end-8:end-4))];
  ii=find(day>=dy(1)&day<=dy(2));

  % linearly interpolate in time manually to avoid large matrix
  w1=(dy(2)-day(ii))/7;w2=(day(ii)-dy(1))/7;
  topex(ii,1)=interp2(lon,lat,s(:,:,1)',cds_proxy(ii,1),cds_proxy(ii,2)).*w1+...
	  interp2(lon,lat,s(:,:,2)',cds_proxy(ii,1),cds_proxy(ii,2)).*w2;

  % do anomaly with seasonal cycle removed
  mo=str2num(d(i).name(end-8:end-4));mo=mo+datenum(1950,1,1)-datenum(1992,1,1);
  mo=mod(mo/365.25*12,12);sshc=squeeze(0*sshcyc(:,:,1));
  for j=1:length(gmo)
        jj=zeros(1,length(gmo));jj(j)=1;
        w(j)=interp1(gmo,jj,mo,'*cubic');
        sshc=sshc+sshcyc(:,:,j)*w(j);
  end
  s(:,:,1)=s(:,:,1)-sshc;clear sshc
  mo=str2num(d(i+1).name(end-8:end-4));
  mo=mo+datenum(1950,1,1)-datenum(1992,1,1);
  mo=mod(mo/365.25*12,12);sshc=squeeze(0*sshcyc(:,:,1));
  for j=1:length(gmo)
        jj=zeros(1,length(gmo));jj(j)=1;
        w(j)=interp1(gmo,jj,mo,'*cubic');
        sshc=sshc+sshcyc(:,:,j)*w(j);
  end
  s(:,:,2)=s(:,:,2)-sshc;clear sshc

  topex(ii,2)=interp2(lon,lat,s(:,:,1)',cds_proxy(ii,1),cds_proxy(ii,2)).*w1+...
	  interp2(lon,lat,s(:,:,2)',cds_proxy(ii,1),cds_proxy(ii,2)).*w2;

  disp([num2str([i toc]),'  ',d(i).name])
  clear ii jj w mo w1 w2 dy

end



eval(['save ./twin/argo/allheat_twin_',num2str(idepth),'_',num2str(iyear),'.mat yr_proxy cds_proxy topex'])
end
end

