% % fixbottom.m - matlab script to fix profiles that don't go to 800m
% % 3/6/3
% 
% % turn off matrix-blows-up warning:
% warning off MATLAB:singularMatrix
cd './All_Data'

d=sdir('d*.mat');

save data into new e*.mat files
!rm e????.mat
for i=1:length(d)
  load(d(i).name)
  save(['e',d(i).name(2:end)],'bath','coords','dt','depth','mdep',...
	'nkept','npts','qual','temp','time','src','typ','isunk','oclnum');
end

% combine 1004 & 1005
if 0
load e1005
cds=coords;ddt=dt;mdp=mdep;np=npts;q=qual;tmp=temp;tm=time;bt=bath;
t=typ;s=src;isu=isunk;ocl=oclnum;
if exists('e1004') 
load e1004
coords=[cds;coords];dt=[ddt;dt];time=[tm;time];bath=[bt;bath];
temp=[tmp;temp];npts=[np;npts];qual=[q;qual];mdep=[mdp;mdep];
typ=strvcat(t,typ);src=strvcat(s,src);isunk=[isu;isunk];oclnum=[ocl;oclnum];
end
save e1004 coords dt time temp mdep npts qual depth nkept bath src typ isunk oclnum
!rm e1005.mat
end


if 0
% combine 1010 & 1011 & 1012
load e1012
cds=coords;ddt=dt;mdp=mdep;np=npts;q=qual;tmp=temp;tm=time;bt=bath;
t=typ;s=src;isu=isunk;ocl=oclnum;
load e1011
cds=[cds;coords];ddt=[ddt;dt];tm=[tm;time];mdp=[mdp;mdep];
tmp=[tmp;temp];np=[np;npts];q=[q;qual];bt=[bt;bath];isu=[isu;isunk];ocl=[ocl;oclnum];
t=strvcat(t,typ);s=strvcat(s,src);
load e1010
coords=[cds;coords];dt=[ddt;dt];time=[tm;time];bath=[bt;bath];
temp=[tmp;temp];npts=[np;npts];qual=[q;qual];mdep=[mdp;mdep];
typ=strvcat(t,typ);src=strvcat(s,src);isunk=[isu;isunk];oclnum=[ocl;oclnum];
save e1010 coords dt time temp mdep npts qual depth nkept bath src typ isunk oclnum
!rm e1011.mat e1012.mat
    
% combine 1701 1702
load e1702
cds=coords;ddt=dt;mdp=mdep;np=npts;q=qual;tmp=temp;tm=time;bt=bath;
t=typ;s=src;isu=isunk;ocl=oclnum;
load e1701
coords=[cds;coords];dt=[ddt;dt];time=[tm;time];bath=[bt;bath];
temp=[tmp;temp];npts=[np;npts];qual=[q;qual];mdep=[mdp;mdep];
typ=strvcat(t,typ);src=strvcat(s,src);isunk=[isu;isunk];oclnum=[ocl;oclnum];
save e1701 coords dt time temp mdep npts qual depth nkept bath src typ isunk oclnum
!rm e1702.mat

% combine 3312 & 3313 & 3314 
load e3314
cds=coords;ddt=dt;mdp=mdep;np=npts;q=qual;tmp=temp;tm=time;bt=bath;
t=typ;s=src;isu=isunk;ocl=oclnum;
load e3313
cds=[cds;coords];ddt=[ddt;dt];tm=[tm;time];mdp=[mdp;mdep];
tmp=[tmp;temp];np=[np;npts];q=[q;qual];bt=[bt;bath];isu=[isu;isunk];ocl=[ocl;oclnum];
t=strvcat(t,typ);s=strvcat(s,src);
load e3312
coords=[cds;coords];dt=[ddt;dt];time=[tm;time];bath=[bt;bath];
temp=[tmp;temp];npts=[np;npts];qual=[q;qual];mdep=[mdp;mdep];
typ=strvcat(t,typ);src=strvcat(s,src);isunk=[isu;isunk];oclnum=[ocl;oclnum];
save e3312 coords dt time temp mdep npts qual depth nkept bath src typ isunk oclnum
!rm e3313.mat e3314.mat 

% combine 5317 & 5318
if 0
load e5317
cds=coords;ddt=dt;mdp=mdep;np=npts;q=qual;tmp=temp;tm=time;bt=bath;
t=typ;s=src;isu=isunk;ocl=oclnum;
load e5318
coords=[cds;coords];dt=[ddt;dt];time=[tm;time];bath=[bt;bath];
temp=[tmp;temp];npts=[np;npts];qual=[q;qual];mdep=[mdp;mdep];
typ=strvcat(t,typ);src=strvcat(s,src);isunk=[isu;isunk];oclnum=[ocl;oclnum];
save e5317 coords dt time temp mdep npts qual depth nkept bath src typ isunk oclnum
!rm e5318.mat
end

