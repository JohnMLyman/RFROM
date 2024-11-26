% getprofiles.m - matlab script to read WOCE float profiles
% into matlab format
% 12/30/02

% need to read in:  coords, date, time, max depth, npts, qual
%			and temperature
tic
cd 'D:\CORIOLIS\'
% get directory info
d1=sdir('*ocean');
% n_press is the number of spaces 
 

n_press=2;
depth=[1:n_press].*NaN;

% initialize variables
fptot=0;cds=[];dt=[];mdp=[];
np=[];tmp=[];tm=[];bdt=[];bbas=[];ind=[];sal=[];qual=[];id=[];fpress=[];date_qc=[];pos_qc=[];

  
% loop through directories, one per Ocean
for i=1:length(d1)

  d2=dir([d1(i).name,'/*/*/*.nc']);

  % loop through profiles - 1 netcdf file per day
  % PLATFORM_NUMBER is the id number of the float
  % DATA_MODE is a character that is D,R or A for delayed, realtime or
  %     automatic
  
  for j=1:length(d2)
       eval(['clear PRES TEMP ', ...
	'JULD LATITUDE LONGITUDE DEPH PSAL PLATFORM_NUMBER DATA_MODE ', ...
    'PRES_ADJUSTED ','TEMP_ADJUSTED ','PSAL_ADJUSTED ', ...
    'PRES_QC ','TEMP_QC ','PSAL_QC ', ...
    'PRES_ADJUSTED_QC ','TEMP_ADJUSTED_QC ','PSAL_ADJUSTED_QC ',...
    'DATA_CENTRE ', 'WMO_INST_TYPE ','CYCLE_NUMBER ',...
    'POSITION_QC','JULD_QC']);

%     ncload([d1(i).name,'/',d2(j).name],'PRES','TEMP', ...
% 	'JULD','LATITUDE','LONGITUDE','DEPH','PSAL','PLATFORM_NUMBER','DATA_MODE', ...
%     'PRES_ADJUSTED','TEMP_ADJUSTED','PSAL_ADJUSTED', ...
%     'PRES_QC','TEMP_QC','PSAL_QC', ...
%     'PRES_ADJUSTED_QC','TEMP_ADJUSTED_QC','PSAL_ADJUSTED_QC');
%nc_getall([d1(i).name,'/',d2(j).name])
   file_name_nc=[d2(j).folder,'/',d2(j).name];
      %read_netcdf_getall_getprofiles
      %%
     [TEMP]=read_netcdf_getall_getprofiles(file_name_nc,'TEMP');
    [PRES]=read_netcdf_getall_getprofiles(file_name_nc,'PRES');
    [JULD]=read_netcdf_getall_getprofiles(file_name_nc,'JULD');
    [LATITUDE]=read_netcdf_getall_getprofiles(file_name_nc,'LATITUDE');
    [LONGITUDE]=read_netcdf_getall_getprofiles(file_name_nc,'LONGITUDE');
     [DEPH]=read_netcdf_getall_getprofiles(file_name_nc,'DEPH');
    [PSAL]=read_netcdf_getall_getprofiles(file_name_nc,'PSAL');
    [PLATFORM_NUMBER]=read_netcdf_getall_getprofiles(file_name_nc,'PLATFORM_NUMBER');
    [DATA_MODE]=read_netcdf_getall_getprofiles(file_name_nc,'DATA_MODE');
    [PRES_ADJUSTED]=read_netcdf_getall_getprofiles(file_name_nc,'PRES_ADJUSTED');
    [TEMP_ADJUSTED]=read_netcdf_getall_getprofiles(file_name_nc,'TEMP_ADJUSTED');
    [PSAL_ADJUSTED]=read_netcdf_getall_getprofiles(file_name_nc,'PSAL_ADJUSTED');
    [PRES_QC]=read_netcdf_getall_getprofiles(file_name_nc,'PRES_QC');
    [TEMP_QC]=read_netcdf_getall_getprofiles(file_name_nc,'TEMP_QC');
    [PSAL_QC]=read_netcdf_getall_getprofiles(file_name_nc,'PSAL_QC');
    [PRES_ADJUSTED_QC]=read_netcdf_getall_getprofiles(file_name_nc,'PRES_ADJUSTED_QC');
    [TEMP_ADJUSTED_QC]=read_netcdf_getall_getprofiles(file_name_nc,'TEMP_ADJUSTED_QC');
    [PSAL_ADJUSTED_QC]=read_netcdf_getall_getprofiles(file_name_nc,'PSAL_ADJUSTED_QC');
    [DATA_CENTRE]=read_netcdf_getall_getprofiles(file_name_nc,'DATA_CENTRE');
    [WMO_INST_TYPE]=read_netcdf_getall_getprofiles(file_name_nc,'WMO_INST_TYPE');
    [CYCLE_NUMBER]=read_netcdf_getall_getprofiles(file_name_nc,'CYCLE_NUMBER');
    [POSITION_QC]=read_netcdf_getall_getprofiles(file_name_nc,'POSITION_QC');
    [JULD_QC]=read_netcdf_getall_getprofiles(file_name_nc,'JULD_QC');     
      if  ~isempty('TEMP')
