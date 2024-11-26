cd /Users/johnlyman/data/Globalhc/WOD05

d=sdir('XBTO1997_conv.mat');
depth=[0:2:840];
% toss float data out of WOD05 since we get it from Argo
dn=strvcat(d(:).name);


% load XBT correction
load wod_bias_info tg cor code len
cor(len<200)=NaN;ii=find(~isnan(nanmean(cor,2)));
cor=cor(ii,:);len=len(ii,:);code=code(ii,:);
cor(isnan(cor))=0;

% load WOCE Climatology so we can interpolate Mooring data
load ../WOCE/wghc lon lat dpt S T
[yy,xx,zz]=meshgrid(lat,lon,dpt);pp=sw_pres(zz,yy);
T=sw_temp(S,T,pp,pp*0);clear S pp xx yy zz
lon=[lon(end/2+1:end)-360,lon(1:end/2)];
T=[T(end/2+1:end,:,:);T(1:end/2,:,:)];
lon=[lon(end)-360,lon,lon(1)+360];
T=[T(end,:,:);T;T(1,:,:)];
ii=find(dpt<=1000);dpt=dpt(ii);T=T(:,:,ii);

tic,warning off
length(d)
for i=1:length(d)  % main loop over all WOD files
%for i=50:53
  eval(['load ',d(i).name])
d(i).name
  npmax=length(time);
 if npmax>0
  
  

  % interpolate profiles onto depth grid
  tmp=NaN*zeros(nprof,length(depth));
