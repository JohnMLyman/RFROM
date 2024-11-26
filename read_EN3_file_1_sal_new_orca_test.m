function [coords,dt,time,nprof,qual,fflag,ptype,pinf,ocl,mdep,wnum,data]=read_EN3_file_1_sal_new_orca_test(file_name)

% test read a netcdf file using new matlab rotines...

%path='/Volumes/Data/EN3/ishiiXBTMBT/';
%path='/Volumes/Data/OHCA_curves/EN3_v2a_NoCWT_LevitusXBTcorr';
%path='/Volumes/Data/OHCA_curves/EN3_v2a_NoCWT_WijffelsTable2XBTCorr';
%path='/Volumes/Data/OHCA_curves/EN3_v2a_WijffelsTable1';

%file='EN3_v1d_WijffelsXBTcorr_2004.01.nc';


% old_path=cd(path);


nprof=2000000;
% nprof=20000;
 
       %data=ones(;
       data=cell(nprof,3);
       cds=ones(nprof,2)*NaN;
       dt=ones(nprof,3)*NaN;
       mdep=nans(nprof,1);
       ind=0;
       test=0;


% file_list=sdir('*.nc');
'ifile'
%nfile=length(file_list)

   
       %for ifile=1:22+3
%         ijfile=ifile;
%         junk_name=file_list(ijfile).name
        junk_name=file_name
%        file_suf=junk_name(40:48);
 
        ncid=netcdf.open(junk_name,'NC_NOWRITE');
        
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
%         varid_depth_qc=netcdf.inqVarID(ncid,'PROFILE_DEPH_QC');

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
        
%         depth_qc_junk=netcdf.getVar(ncid,varid_depth_qc);
        
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

        good=find( sal_qc_junk == '1'& temp_qc_junk == '1' & pos_qc_junk =='1' &  ...
             inst_type~= 9 & p2~='R' & p1~='G');
  

        %subsect data for only the profiles that we are interested in
        ngood=length(good);
        bad_prof=[];
        if ~isempty(good)
            
            
           
            
          ind=[1:ngood];
           
           depth_junk=depth_junk(:,good);
           lat_junk=lat_junk(good);
           lon_junk=lon_junk(good);
           jud_junk=jud_junk(good);
           temp_junk=temp_junk(:,good);
           sal_junk=sal_junk(:,good);
           temp_qc2_junk=temp_qc2_junk(:,good);
           depth_junk=sw_pres(depth_junk,lat_junk');
           
         
           
           [year,month,day]=jd2date(jud_junk+date2jd(1950));
           dt(ind,1)=year;
           dt(ind,2)=month;
           dt(ind,3)=day;
           
           cds(ind,1)=lon_junk;
           cds(ind,2)=lat_junk;
           
           mdep(ind)=max(depth_junk);
           
            for iprof=1:ngood
            

              bad= temp_junk(:,iprof) == 99999 |temp_qc2_junk(:,iprof) =='4'...
                  | sal_junk(:,iprof) == 99999 |sal_qc2_junk(:,iprof) =='4'|depth_junk(:,iprof)==99999;
              junk_depth_test=depth_junk(~bad,iprof);
              junk_uq=unique(junk_depth_test);

              %look for bad profiles where there are duplicate depths
              if length(junk_uq) ~=length(junk_depth_test)
                  bad_prof=[bad_prof iprof];
              end

             
              data{ind(iprof),1}=temp_junk(~bad,iprof) ;
              data{ind(iprof),2}=sal_junk(~bad,iprof);
               data{ind(iprof),3}=depth_junk(~bad,iprof);
              
           end
            clear temp_junk depth_junk pos_qc_junk temp_qc_junk lat_junk lon_junk 
            
        end
    
        netcdf.close(ncid)
       pos_good=[1:ngood];
pos_good(bad_prof)=[];
% if junk_name== 'EN.4.2.2.f.profiles.c14.200901.nc'
%     pos_good(5334)=[];
% end
% if junk_name== 'EN.4.2.2.f.profiles.c14.200903.nc'
%     pos_good(12330)=[];
% end
% if junk_name== 'EN.4.2.2.f.profiles.c14.201206.nc'
% %     
%     pos_good(14160)=[];
%     pos_good(14743)=[];
% %     pos_good(19375)=[];
%     pos_good(20170)=[];
%     pos_good(21248)=[];
%      pos_good(20170)=[];
%       pos_good(20171)=[];
% end 
ngood=length(pos_good);


nprof=ngood;
dt=dt(pos_good,:);
coords=cds(pos_good,:);
data=data(pos_good,:);
mdep=mdep(pos_good);
  % compute WOD number
           
           wnum=nans(ngood,1);
            
           iii=find(coords(:,1)<=0&coords(:,2)>0);
           jjj=find(coords(:,1)>0 &coords(:,2)>0);
           lll=find(coords(:,1)<=0&coords(:,2)<=0);
           nnn=find(coords(:,1)>0 &coords(:,2)<=0);
           wnum(iii)=abs(ceil(coords(iii,1)/10))+100*(ceil(coords(iii,2)/10)-1)+7000;
           wnum(jjj)=ceil(coords(jjj,1)/10)-1+100*(ceil(coords(jjj,2)/10)-1)+1000;
           wnum(lll)=abs(ceil(coords(lll,1)/10))+100*abs(ceil(coords(lll,2)/10))+5000;
           wnum(nnn)=ceil(coords(nnn,1)/10)-1+100*abs(ceil(coords(nnn,2)/10))+3000;
%put into the standard form of WOD05

% for i=1:nprof; n=length(temp{i,1});temp{i,1}=[temp{i,1} temp{i,2} ones(n,1)*0 ones(n,1)*0];end;
% temp=temp(:,1);
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

