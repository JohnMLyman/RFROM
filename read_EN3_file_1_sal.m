function [coords,dt,time,nprof,qual,fflag,ptype,pinf,ocl,temp]=read_EN3_file_1(ifile,path)

% test read a netcdf file using new matlab rotines...

%path='/Volumes/Data/EN3/ishiiXBTMBT/';
%path='/Volumes/Data/OHCA_curves/EN3_v2a_NoCWT_LevitusXBTcorr';
%path='/Volumes/Data/OHCA_curves/EN3_v2a_NoCWT_WijffelsTable2XBTCorr';
%path='/Volumes/Data/OHCA_curves/EN3_v2a_WijffelsTable1';

%file='EN3_v1d_WijffelsXBTcorr_2004.01.nc';


old_path=cd(path);


nprof=2000000;
% nprof=20000;
 
       %data=ones(;
       data=cell(nprof,3);
       cds=ones(nprof,2)*NaN;
       dt=ones(nprof,3)*NaN;
       ind=0;
       test=0;


file_list=sdir('*.nc');
'ifile'
%nfile=length(file_list)

   for ifile=ifile:ifile
       %for ifile=1:22+3
        ifile
        junk_name=file_list(ifile).name
%        file_suf=junk_name(40:48);
 
        ncid=netcdf.open(file_list(ifile).name,'NC_NOWRITE');
        
        [ndims,nvars,ngatts,unlimdimid] = netcdf.inq(ncid);

    
% read dimensions

        for idims=0:ndims-1
    
            [dimname, dimlen] = netcdf.inqDim(ncid,idims);
        end



%         %for ivars=0:nvars-1
%             for ivars=[0:43,nvars-2,nvars-1]
% 
% ivars
%             [varname, xtype, dimids, numatts] = netcdf.inqVar(ncid,ivars);
%     
%             eval([varname,'= netcdf.getVar(ncid,ivars);']);
%     
%         end
%         
        

        
        varid_depth = netcdf.inqVarID(ncid,'DEPH_CORRECTED');
        varid_lat = netcdf.inqVarID(ncid,'LATITUDE');
        varid_lon = netcdf.inqVarID(ncid,'LONGITUDE');
        varid_jud = netcdf.inqVarID(ncid,'JULD');
        varid_temp = netcdf.inqVarID(ncid,'TEMP');
        varid_sal = netcdf.inqVarID(ncid,'PSAL_CORRECTED');
        varid_pos_qc = netcdf.inqVarID(ncid,'POSITION_QC');
        varid_temp_qc=netcdf.inqVarID(ncid,'PROFILE_POTM_QC');
        varid_sal_qc=netcdf.inqVarID(ncid,'PROFILE_PSAL_QC');
        varid_inst_type=netcdf.inqVarID(ncid,'INST_REFERENCE');
        varid_proj_name=netcdf.inqVarID(ncid,'PROJECT_NAME');
        varid_temp_qc2=netcdf.inqVarID(ncid,'POTM_CORRECTED_QC');
        varid_sal_qc2=netcdf.inqVarID(ncid,'PSAL_CORRECTED_QC');


        % varid_xbt = netcdf.inqVarID(ncid,'ISHII_CORRECTION_FACTOR');
       % varid_xbt = netcdf.inqVarID(ncid,'WIJFFELS_TABLE2_DEPTH_CORRECTION');
        % varid_xbt = netcdf.inqVarID(ncid,'LEVITUS_TEMP_CORRECTION');
       % varid_xbt = netcdf.inqVarID(ncid2,'WIJFFELS_DEPTH_CORRECTION');


        
        depth_junk=netcdf.getVar(ncid,varid_depth);
        lat_junk=netcdf.getVar(ncid,varid_lat);
        lon_junk=netcdf.getVar(ncid,varid_lon);
        jud_junk=netcdf.getVar(ncid,varid_jud);
        temp_junk=netcdf.getVar(ncid,varid_temp);
        sal_junk=netcdf.getVar(ncid,varid_sal);
        pos_qc_junk=netcdf.getVar(ncid,varid_pos_qc);
        temp_qc_junk=netcdf.getVar(ncid,varid_temp_qc);
        sal_qc_junk=netcdf.getVar(ncid,varid_sal_qc);
        
        inst_type=netcdf.getVar(ncid,varid_inst_type);
        proj_name=netcdf.getVar(ncid,varid_proj_name);
        temp_qc2_junk=netcdf.getVar(ncid,varid_temp_qc2);
        sal_qc2_junk=netcdf.getVar(ncid,varid_sal_qc2);
        
       % xbt_junk=netcdf.getVar(ncid,varid_xbt);
        inst_type=floor(str2num(inst_type')./10000);
        p1=proj_name(1,:)';
         p2=proj_name(2,:)';
%         
%         type_junk=cellstr(type_junk(1:7,:)');
%          
%         %pick out the files that you are interested in
%         a={'GTSPPXB','WOD05XB'};
%         good1=strcmp(type_junk,a{1});
%         good2=strcmp(type_junk,a{2});
%         good=find(good1+good2);

%  Only take good profiles that are not in GTSSP (p1~='G') not from Argo
%  (p2~='R') and not in WOD05 and marked as a profiling pfloat inst_type~= 9

        good=find(sal_qc_junk == '1'  &temp_qc_junk == '1' & ...
            pos_qc_junk =='1' &  inst_type~= 9 & p2~='R' & p1~='G');

        %subsect data for only the profiles that we are interested in
        ngood=length(good);
        if ~isempty(good)
            
            
           
            
           ind=[1:ngood]+max(ind);
           depth_junk=depth_junk(:,good);
           lat_junk=lat_junk(good);
           lon_junk=lon_junk(good);
           jud_junk=jud_junk(good);
           temp_junk=temp_junk(:,good);
           sal_junk=sal_junk(:,good);
           temp_qc2_junk=temp_qc2_junk(:,good);
           sal_qc2_junk=sal_qc2_junk(:,good);
           
           bad= temp_junk == 99999 |temp_qc2_junk =='4'...
               | sal_junk == 99999 |sal_qc2_junk =='4';
           temp_junk(bad)=NaN;
           sal_junk(bad)=NaN;
           
           [year,month,day]=jd2date(jud_junk+date2jd(1950));
           dt(ind,1)=year;
           dt(ind,2)=month;
           dt(ind,3)=day;
           
           cds(ind,1)=lon_junk;
           cds(ind,2)=lat_junk;
           
           
            for iprof=1:ngood
%               ndep=length(temp_junk(:,iprof));
              data{ind(iprof),1}=depth_junk(:,iprof);
              data{ind(iprof),2}=temp_junk(:,iprof) ;
              data{ind(iprof),3}=sal_junk(:,iprof) ;
              
           end
            clear temp_junk sal_junk depth_junk pos_qc_junk temp_qc_junk ...
                sal_qc_junk lat_junk lon_junk 
            
        end
    nprof-max(ind)
        netcdf.close(ncid)
       
    end



ngood=max(ind);
nprof=ngood;
dt=dt(1:ngood,:);
coords=cds(1:ngood,:);
temp=data(1:ngood,:);

clear data
%put into the standard form of WOD05

for i=1:nprof; n=length(temp{i,1});temp{i,1}=[temp{i,1} temp{i,2} temp{i,3} ones(n,1)*0];end;
temp=temp(:,1);

% set all times to 0 hours
 time=ones(ngood,1)*0;
 % set all qc to good 0 good 1 bad
 qual=ones(ngood,1)*0;
 % set instrument code to unknown xbt page 103 WOD05readme.pdf
 ptype=ones(ngood,1)*2;
 %set probe type to xbt 2 and recorder to 2 (SIPPICAN MK2A/SSQ-61) page 89
 % and 90 WOD05readme.pdf
 pinf=ones(ngood,2)*2;
 
 %set the ocl identifier to the index number
 ocl=[1:ngood];
 
 
 
 %set depth fix flagg to 0; no fix necessary page 94  WOD05readme.pdf
 
 
 fflag=ones(ngood,1)*0;


cd(old_path)

