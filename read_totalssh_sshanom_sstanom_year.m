function [ssh_total,sst_total,time_aviso,nfiles]=read_totalssh_sshanom_sstanom_year(s,syr,aviso_day,path_oisst,nlon_tpx,nlat_tpx,tpx_year,TreeSetUp) 
% tpx_year must be an integer year
tree_model_file_name_season=TreeSetUp.tree_model_file_name_season;
path_tree=TreeSetUp.path_tree;
center_year=TreeSetUp.center_year;


 load([path_tree,tree_model_file_name_season,'_seasonal_cycle_tpx_split.mat'],...
            'amp_annual_total','phase_annual_total','amp_semi_total','phase_semi_total',...
            'amp_third_total','phase_third_total','slope_total','mean_total',...
            'lon_tpx','lat_tpx')
        period=1;
        period2=1/2;
        period3=1/3;

good_tpx_files=find(tpx_year<=(syr) & (syr)<tpx_year+1);
syr=syr(good_tpx_files);
s=s(good_tpx_files);
ssh_time=strjust(strvcat(s(:).name),'right');
ssh_time=str2num(ssh_time(:,end-8:end-4))+datenum(1950,1,1);
nfiles=length(syr);

ssh_total=nans(nlon_tpx,nlat_tpx,nfiles);
sst_total=ssh_total;
time_aviso=nans(1,nfiles);


    
    yr_name=num2str(tpx_year);
    sst_anom_year=double(ncread([path_oisst,'sst.day.anom.',yr_name,'.nc'],'anom'));
    sst_anom_year(sst_anom_year<= -9.9692e+36)=nan;
    sst_time=double(ncread([path_oisst,'sst.day.anom.',yr_name,'.nc'],'time'));
   sst_time=sst_time+datenum(1800,1,1);
%             sshave=zeros(length(lon_tpx),length(lat_tpx));
    
    ii=find(0<=(syr-tpx_year) & (syr-tpx_year)<1);
    for j=1:length(ii)
        ifile=ii(j);
        load([s(ifile).folder,'\',s(ifile).name])
        
        good_t=syr(ifile);
        ssh_seasonal_cycle=amp_annual_total.*sin((2*pi.*good_t./period)+phase_annual_total)+amp_semi_total.*sin((2.*good_t*pi./period2)+phase_semi_total)+...
                    amp_third_total.*sin((2*pi.*good_t./period3)+phase_third_total)+mean_total+slope_total.*center_year;
        

        
            ssh_total(:,:,ifile)=sshanom-ssh_seasonal_cycle;
           %             if junk_day<=max_sst_time
             
                sst_total(:,:,ifile)=sst_anom_year(:,:,sst_time==ssh_time(ifile));
%             end
            time_aviso(ifile)=syr(ifile);
     
    end

           
end        
            
        
        