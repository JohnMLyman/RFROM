% interptpx.m - matlab script to interpolate altimetric height 
% from merged T/P-ERS data onto each profile

max_year=2006
max_year_topex=2006;

for iyear=2004:max_year

%load john_correction_data
load john_correction_data_7_25_2007

ht=htanom;


dt=dt(all_ind,:);
cds=cds(all_ind,:);
ht=ht(all_ind,:);
topex=topex(all_ind,:);
tm=tm(all_ind,:);
yr=yr(all_ind);




d=[sdir('../Mtpers/ssh*.mat');sdir('../Mtpers/dssh*.mat')];

% need to fix any coordinates that stray outside the range -180:180
ii=find(cds(:,1)>180);cds(ii,1)=cds(ii,1)-360;
ii=find(cds(:,1)<-180);cds(ii,1)=cds(ii,1)+360;

% change cds tm and dt so that topex is sampled such that every year is the
% same as iyear expect do not look at leap year day Feb, 29th

good_points=find(  (dt(:,1) == iyear) & ~((dt(:,2) == 2) & (dt(:,3) == 29))) ;



cds_first_year=cds(good_points,:);
dt_first_year=dt(good_points,:);
tm_first_year=tm(good_points);

% duplicate the subsampling of iyear for all years

cds=cds_first_year;
dt=dt_first_year;
tm=tm_first_year;
dt(:,1)=1993;

for pack_year=1994:max_year_topex
    junk_dt=dt_first_year;
    junk_dt(:,1)=pack_year;
    cds=[cds',cds_first_year']';
    dt=[dt',junk_dt']';
    tm=[tm',tm_first_year']';
        
end
day=datenum([dt,tm,0*tm,0*tm])-datenum(1950,1,1);
topex=nans(length(dt),2);
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


ff='allheat_twin_correction_all_,',num2str(iyear)
eval(['save ./twin/correction/allheat_twin_correction_all2',num2str(iyear),' dt cds ht topex  tm'])
end

