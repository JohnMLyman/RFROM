%This code will linear interpilate Argo floats to a pre-definded depth
%surfaces

% file_path='/Users/lyman/data/Globalhc/Floats/Argo/CORIOLIS/'
% file_path_out='/Users/lyman/data/Globalhc/Floats/Argo/CORIOLIS/depth_grid/'
% file_name='pfloat_sal_greg_june_2008'


% load the id's of the bad apex floats.

% load /Volumes/ThunderBay/Data/Globalhc/HC/wmo_bad_apex
eval(['load ', file_path, 'wmo_bad_apex.mat']);
bad_apex=[apex_insuff_surface_press' apex_negitive' apex_no_tech' apex_unknown'];

% load /Volumes/ThunderBay/Data/Globalhc/Floats/Argo/CORIOLIS/apex_luanch_before_2003
eval(['load ', file_path, 'apex_luanch_before_2003.mat']);

bad_apex=unique([bad_apex' ;apex_2003]);
%%





% load float data

eval(['load ', file_path, file_name_argo]);




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
% load('/Volumes/ThunderBay/Data/ITP/profiles_itp.mat')
eval(['load ', file_path, 'profiles_itp.mat']);
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



%% compute OHC 

np=length(id);

for ilayer=2:length(layer_bounds)

     eval(['heat_',num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer)),'=ones(np,1)*NaN;'])
 end
% 
 %%   
 
 data2=data;
% intripulate WOCE(GK) salinities to argo positions.
%[data]=find_woce_sal(data,coords);
     [data]=find_woce_abssal_new_layers_1_tuna(data,coords,layer_bounds,path_OHCA_data_out);

%  copute heat conetn for the LAYERS !!
for ilayer=2:length(layer_bounds)
%% 
tic
                     
                     eval(['heat_junk=heat_',num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer)),';'])
                     [heat_junk]=compute_depth_heat_depth_range_teos10_2016_tuna(data,heat_junk,coords,layer_bounds(ilayer-1),layer_bounds(ilayer));
                     eval(['heat_',num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer)),'=heat_junk;'])
['heat_',num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer))]
toc
end



eval(['save ',file_path_out,file_name,'_new_layers_heat_oco_100  ',...
    heat_var_name,...
    ' coords date mdep npts time fptot fpkeep bdt bbas ind id qual ',...
	'press_mis_flag dac_centre wmo_inst cycle'])

