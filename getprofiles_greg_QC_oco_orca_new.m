function getprofiles_greg_QC_oco_orca_new(OcoSetUp)
file_path_prof=OcoSetUp.file_path_prof;

file_path_in=OcoSetUp.file_path_in;
file_name_argo=OcoSetUp.file_name_argo;



% getprofiles.m - matlab script to read WOCE float profiles

% into matlab format
% 12/30/02

% need to read in:  coords, date, time, max depth, npts, qual
%			and temperature
tic




% cd /Volumes/ThunderBay/Data/Globalhc/Floats/Argo/CORIOLIS

% get directory info
% d1=sdir('*ocean');
cd([file_path_in,'/CORIOLIS'])

% n_press is the number of spaces 
 d1=dir([file_path_in,'/CORIOLIS/*/*/*/*.nc']);

n_press=2;
depth=[1:n_press].*NaN;

% initialize variables
fptot=0;cds=[];dt=[];mdp=[];
np=[];tm=[];bdt=[];bbas=[];ind=[];qual=[];id=[];
wmo_inst=[];dac_centre=[];press_mis_flag=[];data=[];cycle=[];date_qc=[];pos_qc=[];

% loop through directories, one per Ocean
nprof=length(d1)

parfor ifile=1:nprof
    if mod(ifile,1000) == 0
        disp(ifile./nprof)
    end
  % loop through profiles - 1 netcdf file per day
  % PLATFORM_NUMBER is the id number of the float
  % DATA_MODE is a character that is D,R or A for delayed, realtime or
  %     automatic
  
  
