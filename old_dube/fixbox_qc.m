% fixbox.m - matlab script to treat WMO boxes that require individual
% attention.  

%%%%  NOTE!!!!	 THESE CHANGES ARE NOT REVERSIBLE, RUN ONLY ONCE!!!

%%%%%%%%%%%%%%%%%%%%     added 12/02/04
% makeempties.m - makes empty d????.mat files so that 
% fixbox.m script won't complain
% 3/31/04
cd './All_Data/qc'

load d1000 depth
bath=[];coords=[];dt=[];mdep=[];ndups=0;nkept=0;npts=[];
ntot=0;qual=[];src=[];temp=[];time=[];typ=[];

nn=num2str([1 3 5 7]');
ln=num2str([0:17]');ln(ln==' ')='0';
lt=num2str([0:8]');
ff=[];
for i=1:length(nn)
  for j=1:length(ln)
    for k=1:length(lt)
      fname=['d',nn(i),lt(k),ln(j,:),'.mat'];
      ff=[ff;fname];
      if ~exist(fname)
         save(fname,'bath','coords','dt','mdep','ndups','nkept',...
              'npts','ntot','qual','src','temp','time','typ');
      end
    end
  end
end
%%%%%%%%%%%%%%%%%%%%

% first throw out files that have no data

d=sdir('d*.mat');
for i=1:length(d)
  load(d(i).name,'nkept');
  len(i)=nkept;
end

% d1104 - seperate red sea data
load d1104
ii=find(temp(:,101)>21);jj=find(temp(:,101)<=21);
cds=coords;ddt=dt;mdp=mdep;np=npts;q=qual;tmp=temp;tm=time;
bt=bath;s=src;t=typ;isu=isunk;

% save gulf of aden data in d1104
coords=cds(jj,:);dt=ddt(jj,:);time=tm(jj,:);temp=tmp(jj,:);
mdep=mdep(jj,:);npts=np(jj,:);qual=q(jj,:);nkept=length(jj);
typ=t(jj,:);src=s(jj,:);bath=bt(jj);isunk=isunk(jj,:);
save d1104 bath src typ coords dt time temp mdep npts qual depth nkept isunk

% save all red sea data together in d1203
load d1103
cds=[cds(ii,:);coords];ddt=[ddt(ii,:);dt];tm=[tm(ii,:);time];
tmp=[tmp(ii,:);temp];np=[np(ii);npts];q=[q(ii);qual];mdp=[mdp(ii);mdep];
t=strvcat(t(ii,:),typ);s=strvcat(s(ii,:),src);bt=[bt(ii);bath];
isu=[isu(ii);isunk];
load d1203
coords=[cds;coords];dt=[ddt;dt];time=[tm;time];
temp=[tmp;temp];npts=[np;npts];qual=[q;qual];mdep=[mdp;mdep];
typ=strvcat(t,typ);src=strvcat(s,src);bath=[bt;bath];isunk=[isu;isunk];
nkept=size(temp,1);
save d1203 bath src typ coords dt time temp mdep npts qual depth nkept isunk
!rm d1103.mat 

% combine bay of bengal into d1108
load d1108
cds=coords;ddt=dt;mdp=mdep;np=npts;q=qual;tmp=temp;tm=time;
bt=bath;s=src;t=typ;isu=isunk;
load d1109
coords=[cds;coords];dt=[ddt;dt];time=[tm;time];
temp=[tmp;temp];npts=[np;npts];qual=[q;qual];mdep=[mdp;mdep];
typ=strvcat(t,typ);src=strvcat(s,src);bath=[bt;bath];isunk=[isu;isunk];
save d1108 bath src typ coords dt time temp mdep npts qual depth nkept isunk
!rm d1109.mat d1208.mat d1209.mat

% combine part of south china sea
load d1110
cds=coords;ddt=dt;mdp=mdep;np=npts;q=qual;tmp=temp;tm=time;
bt=bath;s=src;t=typ;isu=isunk;
load d1111
coords=[cds;coords];dt=[ddt;dt];time=[tm;time];
temp=[tmp;temp];npts=[np;npts];qual=[q;qual];mdep=[mdp;mdep];
typ=strvcat(t,typ);src=strvcat(s,src);bath=[bt;bath];isunk=[isu;isunk];
save d1110 bath src typ coords dt time temp mdep npts qual depth nkept isunk
!rm d1111.mat

% combine northern arabian sea -- note temperature inversions!!!
load d1205
cds=coords;ddt=dt;mdp=mdep;np=npts;q=qual;tmp=temp;tm=time;
bt=bath;s=src;t=typ;isu=isunk;
load d1206
coords=[cds;coords];dt=[ddt;dt];time=[tm;time];
temp=[tmp;temp];npts=[np;npts];qual=[q;qual];mdep=[mdp;mdep];
typ=strvcat(t,typ);src=strvcat(s,src);bath=[bt;bath];isunk=[isu;isunk];
save d1205 bath src typ coords dt time temp mdep npts qual depth nkept isunk
!rm d1206.mat

% get rest of S. China sea together
load d1110
cds=coords;ddt=dt;mdp=mdep;np=npts;q=qual;tmp=temp;tm=time;
bt=bath;s=src;t=typ;isu=isunk;
load d1211
coords=[cds;coords];dt=[ddt;dt];time=[tm;time];
temp=[tmp;temp];npts=[np;npts];qual=[q;qual];mdep=[mdp;mdep];isunk=[isu;isunk];
typ=strvcat(t,typ);src=strvcat(s,src);bath=[bt;bath];
save d1110 bath src typ coords dt time temp mdep npts qual depth nkept isunk
!rm d1211.mat

% combine med sea into 4 different regions by longitude
load d7300
ii=find(coords(:,1)>-6);jj=find(coords(:,1)<=-6);
cds=coords(ii,:);ddt=dt(ii,:);mdp=mdep(ii);np=npts(ii);
q=qual(ii);tmp=temp(ii,:);tm=time(ii,:);isu=isunk(ii);
t=typ(ii,:);s=src(ii,:);bt=bath(ii);
coords=coords(jj,:);dt=dt(jj,:);mdep=mdep(jj);isunk=isunk(jj);
npts=npts(jj);qual=qual(jj);temp=temp(jj,:);time=time(jj,:);
typ=typ(jj,:);src=src(jj,:);bath=bath(jj);
save d7300 bath src typ coords dt time temp mdep npts qual depth nkept isunk
load d1300
cds=[cds;coords];ddt=[ddt;dt];tm=[tm;time];mdp=[mdp;mdep];
tmp=[tmp;temp];np=[np;npts];q=[q;qual];isu=[isu;isunk];
t=strvcat(t,typ);s=strvcat(s,src);bt=[bt;bath];
load d1400
coords=[cds;coords];dt=[ddt;dt];time=[tm;time];
temp=[tmp;temp];npts=[np;npts];qual=[q;qual];mdep=[mdp;mdep];
typ=strvcat(t,typ);src=strvcat(s,src);bath=[bt;bath];isunk=[isu;isunk];
save d1300 bath src typ coords dt time temp mdep npts qual depth nkept isunk
!rm d1400.mat

load d3014
cds=coords;ddt=dt;mdp=mdep;np=npts;q=qual;tmp=temp;tm=time;
t=typ;s=src;bt=bath;isu=isunk;
load d3114
coords=[cds;coords];dt=[ddt;dt];time=[tm;time];
temp=[tmp;temp];npts=[np;npts];qual=[q;qual];mdep=[mdp;mdep];
typ=strvcat(t,typ);src=strvcat(s,src);bath=[bt;bath];isunk=[isu;isunk];
save d3114 bath src typ coords dt time temp mdep npts qual depth nkept isunk
!rm d3014.mat

load d1301
cds=coords;ddt=dt;mdp=mdep;np=npts;q=qual;tmp=temp;tm=time;
t=typ;s=src;bt=bath;isu=isunk;
load d1401
coords=[cds;coords];dt=[ddt;dt];time=[tm;time];
temp=[tmp;temp];npts=[np;npts];qual=[q;qual];mdep=[mdp;mdep];
typ=strvcat(t,typ);src=strvcat(s,src);bath=[bt;bath];isunk=[isu;isunk];
save d1301 bath src typ coords dt time temp mdep npts qual depth nkept isunk
!rm d1401.mat

load d1402
ii=find(coords(:,2)<41);jj=find(coords(:,2)>=41);
cds=coords(ii,:);ddt=dt(ii,:);mdp=mdep(ii);np=npts(ii);
q=qual(ii);tmp=temp(ii,:);tm=time(ii,:);isu=isunk(ii);
t=typ(ii,:);s=src(ii,:);bt=bath(ii);
coords=coords(jj,:);dt=dt(jj,:);mdep=mdep(jj);isunk=isunk(jj);
npts=npts(jj);qual=qual(jj);temp=temp(jj,:);time=time(jj,:);
typ=typ(jj,:);src=src(jj,:);bath=bath(jj);
save d1402 bath src typ coords dt time temp mdep npts qual depth nkept isunk
load d1302
coords=[cds;coords];dt=[ddt;dt];time=[tm;time];
temp=[tmp;temp];npts=[np;npts];qual=[q;qual];mdep=[mdp;mdep];
typ=strvcat(t,typ);src=strvcat(s,src);bath=[bt;bath];isunk=[isu;isunk];
save d1302 bath src typ coords dt time temp mdep npts qual depth nkept isunk

load d1402
cds=coords;ddt=dt;mdp=mdep;np=npts;q=qual;tmp=temp;tm=time;
t=typ;s=src;bt=bath;isu=isunk;
load d1403
cds=[cds;coords];ddt=[ddt;dt];tm=[tm;time];
tmp=[tmp;temp];np=[np;npts];q=[q;qual];mdp=[mdp;mdep];
t=strvcat(t,typ);s=strvcat(s,src);bt=[bt;bath];isu=[isu;isunk];
load d1404
coords=[cds;coords];dt=[ddt;dt];time=[tm;time];
temp=[tmp;temp];npts=[np;npts];qual=[q;qual];mdep=[mdp;mdep];
typ=strvcat(t,typ);src=strvcat(s,src);bath=[bt;bath];isunk=[isu;isunk];
save d1403 bath src typ coords dt time temp mdep npts qual depth nkept isunk
!rm d1402.mat d1404.mat

load d1312
cds=coords;ddt=dt;mdp=mdep;np=npts;q=qual;tmp=temp;tm=time;
t=typ;s=src;bt=bath;isu=isunk;
load d1313
coords=[cds;coords];dt=[ddt;dt];time=[tm;time];
temp=[tmp;temp];npts=[np;npts];qual=[q;qual];mdep=[mdp;mdep];
typ=strvcat(t,typ);src=strvcat(s,src);bath=[bt;bath];isunk=[isu;isunk];
ii=find(coords(:,2)<35.4);jj=find(coords(:,2)>=35.4);
cds=coords(ii,:);ddt=dt(ii,:);mdp=mdep(ii);np=npts(ii);
q=qual(ii);tmp=temp(ii,:);tm=time(ii,:);isu=isunk(ii);
t=typ(ii,:);s=src(ii,:);bt=bath(ii,:);
coords=coords(jj,:);dt=dt(jj,:);mdep=mdep(jj);isunk=isunk(jj);
npts=npts(jj);qual=qual(jj);temp=temp(jj,:);time=time(jj,:);
typ=typ(jj,:);src=src(jj,:);bath=bath(jj,:);
save d1312 bath src typ coords dt time temp mdep npts qual depth nkept isunk
coords=cds;dt=ddt;mdep=mdp;npts=np;qual=q;temp=tmp;time=tm;isunk=isu;
typ=t;src=s;bath=bt;
save d1313 bath src typ coords dt time temp mdep npts qual depth nkept isunk
!rm d1412.mat

load d1515
cds=coords;ddt=dt;mdp=mdep;np=npts;q=qual;tmp=temp;tm=time;
t=typ;s=src;bt=bath;isu=isunk;
ii=find(cds(:,1)<156.5);jj=find(cds(:,1)>156.5);
load d1514
coords=[cds(ii,:);coords];dt=[ddt(ii,:);dt];time=[tm(ii,:);time];
temp=[tmp(ii,:);temp];npts=[np(ii);npts];qual=[q(ii);qual];
mdep=[mdp(ii);mdep];isunk=[isu(ii);isunk];
typ=strvcat(t(ii,:),typ);src=strvcat(s(ii,:),src);bath=[bt(ii);bath];
save d1514 bath src typ coords dt time temp mdep npts qual depth nkept isunk
load d1516
coords=[cds(jj,:);coords];dt=[ddt(jj,:);dt];time=[tm(jj,:);time];
temp=[tmp(jj,:);temp];npts=[np(jj);npts];qual=[q(jj);qual];
mdep=[mdp(jj);mdep];isunk=[isu(jj);isunk];
typ=strvcat(t(jj,:),typ);src=strvcat(s(jj,:),src);bath=[bt(jj);bath];
save d1516 bath src typ coords dt time temp mdep npts qual depth nkept isunk
!rm d1515.mat

load d1617
cds=coords;ddt=dt;mdp=mdep;np=npts;q=qual;tmp=temp;tm=time;
t=typ;s=src;bt=bath;isu=isunk;
load d1517
coords=[cds;coords];dt=[ddt;dt];time=[tm;time];
temp=[tmp;temp];npts=[np;npts];qual=[q;qual];mdep=[mdp;mdep];
typ=strvcat(t,typ);src=strvcat(s,src);bath=[bt;bath];isunk=[isu;isunk];
save d1517 bath src typ coords dt time temp mdep npts qual depth nkept isunk
!rm d1617.mat

load d1501
cds=coords;ddt=dt;mdp=mdep;np=npts;q=qual;tmp=temp;tm=time;
t=typ;s=src;bt=bath;isu=isunk;
load d1500
coords=[cds;coords];dt=[ddt;dt];time=[tm;time];
temp=[tmp;temp];npts=[np;npts];qual=[q;qual];mdep=[mdp;mdep];
typ=strvcat(t,typ);src=strvcat(s,src);bath=[bt;bath];isunk=[isu;isunk];
save d1500 bath src typ coords dt time temp mdep npts qual depth nkept isunk
!rm d1501.mat 

ii=num2str([0:17]');ii(1:10,1)='0';
cds=[];ddt=[];mdp=[];np=[];q=[];tmp=[];tm=[];isu=[];
t=[];s=[];bt=[];
for i=3:10
  if exist(['d17',ii(i,:),'.mat'])
    load(['d17',ii(i,:)])
    cds=[cds;coords];ddt=[ddt;dt];tm=[tm;time];
    tmp=[tmp;temp];np=[np;npts];q=[q;qual];mdp=[mdp;mdep];
    t=strvcat(t,typ);s=strvcat(s,src);bt=[bt;bath];isu=[isu;isunk];
  end
end
coords=cds;dt=ddt;mdep=mdp;npts=np;qual=q;temp=tmp;time=tm;
typ=t;src=s;bath=bt;isunk=isu;
save d1702 bath src typ coords dt time temp mdep npts qual depth nkept isunk
!rm d1703.mat d1704.mat d1705.mat d1706.mat d1707.mat d1708.mat d1709.mat
    
ii=num2str([0:17]');ii(1:10,1)='0';
cds=[];ddt=[];mdp=[];np=[];q=[];tmp=[];tm=[];isu=[];
t=[];s=[];bt=[];
for i=11:18
  if exist(['d17',ii(i,:),'.mat'])
    load(['d17',ii(i,:)])
 % note I had to remove d1715.mat and d1716.mat to get the code to work,
 % this is becasue the files were empty.
    cds=[cds;coords];ddt=[ddt;dt];tm=[tm;time];
    tmp=[tmp;temp];
    np=[np;npts];
    q=[q;qual];
    mdp=[mdp;mdep];
    t=strvcat(t,typ);s=strvcat(s,src);bt=[bt;bath];isu=[isu;isunk];
  end
end
coords=cds;dt=ddt;mdep=mdp;npts=np;qual=q;temp=tmp;time=tm;
typ=t;src=s;bath=bt;isunk=isu;
save d1717 bath src typ coords dt time temp mdep npts qual depth nkept isunk
!rm d1710.mat d1711.mat d1712.mat d1713.mat d1714.mat d1715.mat d1716.mat

ii=num2str([0:17]');ii(1:10,1)='0';
cds=[];ddt=[];mdp=[];np=[];q=[];tmp=[];tm=[];isu=[];
t=[];s=[];bt=[];
for i=1:18
  if exist(['d18',ii(i,:),'.mat'])
    load(['d18',ii(i,:)])
    cds=[cds;coords];ddt=[ddt;dt];tm=[tm;time];
    tmp=[tmp;temp];np=[np;npts];q=[q;qual];mdp=[mdp;mdep];
    t=strvcat(t,typ);s=strvcat(s,src);bt=[bt;bath];isu=[isu;isunk];
  end
end
coords=cds;dt=ddt;mdep=mdp;npts=np;qual=q;temp=tmp;time=tm;
typ=t;src=s;bath=bt;isunk=isu;
save d1800 bath src typ coords dt time temp mdep npts qual depth nkept isunk
!rm d180[1-9].mat d181?.mat

load d3001
cds=coords;ddt=dt;mdp=mdep;np=npts;q=qual;tmp=temp;tm=time;
t=typ;s=src;bt=bath;isu=isunk;
load d3000
coords=[cds;coords];dt=[ddt;dt];time=[tm;time];
temp=[tmp;temp];npts=[np;npts];qual=[q;qual];mdep=[mdp;mdep];
typ=strvcat(t,typ);src=strvcat(s,src);bath=[bt;bath];isunk=[isu;isunk];
save d3000 bath src typ coords dt time temp mdep npts qual depth nkept isunk
!rm d3001.mat

load d3003
cds=coords;ddt=dt;mdp=mdep;np=npts;q=qual;tmp=temp;tm=time;
t=typ;s=src;bt=bath;isu=isunk;
load d3004
coords=[cds;coords];dt=[ddt;dt];time=[tm;time];
temp=[tmp;temp];npts=[np;npts];qual=[q;qual];mdep=[mdp;mdep];
typ=strvcat(t,typ);src=strvcat(s,src);bath=[bt;bath];isunk=[isu;isunk];
save d3003 bath src typ coords dt time temp mdep npts qual depth nkept isunk
!rm d3004.mat

ii=num2str([0:17]');ii(1:10,1)='0';
cds=[];ddt=[];mdp=[];np=[];q=[];tmp=[];tm=[];isu=[];
t=[];s=[];bt=[];
for i=1:4
  if exist(['d34',ii(i,:),'.mat'])
    load(['d34',ii(i,:)])
    cds=[cds;coords];ddt=[ddt;dt];tm=[tm;time];
    tmp=[tmp;temp];np=[np;npts];q=[q;qual];mdp=[mdp;mdep];
    t=strvcat(t,typ);s=strvcat(s,src);bt=[bt;bath];isu=[isu;isunk];
  end
end
coords=cds;dt=ddt;mdep=mdp;npts=np;qual=q;temp=tmp;time=tm;
typ=t;src=s;bath=bt;isunk=isu;
ii=find(temp(:,201)>11);jj=find(temp(:,201)<=11);
cds=coords(ii,:);ddt=dt(ii,:);mdp=mdep(ii);np=npts(ii);
q=qual(ii);tmp=temp(ii,:);tm=time(ii,:);isu=isunk(ii);
t=typ(ii,:);s=src(ii,:);bt=bath(ii);
coords=coords(jj,:);dt=dt(jj,:);mdep=mdep(jj);isunk=isunk(jj);
npts=npts(jj);qual=qual(jj);temp=temp(jj,:);time=time(jj,:);
typ=typ(jj,:);src=src(jj,:);bath=bath(jj);
save d3400 bath src typ coords dt time temp mdep npts qual depth nkept isunk
load d3302
coords=[cds;coords];dt=[ddt;dt];time=[tm;time];
temp=[tmp;temp];npts=[np;npts];qual=[q;qual];mdep=[mdp;mdep];
typ=strvcat(t,typ);src=strvcat(s,src);bath=[bt;bath];isunk=[isu;isunk];
save d3302 bath src typ coords dt time temp mdep npts qual depth nkept isunk
!rm d340[1-3].mat

ii=num2str([0:17]');ii(1:10,1)='0';
cds=[];ddt=[];mdp=[];np=[];q=[];tmp=[];tm=[];isu=[];
t=[];s=[];bt=[];
for i=4:14
  if exist(['d34',ii(i,:),'.mat'])
    load(['d34',ii(i,:)])
    len(i)=length(mdep);
    cds=[cds;coords];ddt=[ddt;dt];tm=[tm;time];
    tmp=[tmp;temp];np=[np;npts];q=[q;qual];mdp=[mdp;mdep];
    t=strvcat(t,typ);s=strvcat(s,src);bt=[bt;bath];isu=[isu;isunk];
  end
end
coords=cds;dt=ddt;mdep=mdp;npts=np;qual=q;temp=tmp;time=tm;
typ=t;src=s;bath=bt;isunk=isu;
save d3403 bath src typ coords dt time temp mdep npts qual depth nkept isunk
!rm d340[4-9].mat d341[0-3].mat

load d3414
cds=coords;ddt=dt;mdp=mdep;np=npts;q=qual;tmp=temp;tm=time;
t=typ;s=src;bt=bath;isu=isunk;
load d3415
coords=[cds;coords];dt=[ddt;dt];time=[tm;time];
temp=[tmp;temp];npts=[np;npts];qual=[q;qual];mdep=[mdp;mdep];
typ=strvcat(t,typ);src=strvcat(s,src);bath=[bt;bath];isunk=[isu;isunk];
save d3414 bath src typ coords dt time temp mdep npts qual depth nkept isunk
!rm d3415.mat

load d3416
cds=coords;ddt=dt;mdp=mdep;np=npts;q=qual;tmp=temp;tm=time;
t=typ;s=src;bt=bath;isu=isunk;
load d3414
coords=[cds;coords];dt=[ddt;dt];time=[tm;time];
temp=[tmp;temp];npts=[np;npts];qual=[q;qual];mdep=[mdp;mdep];
typ=strvcat(t,typ);src=strvcat(s,src);bath=[bt;bath];isunk=[isu;isunk];
save d3414 bath src typ coords dt time temp mdep npts qual depth nkept isunk
!rm d3416.mat

load d3417
cds=coords;ddt=dt;mdp=mdep;np=npts;q=qual;tmp=temp;tm=time;
t=typ;s=src;bt=bath;isu=isunk;
ii=find(coords(:,1)<173&coords(:,2)>-43);
jj=find(~(coords(:,1)<173&coords(:,2)>-43));
cds=coords(ii,:);ddt=dt(ii,:);mdp=mdep(ii);np=npts(ii);
q=qual(ii);tmp=temp(ii,:);tm=time(ii,:);isu=isunk(ii);
t=typ(ii,:);s=src(ii,:);bt=bath(ii);
coords=coords(jj,:);dt=dt(jj,:);mdep=mdep(jj);isunk=isunk(jj);
npts=npts(jj);qual=qual(jj);temp=temp(jj,:);time=time(jj,:);
typ=typ(jj,:);src=src(jj,:);bath=bath(jj);
save d3417 bath src typ coords dt time temp mdep npts qual depth nkept isunk
load d3414
coords=[cds;coords];dt=[ddt;dt];time=[tm;time];
temp=[tmp;temp];npts=[np;npts];qual=[q;qual];mdep=[mdp;mdep];
typ=strvcat(t,typ);src=strvcat(s,src);bath=[bt;bath];isunk=[isu;isunk];
save d3414 bath src typ coords dt time temp mdep npts qual depth nkept isunk

ii=num2str([0:17]');ii(1:10,1)='0';
cds=[];ddt=[];mdp=[];np=[];q=[];tmp=[];tm=[];isu=[];
t=[];s=[];bt=[];
for i=1:4
  if exist(['d35',ii(i,:),'.mat'])
    load(['d35',ii(i,:)])
    len(i)=length(mdep);
    cds=[cds;coords];ddt=[ddt;dt];tm=[tm;time];
    tmp=[tmp;temp];np=[np;npts];q=[q;qual];mdp=[mdp;mdep];
    t=strvcat(t,typ);s=strvcat(s,src);bt=[bt;bath];isu=[isu;isunk];
  end
end
coords=cds;dt=ddt;mdep=mdp;npts=np;qual=q;temp=tmp;time=tm;
typ=t;src=s;bath=bt;isunk=isu;
save d3500 bath src typ coords dt time temp mdep npts qual depth nkept isunk
!rm d350[1-3].mat

ii=num2str([0:17]');ii(1:10,1)='0';
cds=[];ddt=[];mdp=[];np=[];q=[];tmp=[];tm=[];isu=[];
t=[];s=[];bt=[];
for i=5:12
  if exist(['d35',ii(i,:),'.mat'])
    load(['d35',ii(i,:)])
    len(i)=length(mdep);
    cds=[cds;coords];ddt=[ddt;dt];tm=[tm;time];
    tmp=[tmp;temp];np=[np;npts];q=[q;qual];mdp=[mdp;mdep];
    t=strvcat(t,typ);s=strvcat(s,src);bt=[bt;bath];isu=[isu;isunk];
  end
end
coords=cds;dt=ddt;mdep=mdp;npts=np;qual=q;temp=tmp;time=tm;
typ=t;src=s;bath=bt;isunk=isu;
poo=nanmean(temp(:,346:356)')'-nanmean(temp(:,146:156)')';
ii=find(poo<-1);jj=find(poo>=-1);
cds=coords(ii,:);ddt=dt(ii,:);mdp=mdep(ii);np=npts(ii);
q=qual(ii);tmp=temp(ii,:);tm=time(ii,:);isu=isunk(ii);
t=typ(ii,:);s=src(ii,:);bt=bath(ii);
coords=coords(jj,:);dt=dt(jj,:);mdep=mdep(jj);isunk=isunk(jj);
npts=npts(jj);qual=qual(jj);temp=temp(jj,:);time=time(jj,:);
typ=typ(jj,:);src=src(jj,:);bath=bath(jj);
save d3504 bath src typ coords dt time temp mdep npts qual depth nkept isunk
load d3403
coords=[cds;coords];dt=[ddt;dt];time=[tm;time];
temp=[tmp;temp];npts=[np;npts];qual=[q;qual];mdep=[mdp;mdep];
typ=strvcat(t,typ);src=strvcat(s,src);bath=[bt;bath];isunk=[isu;isunk];
save d3403 bath src typ coords dt time temp mdep npts qual depth nkept isunk
!rm d350[5-9].mat d351[0-1].mat

ii=num2str([0:17]');ii(1:10,1)='0';
cds=[];ddt=[];mdp=[];np=[];q=[];tmp=[];tm=[]; isu=[];
t=[];s=[];bt=[];
for i=12:18
  if exist(['d35',ii(i,:),'.mat'])
    load(['d35',ii(i,:)])
    len(i)=length(mdep);
    cds=[cds;coords];ddt=[ddt;dt];tm=[tm;time];
    tmp=[tmp;temp];np=[np;npts];q=[q;qual];mdp=[mdp;mdep];
    t=strvcat(t,typ);s=strvcat(s,src);bt=[bt;bath];isu=[isu;isunk];
  end
end
coords=cds;dt=ddt;mdep=mdp;npts=np;qual=q;temp=tmp;time=tm;
typ=t;src=s;bath=bt;isunk=isu;
save d3512 bath src typ coords dt time temp mdep npts qual depth nkept isunk
!rm d351[3-7].mat

ii=num2str([0:17]');ii(1:10,1)='0';
cds=[];ddt=[];mdp=[];np=[];q=[];tmp=[];tm=[];isu=[];
t=[];s=[];bt=[];
for i=1:18
  if exist(['d36',ii(i,:),'.mat'])
    load(['d36',ii(i,:)])
    len(i)=length(mdep);
    cds=[cds;coords];ddt=[ddt;dt];tm=[tm;time];
    tmp=[tmp;temp];np=[np;npts];q=[q;qual];mdp=[mdp;mdep];
    t=strvcat(t,typ);s=strvcat(s,src);bt=[bt;bath];isu=[isu;isunk];
  end
end
coords=cds;dt=ddt;mdep=mdp;npts=np;qual=q;temp=tmp;time=tm;
typ=t;src=s;bath=bt;isunk=isu;
save d3600 bath src typ coords dt time temp mdep npts qual depth nkept isunk
!rm d360[1-9].mat d361[0-7].mat

ii=num2str([0:17]');ii(1:10,1)='0';
cds=[];ddt=[];mdp=[];np=[];q=[];tmp=[];tm=[];isu=[];
t=[];s=[];bt=[];
for j=[3 5]
for i=1:18
  if exist(['d',num2str(j),'7',ii(i,:),'.mat'])
    load(['d',num2str(j),'7',ii(i,:)])
    len(i)=length(mdep);
    cds=[cds;coords];ddt=[ddt;dt];tm=[tm;time];
    tmp=[tmp;temp];np=[np;npts];q=[q;qual];mdp=[mdp;mdep];
    t=strvcat(t,typ);s=strvcat(s,src);bt=[bt;bath];isu=[isu;isunk];
  end
end
end
coords=cds;dt=ddt;mdep=mdp;npts=np;qual=q;temp=tmp;time=tm;
typ=t;src=s;bath=bt;isunk=isu;
save d3700 bath src typ coords dt time temp mdep npts qual depth nkept isunk
!rm d370[1-9].mat d371[0-7].mat d570[0-9].mat d571[0-7].mat

load d5007
cds=coords;ddt=dt;mdp=mdep;np=npts;q=qual;tmp=temp;tm=time;
t=typ;s=src;bt=bath;isu=isunk;
load d5008
coords=[cds;coords];dt=[ddt;dt];time=[tm;time];
temp=[tmp;temp];npts=[np;npts];qual=[q;qual];mdep=[mdp;mdep];
typ=strvcat(t,typ);src=strvcat(s,src);bath=[bt;bath];isunk=[isu;isunk];
save d5008 bath src typ coords dt time temp mdep npts qual depth nkept isunk
!rm d5007.mat

ii=num2str([0:17]');ii(1:10,1)='0';
cds=[];ddt=[];mdp=[];np=[];q=[];tmp=[];tm=[];isu=[];
t=[];s=[];bt=[];
for i=1:5
  if exist(['d53',ii(i,:),'.mat'])
    load(['d53',ii(i,:)])
    len(i)=length(mdep);
    cds=[cds;coords];ddt=[ddt;dt];tm=[tm;time];
    tmp=[tmp;temp];np=[np;npts];q=[q;qual];mdp=[mdp;mdep];
    t=strvcat(t,typ);s=strvcat(s,src);bt=[bt;bath];isu=[isu;isunk];
  end
end
coords=cds;dt=ddt;mdep=mdp;npts=np;qual=q;temp=tmp;time=tm;
typ=t;src=s;bath=bt;isunk=isu;
save d5300 bath src typ coords dt time temp mdep npts qual depth nkept isunk
!rm d530[1-4].mat

ii=num2str([0:17]');ii(1:10,1)='0';
cds=[];ddt=[];mdp=[];np=[];q=[];tmp=[];tm=[];isu=[];
t=[];s=[];bt=[];
for i=1:7
  if exist(['d54',ii(i,:),'.mat'])
    load(['d54',ii(i,:)])
    len(i)=length(mdep);
    cds=[cds;coords];ddt=[ddt;dt];tm=[tm;time];
    tmp=[tmp;temp];np=[np;npts];q=[q;qual];mdp=[mdp;mdep];
    t=strvcat(t,typ);s=strvcat(s,src);bt=[bt;bath];isu=[isu;isunk];
  end
end
coords=cds;dt=ddt;mdep=mdp;npts=np;qual=q;temp=tmp;time=tm;
typ=t;src=s;bath=bt;isunk=isu;
save d5400 bath src typ coords dt time temp mdep npts qual depth nkept isunk
!rm d540[1-6].mat

ii=num2str([0:17]');ii(1:10,1)='0';
cds=[];ddt=[];mdp=[];np=[];q=[];tmp=[];tm=[];isu=[];
t=[];s=[];bt=[];
for i=9:13
  if exist(['d54',ii(i,:),'.mat'])
    load(['d54',ii(i,:)])
    len(i)=length(mdep);
    cds=[cds;coords];ddt=[ddt;dt];tm=[tm;time];
    tmp=[tmp;temp];np=[np;npts];q=[q;qual];mdp=[mdp;mdep];
    t=strvcat(t,typ);s=strvcat(s,src);bt=[bt;bath];isu=[isu;isunk];
  end
end
coords=cds;dt=ddt;mdep=mdp;npts=np;qual=q;temp=tmp;time=tm;
typ=t;src=s;bath=bt;isunk=isu;
save d5408 bath src typ coords dt time temp mdep npts qual depth nkept isunk
!rm d5409.mat d541[0-2].mat

ii=num2str([0:17]');ii(1:10,1)='0';
cds=[];ddt=[];mdp=[];np=[];q=[];tmp=[];tm=[];isu=[];
t=[];s=[];bt=[];
for i=14:17
  if exist(['d54',ii(i,:),'.mat'])
    load(['d54',ii(i,:)])
    len(i)=length(mdep);
    cds=[cds;coords];ddt=[ddt;dt];tm=[tm;time];
    tmp=[tmp;temp];np=[np;npts];q=[q;qual];mdp=[mdp;mdep];
    t=strvcat(t,typ);s=strvcat(s,src);bt=[bt;bath];isu=[isu;isunk];
  end
end
coords=cds;dt=ddt;mdep=mdp;npts=np;qual=q;temp=tmp;time=tm;
typ=t;src=s;bath=bt;isunk=isu;
save d5413 bath src typ coords dt time temp mdep npts qual depth nkept isunk
!rm d541[4-6].mat

load d5417
cds=coords;ddt=dt;mdp=mdep;np=npts;q=qual;tmp=temp;tm=time;
t=typ;s=src;bt=bath;isu=isunk;
load d3417
coords=[cds;coords];dt=[ddt;dt];time=[tm;time];
temp=[tmp;temp];npts=[np;npts];qual=[q;qual];mdep=[mdp;mdep];
typ=strvcat(t,typ);src=strvcat(s,src);bath=[bt;bath];isunk=[isu;isunk];
save d3417 bath src typ coords dt time temp mdep npts qual depth nkept isunk
!rm d5417.mat

ii=num2str([0:17]');ii(1:10,1)='0';
cds=[];ddt=[];mdp=[];np=[];q=[];tmp=[];tm=[];isu=[];
t=[];s=[];bt=[];
for i=1:4
  if exist(['d55',ii(i,:),'.mat'])
    load(['d55',ii(i,:)])
    len(i)=length(mdep);
    cds=[cds;coords];ddt=[ddt;dt];tm=[tm;time];
    tmp=[tmp;temp];np=[np;npts];q=[q;qual];mdp=[mdp;mdep];
    t=strvcat(t,typ);s=strvcat(s,src);bt=[bt;bath];isu=[isu;isunk];
  end
end
coords=cds;dt=ddt;mdep=mdp;npts=np;qual=q;temp=tmp;time=tm;
typ=t;src=s;bath=bt;isunk=isu;
save d5500 bath src typ coords dt time temp mdep npts qual depth nkept isunk
!rm d550[1-3].mat

ii=num2str([0:17]');ii(1:10,1)='0';
cds=[];ddt=[];mdp=[];np=[];q=[];tmp=[];tm=[]; isu=[];
t=[];s=[];bt=[];
for i=5:8
  if exist(['d55',ii(i,:),'.mat'])
    load(['d55',ii(i,:)])
    len(i)=length(mdep);
    cds=[cds;coords];ddt=[ddt;dt];tm=[tm;time];
    tmp=[tmp;temp];np=[np;npts];q=[q;qual];mdp=[mdp;mdep];
    t=strvcat(t,typ);s=strvcat(s,src);bt=[bt;bath];isu=[isu;isunk];
  end
end
coords=cds;dt=ddt;mdep=mdp;npts=np;qual=q;temp=tmp;time=tm;
typ=t;src=s;bath=bt;isunk=isu;
ii=find(temp(:,56)>2);jj=find(temp(:,56)<=2);
cds=coords(ii,:);ddt=dt(ii,:);mdp=mdep(ii);np=npts(ii);
q=qual(ii);tmp=temp(ii,:);tm=time(ii,:);isu=isunk(ii);
t=typ(ii,:);s=src(ii,:);bt=bath(ii);
coords=coords(jj,:);dt=dt(jj,:);mdep=mdep(jj);isunk=isunk(jj);
npts=npts(jj);qual=qual(jj);temp=temp(jj,:);time=time(jj,:);
typ=typ(jj,:);src=src(jj,:);bath=bath(jj);
save d5504 bath src typ coords dt time temp mdep npts qual depth nkept isunk
coords=cds;dt=ddt;mdep=mdp;npts=np;qual=q;temp=tmp;time=tm;
typ=t;src=s;bath=bt;isunk=isu;
save d5507 bath src typ coords dt time temp mdep npts qual depth nkept isunk
!rm d550[5-6].mat

ii=num2str([0:17]');ii(1:10,1)='0';
cds=[];ddt=[];mdp=[];np=[];q=[];tmp=[];tm=[];isu=[];
t=[];s=[];bt=[];
for i=9:18
  if exist(['d55',ii(i,:),'.mat'])
    load(['d55',ii(i,:)])
    len(i)=length(mdep);
    cds=[cds;coords];ddt=[ddt;dt];tm=[tm;time];
    tmp=[tmp;temp];np=[np;npts];q=[q;qual];mdp=[mdp;mdep];
    t=strvcat(t,typ);s=strvcat(s,src);bt=[bt;bath];isu=[isu;isunk];
  end
end
coords=cds;dt=ddt;mdep=mdp;npts=np;qual=q;temp=tmp;time=tm;
typ=t;src=s;bath=bt;isunk=isu;
ii=find(temp(:,175)>5);jj=find(temp(:,175)<=5);
cds=coords(ii,:);ddt=dt(ii,:);mdp=mdep(ii);np=npts(ii);
q=qual(ii);tmp=temp(ii,:);tm=time(ii,:);isu=isunk(ii);
t=typ(ii,:);s=src(ii,:);bt=bath(ii);
coords=coords(jj,:);dt=dt(jj,:);mdep=mdep(jj);isunk=isunk(jj);
npts=npts(jj);qual=qual(jj);temp=temp(jj,:);time=time(jj,:);
typ=typ(jj,:);src=src(jj,:);bath=bath(jj);
save d5517 bath src typ coords dt time temp mdep npts qual depth nkept isunk
coords=cds;dt=ddt;mdep=mdp;npts=np;qual=q;temp=tmp;time=tm;
typ=t;src=s;bath=bt;isunk=isu;
save d5508 bath src typ coords dt time temp mdep npts qual depth nkept isunk
!rm d5509.mat d551[0-6].mat

ii=num2str([0:17]');ii(1:10,1)='0';
cds=[];ddt=[];mdp=[];np=[];q=[];tmp=[];tm=[];isu=[];
t=[];s=[];bt=[];
for i=1:7
  if exist(['d56',ii(i,:),'.mat'])
    load(['d56',ii(i,:)])
    len(i)=length(mdep);
    cds=[cds;coords];ddt=[ddt;dt];tm=[tm;time];
    tmp=[tmp;temp];np=[np;npts];q=[q;qual];mdp=[mdp;mdep];
    t=strvcat(t,typ);s=strvcat(s,src);bt=[bt;bath];isu=[isu;isunk];
  end
end
coords=cds;dt=ddt;mdep=mdp;npts=np;qual=q;temp=tmp;time=tm;
typ=t;src=s;bath=bt;isunk=isu;
save d5600 bath src typ coords dt time temp mdep npts qual depth nkept isunk
!rm d560[1-6].mat

ii=num2str([0:17]');ii(1:10,1)='0';
cds=[];ddt=[];mdp=[];np=[];q=[];tmp=[];tm=[];isu=[];
t=[];s=[];bt=[];
for i=8:18
  if exist(['d56',ii(i,:),'.mat'])
    load(['d56',ii(i,:)])
    len(i)=length(mdep);
    cds=[cds;coords];ddt=[ddt;dt];tm=[tm;time];
    tmp=[tmp;temp];np=[np;npts];q=[q;qual];mdp=[mdp;mdep];
    t=strvcat(t,typ);s=strvcat(s,src);bt=[bt;bath];isu=[isu;isunk];
  end
end
coords=cds;dt=ddt;mdep=mdp;npts=np;qual=q;temp=tmp;time=tm;
typ=t;src=s;bath=bt;isunk=isu;
save d5607 bath src typ coords dt time temp mdep npts qual depth nkept isunk
!rm d560[8-9].mat d561[0-7].mat

load d7007
cds=coords;ddt=dt;mdp=mdep;np=npts;q=qual;tmp=temp;tm=time;
t=typ;s=src;bt=bath;isu=isunk;
jj=find(coords(:,2)<9);ii=find(coords(:,2)>9);
cds=coords(ii,:);ddt=dt(ii,:);mdp=mdep(ii);np=npts(ii);
q=qual(ii);tmp=temp(ii,:);tm=time(ii,:);isu=isunk(ii);
t=typ(ii,:);s=src(ii,:);bt=bath(ii);
coords=coords(jj,:);dt=dt(jj,:);mdep=mdep(jj);isunk=isunk(jj);
npts=npts(jj);qual=qual(jj);temp=temp(jj,:);time=time(jj,:);
typ=typ(jj,:);src=src(jj,:);bath=bath(jj);
save d7007 bath src typ coords dt time temp mdep npts qual depth nkept isunk
load d7107
coords=[cds;coords];dt=[ddt;dt];time=[tm;time];
temp=[tmp;temp];npts=[np;npts];qual=[q;qual];mdep=[mdp;mdep];
typ=strvcat(t,typ);src=strvcat(s,src);bath=[bt;bath];isunk=[isu;isunk];
save d7107 bath src typ coords dt time temp mdep npts qual depth nkept isunk

load d7007
cds=coords;ddt=dt;mdp=mdep;np=npts;q=qual;tmp=temp;tm=time;
t=typ;s=src;bt=bath;isu=isunk;
load d7008
coords=[cds;coords];dt=[ddt;dt];time=[tm;time];
temp=[tmp;temp];npts=[np;npts];qual=[q;qual];mdep=[mdp;mdep];
typ=strvcat(t,typ);src=strvcat(s,src);bath=[bt;bath];isunk=[isu;isunk];
save d7008 bath src typ coords dt time temp mdep npts qual depth nkept isunk
!rm d7007.mat

load d7008
cds=coords;ddt=dt;mdp=mdep;np=npts;q=qual;tmp=temp;tm=time;
t=typ;s=src;bt=bath;isu=isunk;
ii=find(coords(:,2)>9&coords(:,1)>-83);
jj=find(~(coords(:,2)>9&coords(:,1)>-83));
cds=coords(ii,:);ddt=dt(ii,:);mdp=mdep(ii);np=npts(ii);
q=qual(ii);tmp=temp(ii,:);tm=time(ii,:);isu=isu(ii);
t=typ(ii,:);s=src(ii,:);bt=bath(ii);
coords=coords(jj,:);dt=dt(jj,:);mdep=mdep(jj);isunk=isunk(jj);
npts=npts(jj);qual=qual(jj);temp=temp(jj,:);time=time(jj,:);
typ=typ(jj,:);src=src(jj,:);bath=bath(jj);
save d7008 bath src typ coords dt time temp mdep npts qual depth nkept isunk
load d7108
coords=[cds;coords];dt=[ddt;dt];time=[tm;time];
temp=[tmp;temp];npts=[np;npts];qual=[q;qual];mdep=[mdp;mdep];
typ=strvcat(t,typ);src=strvcat(s,src);bath=[bt;bath];isunk=[isu;isunk];
save d7108 bath src typ coords dt time temp mdep npts qual depth nkept isunk

load d7108
cds=coords;ddt=dt;mdp=mdep;np=npts;q=qual;tmp=temp;tm=time;
t=typ;s=src;bt=bath;isu=isunk;
ii=find(coords(:,2)<14&coords(:,1)<-85);
jj=find(~(coords(:,2)<14&coords(:,1)<-85));
cds=coords(ii,:);ddt=dt(ii,:);mdp=mdep(ii);np=npts(ii);
q=qual(ii);tmp=temp(ii,:);tm=time(ii,:);isu=isunk(ii);
t=typ(ii,:);s=src(ii,:);bt=bath(ii);
coords=coords(jj,:);dt=dt(jj,:);mdep=mdep(jj);isunk=isunk(jj);
npts=npts(jj);qual=qual(jj);temp=temp(jj,:);time=time(jj,:);
typ=typ(jj,:);src=src(jj,:);bath=bath(jj);
save d7108 bath src typ coords dt time temp mdep npts qual depth nkept isunk
load d7008
coords=[cds;coords];dt=[ddt;dt];time=[tm;time];
temp=[tmp;temp];npts=[np;npts];qual=[q;qual];mdep=[mdp;mdep];
typ=strvcat(t,typ);src=strvcat(s,src);bath=[bt;bath];isunk=[isu;isunk];
save d7008 bath src typ coords dt time temp mdep npts qual depth nkept isunk

load d7109
cds=coords;ddt=dt;mdp=mdep;np=npts;q=qual;tmp=temp;tm=time;
t=typ;s=src;bt=bath;isu=isunk;
jj=find(coords(:,2)<17);ii=find(coords(:,2)>17);
cds=coords(ii,:);ddt=dt(ii,:);mdp=mdep(ii);np=npts(ii);
q=qual(ii);tmp=temp(ii,:);tm=time(ii,:);isu=isunk(ii);
t=typ(ii,:);s=src(ii,:);bt=bath(ii);
coords=coords(jj,:);dt=dt(jj,:);mdep=mdep(jj);isunk=isunk(jj);
npts=npts(jj);qual=qual(jj);temp=temp(jj,:);time=time(jj,:);
typ=typ(jj,:);src=src(jj,:);bath=bath(jj);
save d7109 bath src typ coords dt time temp mdep npts qual depth nkept isunk
load d7209
coords=[cds;coords];dt=[ddt;dt];time=[tm;time];
temp=[tmp;temp];npts=[np;npts];qual=[q;qual];mdep=[mdp;mdep];
typ=strvcat(t,typ);src=strvcat(s,src);bath=[bt;bath];isunk=[isu;isunk];
save d7209 bath src typ coords dt time temp mdep npts qual depth nkept isunk

load d7210
cds=coords;ddt=dt;mdp=mdep;np=npts;q=qual;tmp=temp;tm=time;
t=typ;s=src;bt=bath;isu=isunk;
load d7211
coords=[cds;coords];dt=[ddt;dt];time=[tm;time];
temp=[tmp;temp];npts=[np;npts];qual=[q;qual];mdep=[mdp;mdep];
typ=strvcat(t,typ);src=strvcat(s,src);bath=[bt;bath];isunk=[isu;isunk];
save d7211 bath src typ coords dt time temp mdep npts qual depth nkept isunk
!rm d7210.mat

load d7308
cds=coords;ddt=dt;mdp=mdep;np=npts;q=qual;tmp=temp;tm=time;
t=typ;s=src;bt=bath;isu=isunk;
load d7307
coords=[cds;coords];dt=[ddt;dt];time=[tm;time];
temp=[tmp;temp];npts=[np;npts];qual=[q;qual];mdep=[mdp;mdep];
typ=strvcat(t,typ);src=strvcat(s,src);bath=[bt;bath];isunk=[isu;isunk];
save d7307 bath src typ coords dt time temp mdep npts qual depth nkept isunk
!rm d7308.mat

load d7505
cds=coords;ddt=dt;mdp=mdep;np=npts;q=qual;tmp=temp;tm=time;
t=typ;s=src;bt=bath;isu=isunk;
load d7506
coords=[cds;coords];dt=[ddt;dt];time=[tm;time];
temp=[tmp;temp];npts=[np;npts];qual=[q;qual];mdep=[mdp;mdep];
typ=strvcat(t,typ);src=strvcat(s,src);bath=[bt;bath];isunk=[isu;isunk];
save d7505 bath src typ coords dt time temp mdep npts qual depth nkept isunk
!rm d7506.mat

load d7512
cds=coords;ddt=dt;mdp=mdep;np=npts;q=qual;tmp=temp;tm=time;
t=typ;s=src;bt=bath;isu=isunk;
load d7513
coords=[cds;coords];dt=[ddt;dt];time=[tm;time];
temp=[tmp;temp];npts=[np;npts];qual=[q;qual];mdep=[mdp;mdep];
typ=strvcat(t,typ);src=strvcat(s,src);bath=[bt;bath];isunk=[isu;isunk];
save d7513 bath src typ coords dt time temp mdep npts qual depth nkept isunk
!rm d7512.mat

load d7605
cds=coords;ddt=dt;mdp=mdep;np=npts;q=qual;tmp=temp;tm=time;
t=typ;s=src;bt=bath;isu=isunk;
load d7606
coords=[cds;coords];dt=[ddt;dt];time=[tm;time];
temp=[tmp;temp];npts=[np;npts];qual=[q;qual];mdep=[mdp;mdep];
typ=strvcat(t,typ);src=strvcat(s,src);bath=[bt;bath];isunk=[isu;isunk];
save d7605 bath src typ coords dt time temp mdep npts qual depth nkept isunk
!rm d7606.mat

ii=num2str([0:17]');ii(1:10,1)='0';
cds=[];ddt=[];mdp=[];np=[];q=[];tmp=[];tm=[];isu=[];
t=[];s=[];bt=[];
for i=6:18
  if exist(['d77',ii(i,:),'.mat'])
    load(['d77',ii(i,:)])
    len(i)=length(mdep);
    cds=[cds;coords];ddt=[ddt;dt];tm=[tm;time];
    tmp=[tmp;temp];np=[np;npts];q=[q;qual];mdp=[mdp;mdep];
    t=strvcat(t,typ);s=strvcat(s,src);bt=[bt;bath];isu=[isu;isunk];
  end
end
coords=cds;dt=ddt;mdep=mdp;npts=np;qual=q;temp=tmp;time=tm;
typ=t;src=s;bath=bt;isunk=isu;
save d7705 bath src typ coords dt time temp mdep npts qual depth nkept isunk
!rm d770[6-9].mat d771[0-7].mat

ii=num2str([0:17]');ii(1:10,1)='0';
cds=[];ddt=[];mdp=[];np=[];q=[];tmp=[];tm=[];isu=[];
t=[];s=[];bt=[];
for i=1:18
  if exist(['d78',ii(i,:),'.mat'])
    load(['d78',ii(i,:)])
    len(i)=length(mdep);
    cds=[cds;coords];ddt=[ddt;dt];tm=[tm;time];
    tmp=[tmp;temp];np=[np;npts];q=[q;qual];mdp=[mdp;mdep];
    t=strvcat(t,typ);s=strvcat(s,src);bt=[bt;bath];isu=[isu;isunk];
  end
end
coords=cds;dt=ddt;mdep=mdp;npts=np;qual=q;temp=tmp;time=tm;
typ=t;src=s;bath=bt;isunk=isu;
save d7800 bath src typ coords dt time temp mdep npts qual depth nkept isunk
!rm d780[1-9].mat d781[0-7].mat

d=sdir('d*.mat');clear len
for i=1:length(d)
  poo=whos('-file',d(i).name,'mdep');
  %bah=whos('-file',d(i).name,'isunk');
  len(i)=poo.size(1);
  %len2(i)=bah.size(1);
end

ii=find(len<2);
for i=1:length(ii)
  eval(['!rm ',d(ii(i)).name])
end
len(ii)=[];d(ii)=[];%len2(ii)=[];

cd '../../'