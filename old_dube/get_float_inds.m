% get_float_inds.m - matlab script to load allheat data and pick out ONLY
% argo float data so we can toss it.
% 12/19/05

% read in positions of all float data from f????.mat files
d=sdir('./Floats/f*.mat');
cds=[];ddt=[];tm=[];s=[];
for i=1:length(d)
  load(['./Floats/',d(i).name],'coords','dt','time','src')
  ddt=[ddt;dt];
  cds=[cds;coords];
  tm=[tm;time];
  s=[s;src];
end
% select only the Argo floats
ii=1:length(tm);
ii=find(s(:,1)=='a'|s(:,2)=='a');
%ddt=ddt(ii,:);cds=cds(ii,:);tm=tm(ii,:);

fcds=cds;fdt=ddt;ftm=tm;
fday=datenum([fdt,ftm,ftm*0,ftm*0]);
%clear i cds coords dt time d ddt tm ii s
% the 'f' variables now contain all possible float profile data

% now load allheat.mat and compare these to profiles there that are
% sufficiently 'close'

load allheat
tmp=round([fday*.25,fcds]); 
day=datenum([dt,tm,tm*0,tm*0]);
tpp=round([day*.25,cds]);

% find indicies of all profile within 4 day and 1 of a degree of
% any float profile
ind=find(ismember(tpp,tmp,'rows'));
  
% find indicies of all OTHER profiles
ind2=find(~ismember(tpp,tmp,'rows'));

save float_indicies_april18_2006_2 ind ind2

