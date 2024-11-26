cd '/Volumes/Data Backup/xbt/Lyman/Globalhc/WOD05/'

load wod_bias_info tg cor code len
cor(len<200)=NaN;ii=find(~isnan(nanmean(cor,2)));
cor=cor(ii,:);len=len(ii,:);code=code(ii,:);
cor(isnan(cor))=0;
load bad_xbt_oclnums bad_oclnum

d=sdir('XBTO*_conv.mat');

nfiles=length(d);

nbad=length(bad_oclnum);
bad_coords=nans(nbad,2);
bad_dt=nans(nbad,3);
bad_time=nans(nbad,1);
sp=1;

for ifile=1:nfiles
  
    
   % load xbt data 
   d(ifile).name
   eval(['load ',d(ifile).name])
  
   bad=find(ismember(oclnum,bad_oclnum)==1);
   if ~isempty(bad)
   np=length(bad)+sp-1;
   bad_coords(sp:np,:)=coords(bad,:);
   bad_dt(sp:np,:)=dt(bad,:);
   bad_time(sp:np)=time(bad);
   sp=np+1;
   end
end

cd '/Volumes/Data/xbt/Lyman/Globalhc/WOD05/'


save bad_xbt_oclnums_plus   bad_coords bad_dt bad_time bad_oclnum