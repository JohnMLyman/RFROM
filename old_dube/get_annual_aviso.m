function [aviso_htanom]=get_annual_aviso(tgrid)

% xbtfix.m - matlab script to read in mapped difference field from
% files and combine it with topex to get estimate of global heat
% content
% NOTE:  need map?????.txt data files!
% created 5/1/03

% get directory info

current_dir=cd;
cd /home/shoko2/wills/globalhc_dirs/Globalhc/HC

s=sdir('../Mtpers/ssh*.mat');

% load data on map grid
load gridinfo
glon=lon;glat=lat;
gln=[glon(1)-(glon(end)-glon(end-1));glon;glon(end)+(glon(2)-glon(1))];

% load topex/hc regression info
load hregress2

% make time info. for topex data
sday=strjust(strvcat(s(:).name),'right');sday=str2num(sday(:,end-8:end-4));
sday=sday+datenum(1950,1,1)-datenum(1992,1,1);
syr=sday/365.25+1992;clear sday

% get topex annual cycle
load ../Mtpers/meanssh lat lon gmo sshcyc sshmean
lon=[lon(542:end)-360;lon(1:541)];
sshcyc=[sshcyc(542:end,:,:);sshcyc(1:541,:,:)];
sshmean=[sshmean(542:end,:,:);sshmean(1:541,:,:)];

% interpolate regression coeffs onto topex grid
alpha=interp2(alat,alon,alpha,lat,lon');clear al alon alat

% load area weighting matrix note... don't need to rearrange this one
%load ../Mtpers/areaweight arw
arw=areavec(lon,lat);
load landmask msk2

% loop through time grid and make 1 file per map
for i=1:length(tgrid)

  %  1-year mean topex
  sshave=zeros(length(lon),length(lat));

  % load map and interpolate onto topex grid

  % loop through files in 1-year average and removing 
  % annual cycle as we go
  ii=find(abs(tgrid(i)-syr)<=.5);
  for j=1:length(ii)
    load(['../Mtpers/',s(ii(j)).name],'sshanom')
    mo=str2num(s(ii(j)).name(end-8:end-4));
    mo=mo+datenum(1950,1,1)-datenum(1992,1,1);
    mo=mod(mo/365.25*12,12);
    sshc=squeeze(0*sshcyc(:,:,1));
    for k=1:length(gmo)
	jj=zeros(1,length(gmo));jj(k)=1;
	w(k)=interp1(gmo,jj,mo,'*cubic');
	sshc=sshc+sshcyc(:,:,k)*w(k);
    end
    sshanom=[sshanom(542:end,:);sshanom(1:541,:)];
    sshanom=sshanom-sshc;

    sshave=sshave+sshanom/length(ii);
  end

  % make difference estimate
  sshave(isnan(sshave))=0;sshave(isnan(msk2(2:end-1,:)))=NaN;
  tpxest=sshave.*alpha;
 
  aviso_htanom(:,:,i)=tpxest;



end

eval(['cd ',current_dir])