% combine 7011 & 7012
load e7012
cds=coords;ddt=dt;mdp=mdep;np=npts;q=qual;tmp=temp;tm=time;bt=bath;
t=typ;s=src;isu=isunk;ocl=oclnum;
load e7011
coords=[cds;coords];dt=[ddt;dt];time=[tm;time];bath=[bt;bath];
temp=[tmp;temp];npts=[np;npts];qual=[q;qual];mdep=[mdp;mdep];
typ=strvcat(t,typ);src=strvcat(s,src);isunk=[isu;isunk];oclnum=[ocl;oclnum];
save e7011 coords dt time temp mdep npts qual depth nkept bath src typ isunk oclnum
!rm e7012.mat

% combine 7017 & 7018
if 0
load e7017
cds=coords;ddt=dt;mdp=mdep;np=npts;q=qual;tmp=temp;tm=time;bt=bath;
t=typ;s=src;isu=isunk;ocl=oclnum;
load e7018
coords=[cds;coords];dt=[ddt;dt];time=[tm;time];bath=[bt;bath];
temp=[tmp;temp];npts=[np;npts];qual=[q;qual];mdep=[mdp;mdep];
typ=strvcat(t,typ);src=strvcat(s,src);isunk=[isu;isunk];oclnum=[ocl;oclnum];
save e7017 coords dt time temp mdep npts qual depth nkept bath src typ isunk oclnum
!rm e7018.mat

% combine 7317 & 7018
load e7317
cds=coords;ddt=dt;mdp=mdep;np=npts;q=qual;tmp=temp;tm=time;bt=bath;
t=typ;s=src;isu=isunk;ocl=oclnum;
load e7318
coords=[cds;coords];dt=[ddt;dt];time=[tm;time];bath=[bt;bath];
temp=[tmp;temp];npts=[np;npts];qual=[q;qual];mdep=[mdp;mdep];
typ=strvcat(t,typ);src=strvcat(s,src);isunk=[isu;isunk];oclnum=[ocl;oclnum];
save e7317 coords dt time temp mdep npts qual depth nkept bath src typ isunk oclnum
!rm e7318.mat

% combine 7607 & 7608
load e7607
cds=coords;ddt=dt;mdp=mdep;np=npts;q=qual;tmp=temp;tm=time;bt=bath;
t=typ;s=src;isu=isunk;ocl=oclnum;
load e7608
coords=[cds;coords];dt=[ddt;dt];time=[tm;time];bath=[bt;bath];
temp=[tmp;temp];npts=[np;npts];qual=[q;qual];mdep=[mdp;mdep];
typ=strvcat(t,typ);src=strvcat(s,src);isunk=[isu;isunk];oclnum=[ocl;oclnum];
save e7607 coords dt time temp mdep npts qual depth nkept bath src typ isunk oclnum
!rm e7608.mat
end

% combine 7701 & 7700
load e7701
cds=coords;ddt=dt;mdp=mdep;np=npts;q=qual;tmp=temp;tm=time;bt=bath;
t=typ;s=src;isu=isunk;ocl=oclnum;
load e7700
coords=[cds;coords];dt=[ddt;dt];time=[tm;time];bath=[bt;bath];
temp=[tmp;temp];npts=[np;npts];qual=[q;qual];mdep=[mdp;mdep];
typ=strvcat(t,typ);src=strvcat(s,src);isunk=[isu;isunk];oclnum=[ocl;oclnum];
save e7700 coords dt time temp mdep npts qual depth nkept bath src typ isunk oclnum
!rm e7701.mat
end
% load Levitus high-res climatology (mean?) so we can subtract it
load /Users/johnlyman/data/Globalhc/Levitus/tlevhr lon lat dep levtemp
levtemp=[levtemp(end-40:end,:,:);levtemp;levtemp(1:41,:,:)];
lon=[lon(end-40:end)-360,lon,lon(1:41)+360];
ii=find(abs(lon)<180);
lt=mean(reshape(levtemp(ii,:,:),[length(ii)*length(lat),length(dep)]));
lt=reshape(lt,[1 1 length(dep)]);
levtemp(:,length(lat)+1,:)=repmat(lt,[length(lon),1,1]);
lat=[lat,90];
% % % 
% % % % get new file names
d=sdir('e*.mat');d=d(1:end);
dd=strvcat(d(:).name);dd=str2num(dd(:,2:5));
exte=[];

