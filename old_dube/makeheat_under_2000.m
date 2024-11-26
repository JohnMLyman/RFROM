
% makeheat.m - matlab script to make heat content for all profiles
% 3/17/03


% get new file names
cd '/Volumes/Data/Globalhc/HC/All_Data'
d=sdir('d*.mat');d=d(1:end);
dd=strvcat(d(:).name);dd=str2num(dd(:,2:5));

% load Levitus high-res climatology so we can subtract it (mean?)
load /Users/johnlyman/data/Globalhc/Levitus/slevhr_700 lon lat dep levsal
levsal=[levsal(end-40:end,:,:);levsal;levsal(1:41,:,:)];
lon=[-190.125:.25:190.125];
levsal(:,end+1,:)=levsal(:,end,:);lat(end+1)=lat(end)+mean(diff(lat));

% loop through e.mat files and make heat content
cds_700=[];ddt_700=[];bt_700=[];ht_700=[];bt_700=[];tm_700=[];mdep_700=[];
cds_1800=[];ddt_1800=[];bt_1800=[];ht_1800=[];bt_1800=[];tm_1800=[];mdep_1800=[];
cds_top=[];ddt_top=[];bt_top=[];ht_top=[];bt_top=[];tm_top=[];mdep_top=[];
for i=1:length(d)
  load(d(i).name,'coords','dt','time','mdep','bath');
  d(i).name
  if length(time) > 1
  good_1800=find(mdep > 1800 & mdep >= bath -250);
  cds_1800=[cds_1800;coords(good_1800,:)];ddt_1800=[ddt_1800;dt(good_1800,:)];tm_1800=[tm_1800;time(good_1800)];bt_1800=[bt_1800;bath(good_1800)];
   mdep_1800=[mdep_1800;mdep(good_1800)];
  
  good_700=find((mdep >= 1800 | mdep >= bath -250) & mdep > 700);
  cds_700=[cds_700;coords(good_700,:)];ddt_700=[ddt_700;dt(good_700,:)];tm_700=[tm_700;time(good_700)];bt_700=[bt_700;bath(good_700)];
  mdep_700=[mdep_700;,mdep(good_700)];
  
  good_top=find((mdep >= 700 | mdep >= bath -250));
  cds_top=[cds_top;coords(good_top,:)];ddt_top=[ddt_top;dt(good_top,:)];tm_top=[tm_top;time(good_top)];bt_top=[bt_top;bath(good_top)];
  mdep_top=[mdep_top;,mdep(good_top)];
  
  end
end

;

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

coords=cds_1800;
ddt=ddt_1800;
tm=tm_1800;
bt=bt_1800;
tm_good=[tm,0*tm,0*tm];
day=datenum([ddt,tm_good])-datenum(1950,1,1);
  yr=(day-datenum(1992,1,1)+datenum(1950,1,1))/365.25+1992;
  
  
htdiff=mdep_1800;
htanom=mdep_1800;
tpx=mdep_1800;

save hdata_under_1800 htdiff tpx yr coords htanom


coords=cds_700;
ddt=ddt_700;
tm=tm_700;
bt=bt_700;
tm_good=[tm,0*tm,0*tm];
day=datenum([ddt,tm_good])-datenum(1950,1,1);
  yr=(day-datenum(1992,1,1)+datenum(1950,1,1))/365.25+1992;
htdiff=mdep_700;
htanom=mdep_700;
tpx=mdep_700;

save hdata_under_700 htdiff tpx yr coords htanom


coords=cds_top;
ddt=ddt_top;
tm=tm_top;
bt=bt_top;
tm_good=[tm,0*tm,0*tm];
day=datenum([ddt,tm_good])-datenum(1950,1,1);
  yr=(day-datenum(1992,1,1)+datenum(1950,1,1))/365.25+1992;

htdiff=mdep_top;
htanom=mdep_top;
tpx=mdep_top;

save hdata_under_top htdiff tpx yr coords htanom 

% nc_idl_save_hdata_gen(['hdata_under_1800']);
% nc_idl_save_hdata_gen(['hdata_under_700']);
% nc_idl_save_hdata_gen(['hdata_under_top']);
