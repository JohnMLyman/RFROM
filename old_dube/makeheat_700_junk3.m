
% makeheat.m - matlab script to make heat content for all profiles
% 3/17/03
% get new file names
cd '/Volumes/Data/Globalhc/HC/All_Data/qc'
d=sdir('e*.mat');d=d(1:end);
dd=strvcat(d(:).name);dd=str2num(dd(:,2:5));

% load Levitus high-res climatology so we can subtract it (mean?)
load /Users/johnlyman/data/Globalhc/Levitus/slevhr_700 lon lat dep levsal
levsal=[levsal(end-40:end,:,:);levsal;levsal(1:41,:,:)];
lon=[-190.125:.25:190.125];
levsal(:,end+1,:)=levsal(:,end,:);lat(end+1)=lat(end)+mean(diff(lat));

% loop through e.mat files and make heat content
cds=[];ddt=[];bt=[];ht=[];wnum=[];tm=[];s=[];t=[];
tic,for i=1:length(d)
  load(d(i).name,'temp','coords','dt','time','bath','blon','blat', ...
	'typ','src','depth');


% make the depth profile to 700m

bad=find(depth > 700);

temp(:,bad)=[];
depth(bad)=[];

%  if length(depth)>100
%    depth=depth(1:5:end);
%    temp=temp(:,1:5:end);
%  end
  bln(i,:)=blon;blt(i,:)=blat;
  cds=[cds;coords];ddt=[ddt;dt];bt=[bt;bath];tm=[tm;time];
  t=strvcat(t,typ);s=strvcat(s,src);
  wnum=[wnum;ones(size(bath))*str2num(d(i).name(2:5))];

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
  clear temp ii ll sal p coords date bath
  ht=[ht;heat];

  disp([num2str([i toc length(heat)]),'  ',d(i).name])
  clear heat

end

tm(tm<0|tm>24)=NaN;tm(isnan(tm))=12;
dt=ddt;

% get rid of a last set of bad profiles
%ccds=cds;ddt=dt;
%load ../Baddata/wod_09 cds dt
%c=cds;d=dt;
%load ../Baddata/wod_06 cds dt
%c=[cds;c];d=[dt;d];clear cds dt
%cds=ccds;dt=ddt;clear ccds ddt
%poo=[dt,round(cds)];bah=[d,fix(c)];
%ii=find(ismember(poo,bah,'rows'));
%ht(ii)=[];cds(ii,:)=[];dt(ii,:)=[];bt(ii)=[];wnum(ii)=[];tm(ii)=[];
%s(ii,:)=[];t(ii,:)=[];
%clear ii poo bah c d
cd '..'
save allheat_700_junk5 ht bt cds dt wnum bln blt tm s t

