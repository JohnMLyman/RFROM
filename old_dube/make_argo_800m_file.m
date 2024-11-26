% this code filters out bad deep xbts.




%% load in Argo float  
file_path='/Users/johnlyman/data/Globalhc/Floats/Argo/CORIOLIS/'
file_path_out='/Users/johnlyman/data/Globalhc/Floats/Argo/CORIOLIS/depth_grid/'
file_name='pfloat_sal_greg_jan_2011_new'
file_path_hdata='/Users/johnlyman/data/Globalhc/HC/'

max_year=2011;
min_year=2004;


load /Volumes/Data/Globalhc/HC/wmo_bad_apex
 
bad_apex=[apex_insuff_surface_press' apex_negitive' apex_no_tech' apex_unknown'];

load /Users/johnlyman/data/Globalhc/Floats/Argo/CORIOLIS/apex_luanch_before_2003
bad_apex=unique([bad_apex' ;apex_2003]);
%





% load float data

eval(['load ', file_path, file_name]);




% get rid of the bad apex floats from a table
%

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

% load in Ice Teatherd Profilers (ITPs) to get high latitudes.
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
%
% get rid of the coords
%

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

%% Find the Argo floats that are in this WMO square

% find the argo floats that you want to at the depth level you want

nprofiles=length(coords(:,1));

argo_temp=nans(nprofiles,1);
argo_coords=nans(nprofiles,2);
argo_dt=nans(nprofiles,3);
tic
for igood= 1:nprofiles
   junk_temp=double(data{igood,1});
   junk_depth=double(data{igood,3});
   if(mod(igood,10000)==0),disp(num2str([igood toc])),end
   if length(junk_temp)>=2
   junk=interp1(junk_depth,junk_temp,depth_level);
   if isfinite(junk)
    argo_temp(igood)=junk;
    argo_coords(igood,:)=coords(igood,:);
    argo_dt(igood,:)=date(igood,:);
   end
   end
end

good=find(isfinite(argo_temp)==1);
argo_temp=argo_temp(good);
argo_coords=argo_coords(good,:);
argo_dt=argo_dt(good,:);

save '/Users/johnlyman/data/Globalhc/argo_800_temp' argo_temp argo_coords argo_dt