tmp_norm=tmp;
  npts=zeros(nprof,1);mdep=npts;
  % for moorings, interpolate climatology
  if strcmp('MR',d(i).name(1:2))
    tc=NaN*zeros(nprof,length(dpt));
    for j=1:length(dpt)
      tc(:,j)=interp2(lat,lon,T(:,:,j),coords(:,2),coords(:,1));
    end
  end
  for j=1:nprof

    % find appropiate depth correction factor
    mdp=max(temp{j}(:,1));
    pt=0;xcor=0;
    if     ptype(j)==2&mdp>300&mdp<430,pt=2.1;
    elseif ptype(j)==2&mdp>=430&mdp<480;pt=2.2;
    elseif ptype(j)==2&mdp>=480&mdp<950;pt=2.3;
    elseif ptype(j)==2&mdp>=950&mdp<2000;pt=2.4;
    else pt=ptype(j);end
    if pinfo(j,1)==2&(mdp>=2000|mdp<=300),pt=0;end
    ii=find(pt==code(:,1)&fflag(j)==code(:,2));
    jj=find(dt(j,1)==tg-.5);
    if ~isempty(ii)&~isempty(jj), xcor=cor(ii,jj);end   

    % pick out good data points, sort and interpolate
    ii=find( (temp{j}(:,4)==0|temp{j}(:,4)==2) ...
	& temp{j}(:,3)~=1 & temp{j}(:,2)<35 &  ...
        temp{j}(:,2)>=-3 & ...
	~isnan(temp{j}(:,1)+temp{j}(:,2)) );
    [poo,ll]=unique(temp{j}(ii,1));ii=ii(ll);clear ll poo
    if length(ii)>2&max(temp{j}(ii,1))>=350&~isnan(xcor)
     if ~strcmp('MR',d(i).name(1:2))
      tmp(j,:)=interp1(temp{j}(ii,1)*(1+xcor),temp{j}(ii,2),depth);
     else
      tclim=interp1(dpt,tc(j,:),temp{j}(ii,1));
      tmp(j,:)=interp1(temp{j}(ii,1),temp{j}(ii,2)-tclim,depth) + ...
	interp1(dpt,tc(j,:),depth);
     end
      tmp_norm(j,:)=interp1(temp{j}(ii,1),temp{j}(ii,2),depth);
      npts(j)=length(temp{j}(ii,1)<900);
      mdep(j)=max(temp{j}(ii,1));
    end
  end
  cds=coords;ddt=dt;ql=qual;tm=time;mdp=mdep;np=npts;ff=fflag;pt=ptype;
  type=repmat(d(i).name(1:2),[nprof 1]);ocl=oclnum;pin=pinfo;
  % some impromptu QC:  the apbt's bottom out, so cut off profile bottoms
  if strcmp(d(i).name(1:2),'AP')
    for j=1:length(tm),
      ii=find(tmp(j,:)==min(tmp(j,:)));
      tmp(j,ii)=NaN;
      tmp_norm(j,ii)=NaN;
    end
  end
  %mdp=ones(length(tm),1)*depth;mdp(isnan(tmp))=NaN;mdp=max(mdp')';
  clear ii jj nprof

  %%%%%%%%%%%%%%%%%%%%%%%%%%
  %%% loop to extract and save data into WOD squares (w????.mat files)

  % calculate appropriate square for given lat and lon
  clear wnum
  iii=find(cds(:,1)<=0&cds(:,2)>0);
  jjj=find(cds(:,1)>0 &cds(:,2)>0);
  lll=find(cds(:,1)<=0&cds(:,2)<=0);
  nnn=find(cds(:,1)>0 &cds(:,2)<=0);
  wnum(iii)=abs(ceil(cds(iii,1)/10))+100*(ceil(cds(iii,2)/10)-1)+7000;
  wnum(jjj)=ceil(cds(jjj,1)/10)-1+100*(ceil(cds(jjj,2)/10)-1)+1000;
  wnum(lll)=abs(ceil(cds(lll,1)/10))+100*abs(ceil(cds(lll,2)/10))+5000;
  wnum(nnn)=ceil(cds(nnn,1)/10)-1+100*abs(ceil(cds(nnn,2)/10))+3000;

  w=unique(wnum);
  ii=length(wnum);

    % create ?? variables and save them to ??.mat
   
    temp=tmp;
 %   temp_norm=[temp_norm;tmp_norm(ii,:)];
    coords=cds;
    dt=ddt;
    typ=type;
    time=tm;
    qual=zeros(ii,1);
    fflag=ff;
    ptype=pt;
    oclnum=ocl;
    pinfo=pin;

    mdep=mdp;
    npts=np;
    wodpkeep=length(mdep);
    src=repmat('W',[length(mdep) 1]);
    
  
  end %if cds
  t=toc;disp([d(i).name,'  ',num2str(t)])
end
t=t/3600;
save -ascii runtime.txt t

%% compute bath

load /Users/johnlyman/data/Globalhc/topo/topo.mat
 if ~isempty(temp)
  ii=find(coords(:,1)<-180 | coords(:,1)>180 | ...
	coords(:,2)<-90 | coords(:,2)>90);

  if length(ii)<size(temp,1)
    iii=find(lon>min(coords(:,1))-.1 & lon<max(coords(:,1))+.1);
    jjj=find(lat>min(coords(:,2))-.1 & lat<max(coords(:,2))+.1);
    bath=interp2(lat(jjj),lon(iii),-topo(iii,jjj),coords(:,2),coords(:,1));
  else
    bath=ones(size(qual));
  end
 end
clear topo lon lat

%% fixtop


 for j=13:-1:1
    ii=find(isnan(temp(:,j)));temp(ii,j)=temp(ii,j+1);
    nlen(j)=length(ii);
  end

  ii=find(isnan(sum(temp(:,1:176)')'));

  oldlen(i)=size(temp,1);

  coords(ii,:)=[];dt(ii,:)=[];mdep(ii)=[];qual(ii)=[];
  temp(ii,:)=[];time(ii,:)=[];npts(ii)=[];bath(ii)=[];
  src(ii,:)=[];typ(ii,:)=[];
  
  % get rid of profiles on land
  
  
  ii=find(bath<10);
   coords(ii,:)=[];dt(ii,:)=[];mdep(ii)=[];qual(ii)=[];
  temp(ii,:)=[];time(ii,:)=[];npts(ii)=[];bath(ii)=[];
  src(ii,:)=[];typ(ii,:)=[];
  
  
  
  %% fixbottom
%loop through new data files and fix short profiles


% load Levitus high-res climatology (mean?) so we can subtract it
load /Users/johnlyman/data/Globalhc/Levitus/tlevhr lon lat dep levtemp
levtemp=[levtemp(end-40:end,:,:);levtemp;levtemp(1:41,:,:)];
lon=[lon(end-40:end)-360,lon,lon(1:41)+360];
ii=find(abs(lon)<180);
lt=mean(reshape(levtemp(ii,:,:),[length(ii)*length(lat),length(dep)]));
lt=reshape(lt,[1 1 length(dep)]);
levtemp(:,length(lat)+1,:)=repmat(lt,[length(lon),1,1]);
lat=[lat,90];

tic,
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
kk=find(~isnan(sum(tanom')'));
  nn=find(depth<=600);
 ind=randperm(length(kk));ist=floor(length(kk)/2);
  bind=kk(ind(1:ist)); gind=kk(ind((ist+1):end));

  % test error vs. cutoff depth
  cdp=[350:25:800];
 
  for i=1:length(cdp)
    ll=find(depth<=cdp(i));
    poo=tanom(gind,ll)'*tanom(gind,ll);
    al=tanom(gind,:)'*tanom(gind,ll)*inv(poo+.1*diag(diag(poo)));clear poo
    ttest=tanom(bind,ll)*al';
    % calculate a quick and dirty HC to get error
    hc=trapz(depth,tanom(bind,:)')';
    hctest=trapz(depth,ttest')';
    hcerr(i)=nanstd(hc-hctest)/nanstd(hc);
   
  end

  mdp=ones(size(tanom,1),1)*depth;mdp(isnan(tanom))=NaN;mdp=max(mdp')';
  ii=find(bath<mdp);mdp(ii)=depth(floor(bath(ii)/mean(diff(depth)))+1);
  % fractional error in each profile from doing extension
  exterr=interp1([cdp,max(mdp)+1],[hcerr,0],mdp);  
  
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

  
  
  %% compute heat
  % load Levitus high-res climatology so we can subtract it (mean?)
load /Users/johnlyman/data/Globalhc/Levitus/slevhr_700 lon lat dep levsal
levsal=[levsal(end-40:end,:,:);levsal;levsal(1:41,:,:)];
lon=[-190.125:.25:190.125];
levsal(:,end+1,:)=levsal(:,end,:);lat(end+1)=lat(end)+mean(diff(lat));

% loop through e.mat files and make heat content
ht=[];


  % interpolate salinity climatology onto temp profiles
  ii=find(lon<max(coords(:,1))+.3&lon>min(coords(:,1)-.3));
  jj=find(lat<max(coords(:,2))+.3&lat>min(coords(:,2)-.3));
  sal=zeros(size(temp,1),length(dep));
  for l=1:length(dep)
  sal(:,l)=interp2(lon(ii),lat(jj),levsal(ii,jj,l)',...
        coords(:,1),coords(:,2));
  end
  sal=interp1(dep,sal',depth,'pchp')';

  % calculate HC to 750m or to bottom, whichever is shallower
  ii=find(bath<700);jj=find(bath>=700);
  p=sw_pres(depth'*ones(1,length(coords(:,2))),coords(:,2)')';
  heat=temp(:,1);
  % do profiles in deep water
  heat(jj)=trapz(depth', ...
        sw_dens(sal(jj,:)',temp(jj,:)',p(jj,:)').* ...
        sw_cp(sal(jj,:)',temp(jj,:)',p(jj,:)').*...
        sw_ptmp(sal(jj,:)',temp(jj,:)',p(jj,:)',0) )';
  % profiles in water < 750m deep
  for l=1:length(ii)
    ll=find(depth<=bath(ii(l))&~isnan(temp(ii(l),:)));
    heat(ii(l))=trapz(depth(ll)', ...
        sw_dens(sal(ii(l),ll)',temp(ii(l),ll)',p(ii(l),ll)').* ...
        sw_cp(sal(ii(l),ll)',temp(ii(l),ll)',p(ii(l),ll)').*...
        sw_ptmp(sal(ii(l),ll)',temp(ii(l),ll)',p(ii(l),ll)',0) )';
  end
  
  ht=[ht;heat];

tm(tm<0|tm>24)=NaN;tm(isnan(tm))=12;
dt=ddt;

  