%loop through new data files and fix short profiles
tic,for l=1:length(d)
d(l).name
  load(d(l).name)
  depth=depth(1:5:end);temp=temp(:,1:5:end);

  % pick out box in climatology to make interpolation easier
  ii=find(lon<max(coords(:,1))+1&lon>min(coords(:,1)-1));
  jj=find(lat<max(coords(:,2))+1&lat>min(coords(:,2)-1));
  % keep coordinates of each box
  blon=mm(coords(:,1));
  blat=mm(coords(:,2));

  % interpolate Levitus onto profiles and subtract it
  tclim=zeros(size(temp,1),length(dep));
  for i=1:length(dep)
  tclim(:,i)=interp2(lon(ii),lat(jj),levtemp(ii,jj,i)',...
	coords(:,1),coords(:,2));
  end
  tclim=interp1(dep,tclim',depth,'pchp')';
  tanom=temp-tclim;
  
  % keep only depths to 750m 
  ll=find(depth<=750);
  tanom=tanom(:,ll);depth=depth(ll);

  % of the complete profiles, take a fraction out
  % and predict error in doing extension for each profile
  kk=find(~isnan(sum(tanom')'));
  nn=find(depth<=600);
  if strcmp(d(l).name,'e1500.mat'),kk=find(~isnan(sum(tanom(:,nn)')'));end
  ind=randperm(length(kk));ist=floor(length(kk)/2);
  bind=kk(ind(1:ist)); gind=kk(ind((ist+1):end));
  switch dd(l)
    case 3312
     bind=kk(ind(71:end)); gind=kk(ind(1:70));
%     case 1514
%      bind=kk(ind(21:end)); gind=kk(ind(1:20));
  end

  % test error vs. cutoff depth
  cdp=[350:25:800];
  if strcmp(d(l).name,'e1500.mat'),cdp=[350:25:600];clear hcerr;end
  for i=1:length(cdp)
    ll=find(depth<=cdp(i));
    poo=tanom(gind,ll)'*tanom(gind,ll);
    al=tanom(gind,:)'*tanom(gind,ll)*inv(poo+.1*diag(diag(poo)));clear poo
    ttest=tanom(bind,ll)*al';
    % calculate a quick and dirty HC to get error
    hc=trapz(depth,tanom(bind,:)')';
    hctest=trapz(depth,ttest')';
    hcerr(i)=nanstd(hc-hctest)/nanstd(hc);
    if strcmp(d(l).name,'e1500.mat')
      poo=tanom(gind,ll)'*tanom(gind,ll);
      nn=find(depth<=600);
      al=tanom(gind,nn)'*tanom(gind,ll)*inv(poo+.1*diag(diag(poo)));
      clear poo
      ttest=tanom(bind,ll)*al';
      hc=trapz(depth(nn),tanom(bind,nn)')';
      hctest=trapz(depth(nn),ttest')';
      hcerr(i)=nanstd(hc-hctest)/nanstd(hc);
    end
  end

  mdp=ones(size(tanom,1),1)*depth;mdp(isnan(tanom))=NaN;mdp=max(mdp')';
  ii=find(bath<mdp);mdp(ii)=depth(floor(bath(ii)/mean(diff(depth)))+1);
  % fractional error in each profile from doing extension
  exterr=interp1([cdp,max(mdp)+1],[hcerr,0],mdp);  
  exte=[exte;exterr];

  % fix profiles
  ttest=tanom;
  for i=36:76
    jj=find(mdp==depth(i));
    if ~isempty(jj)
      ll=1:i;
      poo=tanom(kk,ll)'*tanom(kk,ll);
      al=tanom(kk,:)'*tanom(kk,ll)*inv(poo+3e-3*diag(diag(poo)));
      ttest(jj,:)=tanom(jj,ll)*al';
    end
  end
  % replace tops of "fixed" profiles with original data
  ii=find(~isnan(tanom));ttest(ii)=tanom(ii);
  nn=find(depth<=750);
  tanom=ttest; temp=tanom+tclim(:,nn);

  save(d(l).name,'bath','blon','blat','coords','dt','depth','exterr',...
	'mdep','nkept','npts','qual','temp','time','src','typ','isunk','oclnum')

  disp([num2str([l toc]),'  ',d(l).name])
end

cd '..'

% turn off matrix-blows-up warning:
warning on MATLAB:singularMatrix