%     ncload([d1(i).name,'/',d2(j).name],'PRES','TEMP', ...
% 	'JULD','LATITUDE','LONGITUDE','DEPH','PSAL','PLATFORM_NUMBER','DATA_MODE', ...
%     'PRES_ADJUSTED','TEMP_ADJUSTED','PSAL_ADJUSTED', ...
%     'PRES_QC','TEMP_QC','PSAL_QC', ...
%     'PRES_ADJUSTED_QC','TEMP_ADJUSTED_QC','PSAL_ADJUSTED_QC',...
%     'DATA_CENTRE', 'WMO_INST_TYPE','CYCLE_NUMBER');
disp([d2(j).folder,'/',d2(j).name])
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
    
    if isempty(PRES),PRES=DEPH;end
    
    PSAL(PSAL==99999)=NaN;
    TEMP(TEMP==99999)=NaN;
    TEMP(TEMP<-3)=NaN;
    TEMP(TEMP>=35)=NaN;
    PSAL(PSAL>=40)=NaN;
    PSAL(PSAL<0)=NaN;
    PRES(PRES==99999)=NaN;
    
% find the bad points according to the QC

% bad_temp=find(~(TEMP_QC =='0' | TEMP_QC=='1' | TEMP_QC=='2'));
% bad_sal=find(~(PSAL_QC =='0' | PSAL_QC=='1' | PSAL_QC=='2'));
% bad_pres=find(~(PRES_QC =='0' | PRES_QC=='1' | PRES_QC=='2'));


% PRES(bad_pres)=NaN;
% PSAL(bad_sal)=NaN;
% TEMP(bad_temp)=NaN;
    
    PSAL_ADJUSTED(PSAL_ADJUSTED==99999)=NaN;
    TEMP_ADJUSTED(TEMP_ADJUSTED==99999)=NaN;
    TEMP_ADJUSTED(TEMP_ADJUSTED<-3)=NaN;
    TEMP_ADJUSTED(TEMP_ADJUSTED>=35)=NaN;
    PSAL_ADJUSTED(PSAL_ADJUSTED>=40)=NaN;
    PSAL_ADJUSTED(PSAL_ADJUSTED<0)=NaN;
    PRES_ADJUSTED(PRES_ADJUSTED==99999)=NaN;
    fptot=fptot+size(TEMP,1);
% find the bad 
    
% bad_temp=find(~(TEMP_ADJUSTED_QC =='0' | TEMP_ADJUSTED_QC=='1' | TEMP_ADJUSTED_QC=='2'));
% bad_sal=find(~(PSAL_ADJUSTED_QC =='0' | PSAL_ADJUSTED_QC=='1' | PSAL_ADJUSTED_QC=='2'));  
% bad_pres=find(~(PRES_ADJUSTED_QC =='0' | PRES_ADJUSTED_QC=='1' | PRES_ADJUSTED_QC=='2'));  


    
% repalce the real time with ADJUSTED data where the ADJUSTED data is
% good...
good_sal_ad=find(isfinite(PSAL_ADJUSTED) == 1);
good_temp_ad=find(isfinite(TEMP_ADJUSTED) == 1);
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

