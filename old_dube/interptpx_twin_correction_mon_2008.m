% interptpx.m - matlab script to interpolate altimetric height 
% from merged T/P-ERS data onto each profile

max_year=2007
max_year_topex=2007;
file_path_out='/Users/johnlyman/data/Globalhc/Floats/Argo/CORIOLIS/depth_grid/'
cd /Users/johnlyman/data/Globalhc/HC
for iyear=1993:max_year

%load john_correction_data
load /Users/johnlyman/data/Globalhc/Floats/Argo/CORIOLIS/depth_grid/allheat_750_975_1800
%ht=htanom;

%all_ind=nowhoi_ind;
% dt=dt(all_ind,:);
% cds=cds(all_ind,:);
% ht=ht(all_ind,:);
% topex=topex(all_ind,:);
% tm=tm(all_ind,:);
% yr=yr(all_ind);


aviso_path='/Users/johnlyman/data/Globalhc/Mtpers/';
d=[sdir([aviso_path, 'ssh*.mat'])];


%d=[sdir('../Mtpers/ssh*.mat');sdir('../Mtpers/dssh*.mat')];

% need to fix any coordinates that stray outside the range -180:180
ii=find(cds(:,1)>180);cds(ii,1)=cds(ii,1)-360;
ii=find(cds(:,1)<-180);cds(ii,1)=cds(ii,1)+360;

% change cds tm and dt so that topex is sampled such that every year is the
% same as iyear expect do not look at leap year day Feb, 29th

good_points=find(  (dt(:,1) == iyear) & ~((dt(:,2) == 2) & (dt(:,3) == 29))) ;



cds_first_year=cds(good_points,:);
dt_first_year=dt(good_points,:);
tm_first_year=tm(good_points);

ht_750_first_year=ht_750(good_points);
ht_975_first_year=ht_975(good_points);
ht_1800_first_year=ht_1800(good_points);

% duplicate the subsampling of iyear for all years

cds=cds_first_year;
dt=dt_first_year;
tm=tm_first_year;
dt(:,1)=1993;
ht_750=ht_750_first_year;
ht_975=ht_975_first_year;
ht_1800=ht_1800_first_year;

for pack_year=1994:max_year_topex
    junk_dt=dt_first_year;
    junk_dt(:,1)=pack_year;
    cds=[cds',cds_first_year']';
    dt=[dt',junk_dt']';
    tm=[tm',tm_first_year']';
    ht_750=[ht_750',ht_750_first_year']';
    ht_975=[ht_975',ht_975_first_year']';
    ht_1800=[ht_1800',ht_1800_first_year']';
end

day=datenum([dt,tm,0*tm,0*tm])-datenum(1950,1,1);

eval(['load ',file_path_out,'aviso_2004_2007 aviso_no_cycle lon lat sshcyc date_aviso day_aviso']);

coords=cds;

% interpolate to Argo profile positions and times.
% loop through pairs of topex files and interpolate all
% profiles between those dates and remove the monthly mean

lon=[lon(542:end)-360;lon(1:541)];
lon=[lon(end-1:end)-360;lon;lon(1)+360];
aviso_no_cycle=[aviso_no_cycle(542:end,:,:);aviso_no_cycle(1:541,:,:)];
aviso_no_cycle=[aviso_no_cycle(end-1:end,:,:);aviso_no_cycle;aviso_no_cycle(1,:,:)];
topex=nans(length(day),2);




for i=1:length(d)-1
    
    
    ii=find(day>=day_aviso(i)&day<=day_aviso(i+1));
    w1=(day_aviso(i+1)-day(ii))/7;w2=(day(ii)-day_aviso(i))/7;
  topex(ii,1)=interp2(lon,lat,aviso_no_cycle(:,:,i)',coords(ii,1),coords(ii,2)).*w1+...
	  interp2(lon,lat,aviso_no_cycle(:,:,i+1)',coords(ii,1),coords(ii,2)).*w2;

end


ff='allheat_twin_correction_mon_2008_,',num2str(iyear)
eval(['save ./twin/correction/allheat_twin_correction_mon_2008_',num2str(iyear),' dt ht_750 ht_975 ht_1800 cds topex tm'])
end

