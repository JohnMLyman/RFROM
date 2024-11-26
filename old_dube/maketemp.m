function []=maketemp(depth_level)
% depth_level MUST BE A DEPTH TO WHICH TEMPERATURE HAS ALLREADY BEEN
% INTERPOLATED TO! (USALLY 10 METER INCOMENTS FROM THE SURFACE.)


% get new file names
cd './All_Data'
d=sdir('e*.mat');d=d(1:end);
dd=strvcat(d(:).name);dd=str2num(dd(:,2:5));

% load Levitus high-res climatology so we can subtract it (mean?)

% loop through e.mat files and make heat content
cds=[];ddt=[];bt=[];temp_lev=[];wnum=[];tm=[];s=[];t=[];
for i=1:length(d)
  load(d(i).name,'temp','coords','dt','time','bath','blon','blat', ...
	'typ','src','depth');
%  if length(depth)>100
%    depth=depth(1:5:end);
%    temp=temp(:,1:5:end);
%  end
  bln(i,:)=blon;blt(i,:)=blat;
  cds=[cds;coords];ddt=[ddt;dt];bt=[bt;bath];tm=[tm;time];
  t=strvcat(t,typ);s=strvcat(s,src);
  wnum=[wnum;ones(size(bath))*str2num(d(i).name(2:5))];

  pos=find(depth == depth_level);

  
  
  temp_lev=[temp_lev;temp(:,pos)];

  clear temp ii ll sal p coords date bath

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
eval(['save alltemp_',num2str(depth_level),' temp_lev bt cds dt wnum bln blt tm s t'])

