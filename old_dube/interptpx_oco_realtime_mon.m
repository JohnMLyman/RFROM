% interptpx.m - matlab script to interpolate altimetric height 
% from merged T/P-ERS data onto each profile

load allheat
sss=s;

day=datenum([dt,tm,0*tm,0*tm])-datenum(1950,1,1);
topex=nans(length(dt),2);
d=[sdir('../Mtpers/realtime/ssh*.mat')];

% need to fix any coordinates that stray outside the range -180:180
ii=find(cds(:,1)>180);cds(ii,1)=cds(ii,1)-360;
ii=find(cds(:,1)<-180);cds(ii,1)=cds(ii,1)+360;

% loop through pairs of topex files and interpolate all
% profiles between those dates
load ../Mtpers/meanssh_oco_realtime gmo sshcyc lon lat
lon=[lon(542:end)-360;lon(1:541)];
lon=[lon(end-1:end)-360;lon;lon(1)+360];
sshcyc=[sshcyc(542:end,:,:);sshcyc(1:541,:,:)];
sshcyc=[sshcyc(end-1:end,:,:);sshcyc;sshcyc(1,:,:)];
s=zeros(size(sshcyc,1),size(sshcyc,2),2);

%make new mean ssh to remove baised on climotlogy used


load ../Mtpers/realtime/meanssh_oco_realtime_mon sshmean_2005_2008 



tic,for i=1:length(d)-1
  load(['../Mtpers/realtime/',d(i).name],'sshanom')
  sshanom=sshanom-sshmean_2005_2008;
  poo=[sshanom(542:end,:);sshanom(1:541,:)];
  s(:,:,1)=[poo(end-1:end,:);poo;poo(1,:)];
  load(['../Mtpers/realtime/',d(i+1).name],'sshanom')
  sshanom=sshanom-sshmean_2005_2008;
  poo=[sshanom(542:end,:);sshanom(1:541,:)];
  s(:,:,2)=[poo(end-1:end,:);poo;poo(1,:)];
  clear poo

  % calculate week of interpolation and pick out appropriate profile times
  dy=[str2num(d(i).name(end-8:end-4)),str2num(d(i+1).name(end-8:end-4))];
  ii=find(day>=dy(1)&day<=dy(2));

  % linearly interpolate in time manually to avoid large matrix
  w1=(dy(2)-day(ii))/7;w2=(day(ii)-dy(1))/7;
  topex(ii,1)=interp2(lon,lat,s(:,:,1)',cds(ii,1),cds(ii,2)).*w1+...
	  interp2(lon,lat,s(:,:,2)',cds(ii,1),cds(ii,2)).*w2;

  % do anomaly with seasonal cycle removed
  mo=str2num(d(i).name(end-8:end-4));mo=mo+datenum(1950,1,1)-datenum(1992,1,1);
  mo=mod(mo/365.25*12,12);sshc=squeeze(0*sshcyc(:,:,1));
  for j=1:length(gmo)
        jj=zeros(1,length(gmo));jj(j)=1;
        w(j)=interp1(gmo,jj,mo,'*cubic');
        sshc=sshc+sshcyc(:,:,j)*w(j);8
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

  topex(ii,2)=interp2(lon,lat,s(:,:,1)',cds(ii,1),cds(ii,2)).*w1+...
	  interp2(lon,lat,s(:,:,2)',cds(ii,1),cds(ii,2)).*w2;

  disp([num2str([i toc]),'  ',d(i).name])
  clear ii jj w mo w1 w2 dy

end

s=sss;
save allheat_oco_realtime_mon dt cds bt ht topex wnum bln blt tm s t
  