%       eval(['clear PRES TEMP ', ...
% 	'JULD LATITUDE LONGITUDE DEPH PSAL PLATFORM_NUMBER DATA_MODE ', ...
%     'PRES_ADJUSTED ','TEMP_ADJUSTED ','PSAL_ADJUSTED ', ...
%     'PRES_QC ','TEMP_QC ','PSAL_QC ', ...
%     'PRES_ADJUSTED_QC ','TEMP_ADJUSTED_QC ','PSAL_ADJUSTED_QC ',...
%     'DATA_CENTRE ', 'WMO_INST_TYPE ','CYCLE_NUMBER ',...
%     'POSITION_QC','JULD_QC']);
%       file_name_nc=[d1(i).name,'/',d2(j).name];
      file_name_nc=[d1(ifile).folder,'\',d1(ifile).name];

      %read_netcdf_getall_getprofiles
      %%
     [TEMP]=read_netcdf_getall_getprofiles_tuna(file_name_nc,'TEMP');
    [PRES]=read_netcdf_getall_getprofiles_tuna(file_name_nc,'PRES');
    [JULD]=read_netcdf_getall_getprofiles_tuna(file_name_nc,'JULD');
    [LATITUDE]=read_netcdf_getall_getprofiles_tuna(file_name_nc,'LATITUDE');
    [LONGITUDE]=read_netcdf_getall_getprofiles_tuna(file_name_nc,'LONGITUDE');
     [DEPH]=read_netcdf_getall_getprofiles_tuna(file_name_nc,'DEPH');
    [PSAL]=read_netcdf_getall_getprofiles_tuna(file_name_nc,'PSAL');
    [PLATFORM_NUMBER]=read_netcdf_getall_getprofiles_tuna(file_name_nc,'PLATFORM_NUMBER');
    [DATA_MODE]=read_netcdf_getall_getprofiles_tuna(file_name_nc,'DATA_MODE');
    [PRES_ADJUSTED]=read_netcdf_getall_getprofiles_tuna(file_name_nc,'PRES_ADJUSTED');
    [TEMP_ADJUSTED]=read_netcdf_getall_getprofiles_tuna(file_name_nc,'TEMP_ADJUSTED');
    [PSAL_ADJUSTED]=read_netcdf_getall_getprofiles_tuna(file_name_nc,'PSAL_ADJUSTED');
    [PRES_QC]=read_netcdf_getall_getprofiles_tuna(file_name_nc,'PRES_QC');
    [TEMP_QC]=read_netcdf_getall_getprofiles_tuna(file_name_nc,'TEMP_QC');
    [PSAL_QC]=read_netcdf_getall_getprofiles_tuna(file_name_nc,'PSAL_QC');
    [PRES_ADJUSTED_QC]=read_netcdf_getall_getprofiles_tuna(file_name_nc,'PRES_ADJUSTED_QC');
    [TEMP_ADJUSTED_QC]=read_netcdf_getall_getprofiles_tuna(file_name_nc,'TEMP_ADJUSTED_QC');
    [PSAL_ADJUSTED_QC]=read_netcdf_getall_getprofiles_tuna(file_name_nc,'PSAL_ADJUSTED_QC');
    [DATA_CENTRE]=read_netcdf_getall_getprofiles_tuna(file_name_nc,'DATA_CENTRE');
    [WMO_INST_TYPE]=read_netcdf_getall_getprofiles_tuna(file_name_nc,'WMO_INST_TYPE');
    [CYCLE_NUMBER]=read_netcdf_getall_getprofiles_tuna(file_name_nc,'CYCLE_NUMBER');
    [POSITION_QC]=read_netcdf_getall_getprofiles_tuna(file_name_nc,'POSITION_QC');
    [JULD_QC]=read_netcdf_getall_getprofiles_tuna(file_name_nc,'JULD_QC');
    %%
      if ~isempty(TEMP)
%     ncload([d1(i).name,'/',d2(j).name],'PRES','TEMP', ...
% 	'JULD','LATITUDE','LONGITUDE','DEPH','PSAL','PLATFORM_NUMBER','DATA_MODE', ...
%     'PRES_ADJUSTED','TEMP_ADJUSTED','PSAL_ADJUSTED', ...
%     'PRES_QC','TEMP_QC','PSAL_QC', ...
%     'PRES_ADJUSTED_QC','TEMP_ADJUSTED_QC','PSAL_ADJUSTED_QC',...
%     'DATA_CENTRE', 'WMO_INST_TYPE','CYCLE_NUMBER');
	press_missing=0;
    if isempty(PRES)
	PRES=DEPH;
        press_missing=1;
	
    end
    if isempty('PSAL')
        PSAL=PRES*NaN;
       
    end
    if isempty('PSAL_QC')
        PSAL_QC=PSAL*NaN;
       
    end
    if isempty('PSAL_ADJUSTED')
        PSAL_ADJUSTED=TEMP_ADJUSTED*NaN;
       
    end
    if isempty('PSAL_ADJUSTED_QC')
        PSAL_ADJUSTED_QC=TEMP_ADJUSTED*NaN;
       
    end
    PSAL(PSAL==99999)=NaN;
    TEMP(TEMP==99999)=NaN;
    TEMP(TEMP<-3)=NaN;
    TEMP(TEMP>=35)=NaN;
    PSAL(PSAL>=40)=NaN;
    PSAL(PSAL<0)=NaN;
    PRES(PRES==99999)=NaN;
   
     s_dac=size(DATA_CENTRE);
     n_prof=length(LONGITUDE);
     if s_dac(2) < 2
         DATA_CENTRE(:,2)='9';
     end
    if s_dac(1)~= n_prof
        DATA_CENTRE=num2str(ones(n_prof,1)*9);
        DATA_CENTRE(:,2)='9';
        DATA_CENTRE(:,1)='9';
    end



 % change WMO_INST_type to a number and get rid of blank spaces with 9

    missing_inst_type=find(strcmp(cellstr(WMO_INST_TYPE),'')==1);

    if length(missing_inst_type) ~= 0
        WMO_INST_TYPE(missing_inst_type,:)='9';
    end

    WMO_INST_TYPE=str2num(WMO_INST_TYPE);
    PLATFORM_NUMBER=str2num(PLATFORM_NUMBER);


    if length(WMO_INST_TYPE) ~= n_prof
        WMO_INST_TYPE=ones(n_prof,1)*NaN;
    end


    if length(PLATFORM_NUMBER) ~= n_prof
        PLATFORM_NUMBER=ones(n_prof,1)*NaN;
    end



% find the bad points according to the QC
% 0 = no qc
% 1 = good data
% 2 = probably good data

  PSAL_ADJUSTED(PSAL_ADJUSTED==99999)=NaN;
  TEMP_ADJUSTED(TEMP_ADJUSTED==99999)=NaN;
  TEMP_ADJUSTED(TEMP_ADJUSTED<-3)=NaN;
  TEMP_ADJUSTED(TEMP_ADJUSTED>=35)=NaN;
  PSAL_ADJUSTED(PSAL_ADJUSTED>=40)=NaN;
  PSAL_ADJUSTED(PSAL_ADJUSTED<0)=NaN;
  PRES_ADJUSTED(PRES_ADJUSTED==99999)=NaN;
  fptot=fptot+size(TEMP,1);

    
% repalce the real time with ADJUSTED data where the ADJUSTED data is
% good...
good_sal_ad=find(isfinite(PSAL_ADJUSTED) == 1 );
good_temp_ad=find(isfinite(TEMP_ADJUSTED) == 1 );
good_pres_ad=find(isfinite(PRES_ADJUSTED) == 1);


    
if ~(length(good_sal_ad)==1)
    PSAL(good_sal_ad)=PSAL_ADJUSTED(good_sal_ad);
    PSAL_QC(good_sal_ad)=PSAL_ADJUSTED_QC(good_sal_ad);
end
if ~(length(good_temp_ad)==1)
    TEMP(good_temp_ad)=TEMP_ADJUSTED(good_temp_ad);
    TEMP_QC(good_temp_ad)=TEMP_ADJUSTED_QC(good_temp_ad);
end

if ~(length(good_pres_ad)==1)
    PRES(good_pres_ad)=PRES_ADJUSTED(good_pres_ad);
    PRES_QC(good_pres_ad)=PRES_ADJUSTED_QC(good_pres_ad);

end


% get rid of the bad data...

bad_temp=find(~( TEMP_QC=='1' ));
bad_sal=find(~( PSAL_QC=='1' ));
bad_pres=find(~( PRES_QC=='1' ));
 
PRES(bad_pres)=NaN;
PSAL(bad_sal)=NaN;
TEMP(bad_temp)=NaN;


    if size(PSAL,2)>2 & ~isnan(LONGITUDE+LATITUDE);
     cds=[cds ;[LONGITUDE',LATITUDE']];
      qual=[qual,DATA_MODE];
      
      % THere are 16 missing position QC flags this is a fix
       if length(str2num(POSITION_QC(:)))==length(str2num(JULD_QC(:)))
           pos_qc=[pos_qc;str2num(POSITION_QC(:))];
       else
           pos_qc=[pos_qc;str2num(JULD_QC(:))*NaN];
       end
      
      date_qc=[date_qc;str2num(JULD_QC(:))];
      id=[id;PLATFORM_NUMBER];
      cycle=[cycle CYCLE_NUMBER];
      press_mis_flag=[press_mis_flag,ones(1,size(TEMP,1))*press_missing];
      
      wmo_inst=[wmo_inst;WMO_INST_TYPE];
      dac_centre=[dac_centre;DATA_CENTRE];

      poo=datevec(datenum(1950,1,1)+JULD);
      dt=[dt;poo(:,1:3)];
      tm=[tm;poo(:,4:6)];
      np=[np;nansum(~isnan(TEMP),2)];
      mdp=[mdp;max(PRES,[],2)];
      %tpp=NaN*ones(size(TEMP,1),n_press);
      %spp=NaN*ones(size(PSAL,1),n_press);
      %ppp=NaN*ones(size(PRES,1),n_press);
      data_fill=cell(size(TEMP,1),3);
   
      % not quite sure why he is doing this?
      
      for k=1:size(TEMP,1) 
	data_fill{k,1}=single(NaN*(ones(1,2)));
	data_fill{k,2}=single(NaN*(ones(1,2)));
	data_fill{k,3}=single(NaN*(ones(1,2)));
        ii=find(~isnan(TEMP(k,:)+PRES(k,:)+PSAL(k,:)));
        num_good_press=length(ii);
        
       
        num_pof=length(TEMP(k,:));
        
       
        if length(ii) > 2 & ( max(PRES(k,:))-min(PRES(k,:)) )>1  
          if (length(unique(sign(diff(PRES(k,ii)))))==1) & (length(unique(PRES(k,ii))) > 1);
               data_fill{k,1}=single(TEMP(k,ii) );
               data_fill{k,2}=single( PSAL(k,ii));
               data_fill{k,3}=single( PRES(k,ii));
	      
          else
	    ind=[ind;k];bdt=[bdt;poo(k,1:3)];bbas=strvcat(bbas,d1(ifile).name);
	  end
        end
	
      end
      %tmp=[tmp;tpp];sal=[sal;spp];fpress=[fpress;ppp];    
      data=[data ;data_fill];
      
    end
 
  end  % of loop through netcdf files
 
 % clear PRES TEMP JULD LATITUDE LONGITUDE poo ii

%   disp([d1(ifile).folder,'   ',num2str(toc)])
   
end % of loop through directories

% get rid of profiles with too few points

nprof=length(wmo_inst);
good_prof=ones(1,nprof)*NaN;

for igood=1:nprof
     good_prof(igood)=nansum(data{igood,1}) +nansum(data{igood,2});    
end
good_ind=find(~isnan(good_prof));

date_qc=date_qc(good_ind);
pos_qc=pos_qc(good_ind);
cds=cds(good_ind,:);
dt=dt(good_ind,:);
np=np(good_ind,:);
mdp=mdp(good_ind);
data=data(good_ind,:);
cycle=cycle(good_ind);
tm=tm(good_ind,:);
id= id(good_ind);
qual=qual(good_ind);
wmo_inst=wmo_inst(good_ind);
dac_centre=dac_centre(good_ind,:);
press_mis_flag=press_mis_flag(good_ind);


good_ind=find((pos_qc==1 | pos_qc==5| pos_qc==8)&(date_qc==1 | date_qc==1|date_qc==5|date_qc==8));

date_qc=date_qc(good_ind);
pos_qc=pos_qc(good_ind);
cds=cds(good_ind,:);
dt=dt(good_ind,:);
np=np(good_ind,:);
mdp=mdp(good_ind);
data=data(good_ind,:);
cycle=cycle(good_ind);
tm=tm(good_ind,:);
id= id(good_ind);
qual=qual(good_ind);
wmo_inst=wmo_inst(good_ind);
dac_centre=dac_centre(good_ind,:);
press_mis_flag=press_mis_flag(good_ind);

coords=cds;date=dt;time=tm;npts=np;mdep=mdp;
fpkeep=length(npts);
 
clear cds dt np mdp tm i j k tmp 


eval(['save -v7.3 ',file_path_prof,file_name_argo,' coords date mdep npts ',...
    'time fptot fpkeep bdt bbas ind id qual data ' ...
	'press_mis_flag dac_centre wmo_inst cycle pos_qc date_qc'])



