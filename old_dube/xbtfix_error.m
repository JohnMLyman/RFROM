% xbtfix.m - matlab script to read in mapped difference field from
% files and combine it with topex to get estimate of global heat
% content
% NOTE:  need map?????.txt data files!
% created 5/1/03

% get directory info
d=sdir('map*const*.txt');
s=sdir('../Mtpers/ssh*.mat');

% load data on map grid
load gridinfo_const
glon=lon;glat=lat;
gln=[glon(1)-(glon(end)-glon(end-1));glon;glon(end)+(glon(2)-glon(1))];

% load topex/hc regression info
load hregress3

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
alpha=interp2(alat,alon,alpha,lat,lon');error=interp2(alat,alon,error,lat,lon');clear al alon alat

% load area weighting matrix note... don't need to rearrange this one
%load ../Mtpers/areaweight arw
arw=areavec(lon,lat);
load landmask msk2

alpha(isnan(msk2(2:end-1,:)))=NaN;
error(isnan(msk2(2:end-1,:)))=NaN;
% put the topex data into WMO squares
lat2=repmat(lat',[1080 1]);
lon2=repmat(lon,[1 915]);

  iii=find(lon2<=0&lat2>0);
  jjj=find(lon2>0 &lat2>0);
  lll=find(lon2<=0&lat2<=0);
  nnn=find(lon2>0 &lat2<=0);
  wnum(iii)=abs(ceil(lon2(iii)/10))+100*(ceil(lat2(iii)/10)-1)+7000;
  wnum(jjj)=ceil(lon2(jjj)/10)-1+100*(ceil(lat2(jjj)/10)-1)+1000;
  wnum(lll)=abs(ceil(lon2(lll)/10))+100*abs(ceil(lat2(lll)/10))+5000;
  wnum(nnn)=ceil(lon2(nnn)/10)-1+100*abs(ceil(lat2(nnn)/10))+3000;
wnum(isnan(msk2(2:end-1,:)))=NaN;
w_good=unique(wnum);
w_good=w_good(find(finite(w_good) == 1));


error_map=ones(1080,915,length(tgrid))*NaN;
W_map=error_map;
tp_map=error_map;

% loop through time grid and make 1 file per map
tic,for i=1:length(tgrid)

  %  1-year mean topex
  sshave=zeros(length(lon),length(lat));

  % load map and interpolate onto topex grid
  mp=load(d(i).name);clear map;map(gind,1:3)=mp;map(bind,:)=0;
  map=reshape(map,[length(glon),length(glat),3]);
  map=[map(end,:,:);map;map(1,:,:)];
  
  W=interp2(glat,gln,map(:,:,2),lat,lon');
  

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

  % make error maps
  sshave(isnan(sshave))=0;sshave(isnan(msk2(2:end-1,:)))=NaN;
  error_est=sshave.*(1-W).*error;
  tp_heat=sshave.*alpha;
  save(['hc',d(i).name(4:14)],'W','lon','lat')

  % keep global estimate of the error time series as we go add up 
  
  
  
  for iw=1,length(w_good);
      
      good=find(wnum == w_good(iw));
      junk_error(iw)=nansum(abs(error_est(good)))./length(good);
  end
  Area_tp=sum(arw(~isnan(tp_heat)));
  tp(i)=nansum(arw(:).*tp_heat(:))/Area_tp;
  N_tp=length(find(finite(wnum) == 1));
  N_real=300;
 
  
  error_globe(i)=student(N_real)*sqrt(nansum((arw(:).*error_est(:)).^2))/(Area_tp*sqrt(N_real/N_tp));
  error_globe2(i)=student(N_real)*sqrt(nansum((error_est(:)).^2))/(N_tp);
   error_globe3(i)=student(N_real)*sqrt(nansum((junk_error(:)).^2))/(length(w_good));
  error_map(:,:,i)=student(N_real)*error_est;
  W_map(:,:,i)=W;
  tp_map(:,:,i)=tp_heat;
  disp(num2str([i toc]))

end



save h_error_est tgrid alpha error error_globe lat lon wnum

return