bad_temp=find(~( TEMP_QC=='2' | TEMP_QC=='1' | TEMP_QC=='0' ));
bad_sal=find(~( PSAL_QC=='2' | PSAL_QC=='1' | PSAL_QC=='0' ));
bad_pres=find(~( PRES_QC=='2' | PRES_QC=='1' | PRES_QC=='0' ));
 
 
PRES(bad_pres)=NaN;
PSAL(bad_sal)=NaN;
TEMP(bad_temp)=NaN;


    if size(PSAL,2)>2 & ~isnan(LONGITUDE+LATITUDE);
      cds=[cds;[LONGITUDE',LATITUDE']];
      qual=strvcat(qual',DATA_MODE')';
      
        % THere are 16 missing position QC flags this is a fix
       if length(str2num(POSITION_QC(:)))==length(str2num(JULD_QC(:)))
           pos_qc=[pos_qc;str2num(POSITION_QC(:))];
       else
           pos_qc=[pos_qc;str2num(JULD_QC(:))*NaN];
       end
      
      
      date_qc=[date_qc;str2num(JULD_QC(:))];
      id=strvcat(id,PLATFORM_NUMBER);
      poo=datevec(datenum(1950,1,1)+JULD);
      dt=[dt;poo(:,1:3)];
      tm=[tm;poo(:,4:6)];
      np=[np;nansum(~isnan(TEMP),2)];
      mdp=[mdp;max(PRES,[],2)];
      tpp=NaN*ones(size(TEMP,1),n_press);
      spp=NaN*ones(size(PSAL,1),n_press);
      ppp=NaN*ones(size(PRES,1),n_press);
      % not quite sure why he is doing this?
      
      for k=1:size(TEMP,1) 
        ii=find(~isnan(TEMP(k,:)+PRES(k,:)+PSAL(k,:)));
        num_good_press=length(ii);
        
       
        num_pof=length(TEMP(k,:));
       
        if length(ii) > 2 & ( max(PRES(k,:))-min(PRES(k,:)) )>1
          if (length(unique(sign(diff(PRES(k,ii)))))==1) & (length(unique(PRES(k,ii))) > 1);
	    [junk,pos_min]=min(PRES(k,ii));
       pos_surface=ii(pos_min);
              tpp(k,1:2)=TEMP(k,pos_surface:pos_surface+1);
        spp(k,1:2)=PSAL(k,pos_surface:pos_surface+1);
        ppp(k,1:2)=PRES(k,pos_surface:pos_surface+1);
          else
	    ind=[ind;k];bdt=[bdt;poo(k,1:3)];bbas=strvcat(bbas,d1(i).name);
	  end
        end
      end
      tmp=[tmp;tpp];sal=[sal;spp];fpress=[fpress;ppp];    
    end
 
  end  % of loop through netcdf files
  end
 % clear PRES TEMP JULD LATITUDE LONGITUDE poo ii

  disp([d1(i).name,'   ',num2str(toc)])
   
end % of loop through directories

% get rid of profiles with too few points
bdind=find(isnan(nansum(tmp,2)) | isnan(nansum(sal,2)));
cds(bdind,:)=[];dt(bdind,:)=[];np(bdind)=[];
mdp(bdind)=[];tmp(bdind,:)=[];tm(bdind,:)=[];
 id(bdind,:)=[];sal(bdind,:)=[];fpress(bdind,:)=[];qual(bdind)=[];pos_qc(bdind)=[]; date_qc(bdind)=[];

 
 good_ind=find((pos_qc==1 | pos_qc==5| pos_qc==8)&(date_qc==1 | date_qc==1|date_qc==5|date_qc==8));

date_qc=date_qc(good_ind);
pos_qc=pos_qc(good_ind);
cds=cds(good_ind,:);
dt=dt(good_ind,:);
np=np(good_ind,:);
mdp=mdp(good_ind);


tmp=tmp(good_ind,:);
sal=sal(good_ind,:);
fpress=fpress(good_ind,:);


tm=tm(good_ind,:);
id= id(good_ind);
qual=qual(good_ind);


coords=cds;date=dt;time=tm;npts=np;mdep=mdp;temp=tmp;
fpkeep=length(npts);
 
lato=cds(:,2);
lono=cds(:,1);

lono(lono>180)=lono(lono>180)-360;

 %sal  = gsw_SA_from_SP(sal2,fpress,lono,lato);
 
 


save pfloat_sal_density_density_surface coords date mdep npts temp time fptot fpkeep bdt bbas depth ind sal id qual fpress
% % clear all

%putfloats_density_surface