% testfix.m - matlab script to test how well the short proile fix
% works.
% 3/6/3

d=dir('d*.mat');[dd,ii]=sortrows(strvcat(d(:).name));
d=d(ii);clear dd ii
dd=strvcat(d(:).name);dd=str2num(dd(:,2:5));

load ../Levitus/tlevhr lon lat dep levtemp
levtemp=[levtemp(end-40:end,:,:);levtemp;levtemp(1:41,:,:)];
lon=[-190.125:.25:190.125];
load numfixbot

ii=find((len-fixlen2)<100|(fixlen2./len)>.9);

% combine 1004 & 1005
% combine 1010 & 1011 & 1012
% combine 1701 1702
% 1514 set bind=kk(ind(31:end)); gind=kk(ind(1:30));
% combine 3312 & 3313 & 3314 set bind=kk(ind(91:end)); gind=kk(ind(1:90));
% combine 7011 & 7012
% combine 7701 & 7700
% ignore 1016, 1717, 3016
% ignore 5012 & 5013 & 5014 & 5017 & 7017

% loop through boxes that have short very few good profiles
% to check if they need special attention
tic,for l=62:length(d)

load(d(l).name,'temp','coords','depth')
switch dd(l)
  case 1004
    tmp=temp;cds=coords;
    load d1005 temp coords
    temp=[tmp;temp];coords=[cds;coords];
  case 1005
    err(l,:)=err(dd==1004,:);minerr(l)=minerr(dd==1004);
    temp=[];
  case 1010
    tmp=temp;cds=coords;
    load d1011 temp coords
    tmp=[tmp;temp];cds=[cds;coords];
    load d1012 temp coords
    temp=[tmp;temp];coords=[cds;coords];
  case {1011,1012}
    err(l,:)=err(dd==1010,:);minerr(l)=minerr(dd==1010);
    temp=[];
  case 1701
    tmp=temp;cds=coords;
    load d1702 temp coords
    temp=[tmp;temp];coords=[cds;coords];
  case 1702
    err(l,:)=err(dd==1701,:);minerr(l)=minerr(dd==1701);
    temp=[];
  case 3312
    tmp=temp;cds=coords;
    load d3313 temp coords
    tmp=[tmp;temp];cds=[cds;coords];
    load d3314 temp coords
    temp=[tmp;temp];coords=[cds;coords];
  case {3313,3314}
    err(l,:)=err(dd==3312,:);minerr(l)=minerr(dd==3312);
    temp=[];
  case 7011
    tmp=temp;cds=coords;
    load d7012 temp coords
    temp=[tmp;temp];coords=[cds;coords];
  case 7012
    err(l,:)=err(dd==7011,:);minerr(l)=minerr(dd==7011);
    temp=[];
  case 7700
    tmp=temp;cds=coords;
    load d7701 temp coords
    temp=[tmp;temp];coords=[cds;coords];
  case 7701
    err(l,:)=err(dd==7700,:);minerr(l)=minerr(dd==7700);
    temp=[];
end

if ~isempty(temp), kk=find(~isnan(sum(temp(:,1:76)')'));else,kk=1;end

if length(kk)>30
temp=temp(kk,:);coords=coords(kk,:);
ii=find(lon<max(coords(:,1))+.3&lon>min(coords(:,1)-.3));
jj=find(lat<max(coords(:,2))+.3&lat>min(coords(:,2)-.3));

blon(l,:)=[floor(min(coords(:,1))/10)*10,ceil(max(coords(:,1))/10)*10];
blat(l,:)=[floor(min(coords(:,2))/10)*10,ceil(max(coords(:,2))/10)*10];


tclim=zeros(size(temp,1),length(dep));
for i=1:length(dep)
  tclim(:,i)=interp2(lon(ii),lat(jj),levtemp(ii,jj,i)',...
	coords(:,1),coords(:,2));
end
tclim=interp1(dep,tclim',depth,'pchp')';
tanom=temp-tclim;
  
tanom=tanom(:,1:76);depth=depth(1:76);
ind=randperm(length(kk));ist=floor(length(kk)/2);
%bind=kk(ind(1:ist)); gind=kk(ind(ist+1:end));
bind=ind(1:ist); gind=ind(ist+1:end);
switch dd(l)
  case 3312
   %bind=kk(ind(91:end)); gind=kk(ind(1:90));
   bind=ind(91:end); gind=ind(1:90);
  case 1514
   %bind=kk(ind(31:end)); gind=kk(ind(1:30));
   bind=ind(31:end); gind=ind(1:30);
end

ns=[.001,.003,.005,.01,.05,.1:.05:.9];
for i=1:length(ns)
  ll=1:36;
  poo=tanom(gind,ll)'*tanom(gind,ll);
  al=tanom(gind,:)'*tanom(gind,ll)*inv(poo+ns(i)*diag(diag(poo)));clear poo
  ttest=tanom(bind,ll)*al';
  err(l,i)=nanstd(ttest(:,61)-tanom(bind,61));
end

if length(find(~isnan(err(l,:))>0))
 minerr(l)=ns(find(err(l,:)==min(err(l,:))));
 else,minerr(l)=NaN;
end
gnum(l)=length(gind);bnum(l)=length(bind);

disp([num2str([l toc]),'  ',d(l).name])

end
end

save noisefix d minerr err ns gnum bnum blon blat
