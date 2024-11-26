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
load /Volumes/Data/Globalhc/HC/wmo_bad_apex
 
bad_apex=[apex_insuff_surface_press' apex_negitive' apex_no_tech' apex_unknown'];

load /Users/johnlyman/data/Globalhc/Floats/Argo/CORIOLIS/apex_luanch_before_2003
bad_apex=unique([bad_apex' ;apex_2003]);
%%





% load float data

eval(['load ', file_path, file_name]);




% get rid of the bad apex floats from a table
%%

bad_apex_pos=find(ismember(id,bad_apex) ==1);
 
data(bad_apex_pos,:)=[];
date(bad_apex_pos,:)=[];

id(bad_apex_pos)=[];
coords(bad_apex_pos,:)=[];
mdep(bad_apex_pos)=[];
npts(bad_apex_pos)=[];
time(bad_apex_pos,:)=[];
fpkeep=fpkeep-length(bad_apex_pos);
qual(bad_apex_pos)=[];
press_mis_flag(bad_apex_pos)=[]; 
dac_centre(bad_apex_pos,:)=[];
wmo_inst(bad_apex_pos)=[];
cycle(bad_apex_pos)=[]; 

%% load in Ice Teatherd Profilers (ITPs) to get high latitudes.
load('/Volumes/Data/ITP/profiles_itp.mat')

coords_itp=[prof_lon,prof_lat];
date_itp_num=datenum(prof_dyr,0,0);
date_itp=datevec(date_itp_num);
date_itp=date_itp(:,1:3);


nitps=length(prof_dyr);
data_itp=cell(nitps,3);
mdep_itp=ones(nitps,1);
npts_itp=ones(nitps,1);

for iitps=1:nitps
    
   junk=profiles{iitps,:};
   
   data_itp{iitps,3}=junk(:,1);
   data_itp{iitps,1}=junk(:,2);
   data_itp{iitps,2}=junk(:,3);
   mdep_itp(iitps)=max(junk(:,1));
   npts_itp(iitps)=length(find(isfinite(junk(:,1)+junk(:,2)+junk(:,3))));
end

% tac the ITPs on to the end of the argo profiles 

data=[data;data_itp];
coords=[coords;coords_itp];
date=[date;date_itp];
id=[id ; ones(nitps,1)];
mdep=[mdep;mdep_itp];
npts=[npts;npts_itp];
time=[time;ones(nitps,3)*0];
fpkeep=fpkeep+nitps;
qual=[qual,repmat('D',[1 nitps])];
press_mis_flag=[press_mis_flag,ones(1,nitps)*0];
dac_centre=[dac_centre;repmat('IT',[nitps 1])];
wmo_inst=[wmo_inst;ones(nitps,1)*0];
cycle=[cycle';ones(nitps,1)*0];
%%
% get rid of the coords
%%

bad_apex_pos=find(isfinite(coords(:,2))==0);
 
data(bad_apex_pos,:)=[];
date(bad_apex_pos,:)=[];

id(bad_apex_pos)=[];
coords(bad_apex_pos,:)=[];
mdep(bad_apex_pos)=[];
npts(bad_apex_pos)=[];
time(bad_apex_pos,:)=[];
fpkeep=fpkeep-length(bad_apex_pos);
qual(bad_apex_pos)=[];
press_mis_flag(bad_apex_pos)=[]; 
dac_centre(bad_apex_pos,:)=[];
wmo_inst(bad_apex_pos)=[];
cycle(bad_apex_pos)=[]; 
%%

 bad_wod=[1105,1107,1213,1214,1300,1301,1302,1303,1312,1313,...
     1413,3000,3006,3010,3011,3013, 3211,3311,3504,3512,...
     5000,5012,5015,5100,5116,5203,5213,5214,5217,5314,5317, 5408,5500,...
    7116,7117,7207,7307,7313,7317,7401,7401,7417,7500,7503,7505,7600,7601];
%bad_wod=[1313,3110,3112,7417,7500];
%bad_wod=3110
%bad_surface=[1300,3006,3205,3206,3207,3312,3317,3504,5100,5103,5115,...
%  5116,5117,5200,5203,5212,5213,5214,5215,5217,5300,5317,7003,7008,...
%  7104,7116,7117,7206,7212,7217,7303,7314,7315,7400,7514];
%bad_deep_xbt=[3010,3011,3013,3110,3112,3211,3215,3414,5314];
%bad_kinad=[1010,1104,1107,1108,1771,1203,1301,1302,1403,1601,1701,3103,3203,...
% 3311,3512,5000,7101,7207,7417,7500]
% extra_bad=[7500,7505,7600,7601]
% bad_shallow=[1006,1014,1106,1112,1117,1203,1205,1214,1303,1517,3010,3011,3013,3101,3201,3205,...
%   3206,3207,3360,3311];
% bad_shallow_extra=[1010,3105,3106,3114];
%%
length(bad_wod)
float_coords=coords;
float_temp=data(:,1);
float_depth=data(:,3);

clear id coords mdep npts tim fpkeep qual dac_center wmo_inst cycle data

%%
load /Volumes/Data/xbt/Lyman/Globalhc/WOD05/bad_xbt_oclnums_plus   bad_coords bad_dt bad_time bad_oclnum

bad_total=[bad_coords,bad_dt,bad_time];

%for wod_wum=bad_wod
for i=57:length(d)
   load(d(i).name,'temp','coords','dt','time','bath','blon','blat', ...
 	'typ','src','depth','mdep');
'in'
d(i).name
% ['e',num2str(wod_wum),'.mat']
% load(['e',num2str(wod_wum),'.mat'],'temp','coords','dt','time','bath','blon','blat', ...
% 	'typ','src','depth');
vec_total=[coords,dt,time];
bad_vec=find(ismember(vec_total,bad_total,'rows')==1);

max_lon=max(coords(:,1));
min_lon=min(coords(:,1));

max_lat=max(coords(:,2));
min_lat=min(coords(:,2));


good_floats=find((float_coords(:,1) >= min_lon) &(float_coords(:,1) <= max_lon) &...
    (float_coords(:,2) >= min_lat) &(float_coords(:,2) <= max_lat));


figure(1)
shallow=find(mdep<=300);
deep=find(mdep>300);
if ~isempty(shallow)
    plot(temp(shallow,:),-1.*depth,'g')
end
hold on
if ~isempty(deep)
    plot(temp(deep,:),-1.*depth,'k')
end

n_floats=length(good_floats)
for ifloat=1:n_floats
    plot(float_temp{good_floats(ifloat)},-1.*float_depth{good_floats(ifloat)},'r')
end

if ~isempty(bad_vec)
plot(temp(bad_vec,:),-1.*depth,'g')
end

hold off

figure(2)
plot(coords(:,1),coords(:,2),'k.')
plot_coasts_black

figure(3)
plot(float_coords(good_floats,1),float_coords(good_floats,2),'r.')
plot_coasts_black


figure(4)
plot(float_coords(good_floats,1),float_coords(good_floats,2),'r.')
plot_coasts_black
'out'
pause
end
