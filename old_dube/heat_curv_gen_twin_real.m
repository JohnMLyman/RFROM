function [hctpx,sshtpx]=heat_curv_gen_twin_real(tgrid)

current_dir=cd('/Users/johnlyman/data/Globalhc/HC');



load landmask_twin msk2
 load ../Mtpers/meanssh  sshmean
% to get rid of ice
sshmean=[sshmean(542:end,:);sshmean(1:541,:)];

sshmean(isnan(msk2(2:end-1,:)))=NaN;




s=sdir('../Mtpers/ssh*.mat');


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
alpha2=interp2(alat,alon,alpha2,lat,lon');clear al alon alat

% load area weighting matrix note... don't need to rearrange this one
%load ../Mtpers/areaweight arw
arw=areavec(lon,lat);







for i=1:length(tgrid)

  %  1-year mean topex
  sshave=zeros(length(lon),length(lat));

  tgrid(i)

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









tpxest=sshave.*alpha2;

hctpx(i)=nansum(arw(:).*tpxest(:));


sshtpx(i)=nansum(arw(:).*sshave(:));

end
cd(current_dir);




