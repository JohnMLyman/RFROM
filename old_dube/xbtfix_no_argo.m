% xbtfix.m - matlab script to read in mapped difference field from
% files and combine it with topex to get estimate of global heat
% content
% NOTE:  need map?????.txt data files!
% created 5/1/03

% get directory info
d=sdir('map_no_argo*.txt');
s=sdir('../Mtpers/ssh*.mat');

% load data on map grid
load gridinfo_no_argo
glon=lon;glat=lat;
gln=[glon(1)-(glon(end)-glon(end-1));glon;glon(end)+(glon(2)-glon(1))];

% load topex/hc regression info
load hregress2_no_argo

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
tic,for i=1:length(tgrid)

  %  1-year mean topex
  sshave=zeros(length(lon),length(lat));

  % load map and interpolate onto topex grid
  mp=load(d(i).name);clear map;map(gind,1:3)=mp;map(bind,:)=0;
  map=reshape(map,[length(glon),length(glat),3]);
  map=[map(end,:,:);map;map(1,:,:)];
  hmap=interp2(glat,gln,map(:,:,1),lat,lon');
  hmap2=interp2(glat,gln,map(:,:,2),lat,lon');
  tmap=interp2(glat,gln,map(:,:,3),lat,lon');

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
 
  corrhc=tpxest+hmap;

  save(['hc_no_season',d(i).name(11:15)],'corrhc','sshave',...
	'alpha','hmap*','lon','lat','tmap')

  % keep global average time series as we go
  hmap(isnan(corrhc))=NaN;hmap2(isnan(corrhc))=NaN;
  tmap(isnan(corrhc))=NaN;
  hc(i)=nansum(arw(:).*corrhc(:))/sum(arw(~isnan(corrhc)));
  df(i)=nansum(arw(:).*hmap(:))/sum(arw(~isnan(hmap)));
  tp(i)=nansum(arw(:).*tpxest(:))/sum(arw(~isnan(tpxest)));
  tsub(i)=nansum(arw(:).*tmap(:))/sum(arw(~isnan(tmap)));
  tpave(i)=nansum(arw(:).*sshave(:))/sum(arw(~isnan(sshave)));
  hc2(i)=nansum(arw(:).*hmap2(:))/sum(arw(~isnan(hmap2)));

  disp(num2str([i toc]))

end

% make heat storage
hs=(hc(5:end)-hc(1:end-4))/86400/365.25;
ds=(df(5:end)-df(1:end-4))/86400/365.25;
ts=(tp(5:end)-tp(1:end-4))/86400/365.25;
tg=(tgrid(5:end)+tgrid(1:end-4))/2;

save hcseries_no_season hc df tp hs ds ts tg tgrid hc2 tsub tpave

return

