% get new file names
file_path='/Users/johnlyman/data/Globalhc/Floats/Argo/CORIOLIS/'
file_path_out='/Users/johnlyman/data/Globalhc/Floats/Argo/CORIOLIS/depth_grid/'
file_name='pfloat_sal_greg_jan_2011_new'
file_path_hdata='/Users/johnlyman/data/Globalhc/HC/'


max_year=2011;
min_year=2004;




cd '/Volumes/Data/Globalhc/HC/All_Data/qc'
d=sdir('e*.mat');d=d(1:end);
dd=strvcat(d(:).name);dd=str2num(dd(:,2:5));

% load Levitus high-res climatology so we can subtract it (mean?)
load /Users/johnlyman/data/Globalhc/Levitus/slevhr_700 lon lat dep levsal
levsal=[levsal(end-40:end,:,:);levsal;levsal(1:41,:,:)];
lon=[-190.125:.25:190.125];
levsal(:,end+1,:)=levsal(:,end,:);lat(end+1)=lat(end)+mean(diff(lat));
length(d)
%%





% load float data

eval(['load ', file_path, file_name]);

nprofiles=3221508*2;
coords_total=nans(nprofiles,2);
dt_total=nans(nprofiles,3);
time_total=nans(nprofiles,1);
%for wod_wum=bad_wod
ep=0;
for i=1:length(d)
    i
    d(i).name
  load(d(i).name,'temp','coords','dt','time','bath','blon','blat', ...
	'typ','src','depth');
nprof=length(time);
sp=ep+1;
ep=sp+nprof-1;
coords_total(sp:ep,:)=coords;
dt_total(sp:ep,:)=dt;
time_total(sp:ep)=time;

end

good_total=find(isfinite(time_total)==1);
coords_total=coords_total(good_total,:);
dt_total=dt_total(good_total,:);
time_total=time_total(good_total);

save qc_pos coords_total dt_total time_total
