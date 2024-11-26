% interptpx.m - matlab script to interpolate altimetric height 
% from merged T/P-ERS data onto each profile
file_path_out='/Users/johnlyman/data/Globalhc/Floats/Argo/CORIOLIS/depth_grid/'
file_name='pfloat_sal_greg_june_2008_depth_grid'
eval(['load ',file_path_out,file_name])

dt=date;
tm=time;
cds=coords;

day=datenum([dt,tm,0*tm,0*tm])-datenum(1950,1,1);
topex=nans(length(dt),2);
d=[sdir('../Mtpers/ssh*.mat')];

% need to fix any coordinates that stray outside the range -180:180
ii=find(cds(:,1)>180);cds(ii,1)=cds(ii,1)-360;
ii=find(cds(:,1)<-180);cds(ii,1)=cds(ii,1)+360;

% loop through pairs of topex files and interpolate all
% profiles between those dates
load ../Mtpers/meanssh gmo sshcyc lon lat
lon=[lon(542:end)-360;lon(1:541)];
lon=[lon(end-1:end)-360;lon;lon(1)+360];
sshcyc=[sshcyc(542:end,:,:);sshcyc(1:541,:,:)];
sshcyc=[sshcyc(end-1:end,:,:);sshcyc;sshcyc(1,:,:)];
s=zeros(size(sshcyc,1),size(sshcyc,2),2);
tic,for i=1:length(d)-1
  load(['../Mtpers/',d(i).name],'sshanom')
  poo=[sshanom(542:end,:);sshanom(1:541,:)];
  s(:,:,1)=[poo(end-1:end,:);poo;poo(1,:)];
  load(['../Mtpers/',d(i+1).name],'sshanom')
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

  topex(ii,2)=interp2(lon,lat,s(:,:,1)',cds(ii,1),cds(ii,2)).*w1+...
	  interp2(lon,lat,s(:,:,2)',cds(ii,1),cds(ii,2)).*w2;

  disp([num2str([i toc]),'  ',d(i).name])
  clear ii jj w mo w1 w2 dy

end

% calculate appropriate square for given lat and lon
iii=find(cds(:,1)<=0&cds(:,2)>0);
jjj=find(cds(:,1)>0 &cds(:,2)>0);
lll=find(cds(:,1)<=0&cds(:,2)<=0);
nnn=find(cds(:,1)>0 &cds(:,2)<=0);
wnum(iii)=abs(ceil(cds(iii,1)/10))+100*(ceil(cds(iii,2)/10)-1)+7000;
wnum(jjj)=ceil(cds(jjj,1)/10)-1+100*(ceil(cds(jjj,2)/10)-1)+1000;
wnum(lll)=abs(ceil(cds(lll,1)/10))+100*abs(ceil(cds(lll,2)/10))+5000;
wnum(nnn)=ceil(cds(nnn,1)/10)-1+100*abs(ceil(cds(nnn,2)/10))+3000;

eval(['save ',file_path_out,file_name,'_tpx dt cds bt topex tm temp sal press_grid mdep npts fptot fpkeep bdt bbas ind id qual ',...
	'press_mis_flag dac_centre wmo_inst cycle wnum'])
  

