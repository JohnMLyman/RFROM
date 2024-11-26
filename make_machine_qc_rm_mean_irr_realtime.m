function qc_new=make_machine_qc_rm_mean_irr_realtime(path_of_float,file_meta)

% path_of_data='C:\argo\data';
%load 'C:\argo\data\metadata_qc\float_info_machine_all_irr_wmo_nolat' trainedClassifier_nolat
% load 'C:\argo\data\metadata_qc\float_info_machine_test_march_2019.mat' trainedClassifier_test_march_2019

 load 'C:\argo\data\metadata_qc\float_info_machine_2019_irr_qc.mat' trainedClassifier_qc34

trainedClassifier=trainedClassifier_qc34;
% ind_of_floats=[1:length(float_list)];
% %ind_of_floats=[1];
% n_floats=length(ind_of_floats);

% pre-load files to get size of arrays 
Nall=0;
% platform_type_total=[];
% num_samp_total=[];
% 
% count the number of observations before computing
% for ifloat=1:n_floats
%     float=float_list(ifloat).name;
%     path_of_float=[path_of_data,'\',float,'\',input_dir];
%     path_of_meta=[path_of_data,'\',float,'\','aoml_recent'];
   
    if exist(path_of_float,'dir')
        cd(path_of_float)
        list_of_cycles=sdir('R*.nc');
        ncycles=length(list_of_cycles);
        nt=0;

        if ~isempty(list_of_cycles)
            file_cycle1=list_of_cycles(1).name;

            info_nc=ncinfo(file_cycle1);
            vars_in_nc=squeeze(struct2cell(info_nc.Variables));
            vars_in_nc=squeeze(vars_in_nc(1,:));
            if ismember('PLATFORM_TYPE',vars_in_nc)
                platform_type_name=ncread(file_cycle1,'PLATFORM_TYPE')';
                platform_type_name=platform_type_name(1:8);
            else
                platform_type_name=blanks(7);
            end
%             info_nc=ncinfo(file_cycle1);
%             vars_in_nc=squeeze(struct2cell(info_nc.Variables));
%             vars_in_nc=squeeze(vars_in_nc(1,:));
%             if ismember('PLATFORM_TYPE',vars_in_nc)
%                 platform_type=ncread(file_cycle1,'PLATFORM_TYPE');
%             else
%                 platform_type=blanks(32)';
%             end
            num_samp=length(ncread(file_cycle1,'PRES'));
           % figure out the type of float
                if num_samp <100
                platform_type=1;
                else if ~isempty(strfind(platform_type_name,'APEX'))
                        platform_type=2;
                    else if ~isempty(strfind(platform_type_name,'NAVISIR'))
                            platform_type=3;
                        else if ~isempty(strfind(platform_type_name,'NAVIS_A'))
                                platform_type=4;
                            else
                                % I assume if no platform type than the sysetem
                                % is APEX 
                                platform_type=2;
                            end
                        end
                    end
                end
        if platform_type ~=1
            for icycle=1:ncycles
                file_cycle=list_of_cycles(icycle).name;
                
                
                 
                       
                    sal_qc=(ncread(file_cycle,'PSAL_ADJUSTED_QC'));
                   % change missing salqc to 0
                   
                   n=length(sal_qc);
               
                    nt=n+nt;
            end
            Nall=Nall+nt;
         end
            
        end
    end



N2_fit=nan(Nall,1);
press_fit=N2_fit;
mean_N2_fit=N2_fit;
mean_sal_fit=N2_fit;
std_sal_fit=N2_fit;
mean_temp_fit=N2_fit;
std_temp_fit=N2_fit;
lat_fit=N2_fit;
lon_fit=N2_fit;
sal_fit=N2_fit;
sal_anom_fit=N2_fit;
temp_fit=N2_fit;
temp_anom_fit=N2_fit;
qc_sal_fit=N2_fit;
platform_type_fit=N2_fit;
nsamps_fit=N2_fit;
wmo_fit=N2_fit;
wmo_box_fit=N2_fit;
cycle_fit=N2_fit;
sal_sensor_fit=cell(Nall,1);
temp_sensor_fit=sal_sensor_fit;
pres_sensor_fit=sal_sensor_fit;

pos_s=1;
'arrays made'
% % for ifloat=1:n_floats
    
    
%     float=float_list(ifloat).name;
%     path_of_float=[path_of_data,'\',float,'\',input_dir];
%     
%     path_of_meta=[path_of_data,'\',float,'\','aoml_recent'];
%     file_meta=[path_of_meta,'\',float,'_meta.nc'];
    
    if exist(path_of_float,'dir')
        cd(path_of_float)
        list_of_cycles=sdir('R*.nc');
        if ~isempty(list_of_cycles)
            ncycles=length(list_of_cycles);
            file_cycle1=list_of_cycles(1).name;

            info_nc=ncinfo(file_cycle1);
            vars_in_nc=squeeze(struct2cell(info_nc.Variables));
            vars_in_nc=squeeze(vars_in_nc(1,:));
            if ismember('PLATFORM_TYPE',vars_in_nc)
                platform_type_name=ncread(file_cycle1,'PLATFORM_TYPE')';
                platform_type_name=platform_type_name(1:8);
            else
                platform_type_name=blanks(7);
            end
            
            
            wmo_num=str2double(ncread(file_cycle1,'PLATFORM_NUMBER')');
            
            if exist(file_meta,'file')
                sensor_model=ncread(file_meta,'SENSOR_MODEL')';
                temp_sens=deblank(sensor_model(1,:));
                sal_sens=deblank(sensor_model(2,:));
                pres_sens=deblank(sensor_model(3,:));
            else
                temp_sens='nan';
                sal_sens=temp_sens;
                pres_sens=temp_sens;
            end

            num_samp=length(ncread(file_cycle1,'PRES'));
            
            if num_samp <100
                platform_type=1;
            else if ~isempty(strfind(platform_type_name,'APEX'))
                    platform_type=2;
                else if ~isempty(strfind(platform_type_name,'NAVISIR'))
                        platform_type=3;
                    else if ~isempty(strfind(platform_type_name,'NAVIS_A'))
                            platform_type=4;
                        else
                            % I assume if no platform type than the sysetem
                            % is APEX 
                            platform_type=2;
                        end
                    end
                end
            end
            % only look at irridium floats
        if platform_type~=1
            for icycle=1:ncycles
               file_cycle=list_of_cycles(icycle).name;
               pres=ncread(file_cycle,'PRES');
               if length(pres) > 4
                   pres(pres<0)=nan;
                   cycle_num=ncread(file_cycle,'CYCLE_NUMBER');
                   sal=ncread(file_cycle,'PSAL');
                   temp=ncread(file_cycle,'TEMP');
                   lat=ncread(file_cycle,'LATITUDE');
                   long=ncread(file_cycle,'LONGITUDE');
                   sal_qc=(ncread(file_cycle,'PSAL_ADJUSTED_QC'));
                   % change missing salqc to 0
                   sal_qc(sal_qc ==' ')='0';
                   %set all qc that is not 1 to 4 
                   
                   sal_qc=str2num(sal_qc);
                   
                    
                   pos_good=1:length(sal_qc);
                   nsamps=length(pos_good);
                   
                   SA = gsw_SA_from_SP(sal,pres,long,lat);
                   CT = gsw_CT_from_t(SA,temp,pres);
                   [N2, p_mid] = gsw_Nsquared(SA,CT,pres,lat);
                   N2_all=[N2(1);(N2(1:end-1)+N2(2:end))./2;N2(end)];
                   
                   pos_e=nsamps+pos_s-1;
                   N2_fit(pos_s:pos_e)=N2_all(pos_good);
                    press_fit(pos_s:pos_e)=pres(pos_good);
                    mmean_N2=movmean(N2_all,11);
                    mean_N2_fit(pos_s:pos_e)=mmean_N2(pos_good);
                    mmean_s=movmean(sal,11);
                    mean_sal_fit(pos_s:pos_e)=mmean_s(pos_good);
                    mstd_s=movstd(sal,11);
                    std_sal_fit(pos_s:pos_e)=mstd_s(pos_good);
                    mmean_t=movmean(temp,11);
                    mean_temp_fit(pos_s:pos_e)=mmean_t(pos_good);
                    mstd_t=movstd(temp,11);
                    std_temp_fit(pos_s:pos_e)=mstd_t(pos_good);
                    lat_fit(pos_s:pos_e)=lat*ones(1,nsamps);
                    lon_fit(pos_s:pos_e)=long*ones(1,nsamps);
                    platform_type_fit(pos_s:pos_e)=platform_type*ones(1,nsamps);
                    wmo_fit(pos_s:pos_e)=wmo_num*ones(1,nsamps);
                    wmo_box_fit(pos_s:pos_e)=floor(wmo_num/100000)*ones(1,nsamps);
                    
                   
                    
                    sal_sensor_fit(pos_s:pos_e)={sal_sens};
                    temp_sensor_fit(pos_s:pos_e)={temp_sens};
                    pres_sensor_fit(pos_s:pos_e)={pres_sens};
                    
                    
                    cycle_fit(pos_s:pos_e)=cycle_num*ones(1,nsamps);

                    nsamps_fit(pos_s:pos_e)=nsamps*ones(1,nsamps);
                    sal_fit(pos_s:pos_e)=sal(pos_good)-35;
                    msal=movmean(sal,11);
                    sal_anom_fit(pos_s:pos_e)=abs(sal(pos_good)-msal(pos_good));
                    temp_fit(pos_s:pos_e)=temp(pos_good);
                    mtemp=movmean(temp,11);
                    temp_anom_fit(pos_s:pos_e)=abs(temp(pos_good)-mtemp(pos_good));
                    
                    qc_sal_fit(pos_s:pos_e)=sal_qc(pos_good);
                    pos_s=pos_e+1;
                   % If you use the sw rotines it will run faster.

                  % for now every point in depth will have computed for it
               end
            end
        end
        end
    end

    
    
Float_Vars=table(N2_fit,press_fit,mean_N2_fit,mean_sal_fit,std_sal_fit,...
    mean_temp_fit,std_temp_fit,lat_fit,lon_fit,sal_fit,sal_anom_fit,...
    temp_fit,temp_anom_fit,platform_type_fit,wmo_fit,wmo_box_fit,cycle_fit,...
    temp_sensor_fit,sal_sensor_fit,pres_sensor_fit,nsamps_fit,qc_sal_fit);
cycle_all=Float_Vars.cycle_fit(:);
cycles=unique(cycle_all);
qc_new=cell(ncycles,1);
qc_guess=trainedClassifier.predictFcn(Float_Vars);


for icycle=1:ncycles
    
    qc_new{icycle}=qc_guess(cycle_all==cycles(icycle));
end

    