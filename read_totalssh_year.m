function [ssh_total,time_aviso,nfiles]=read_totalssh_year(s,syr,nlon_tpx,nlat_tpx,tpx_year,TreePredictInfo) 
% tpx_year must be an integer year
global_basins_aviso=TreePredictInfo.global_basins_aviso;

good_tpx_files=find(tpx_year<=(syr) & (syr)<tpx_year+1);
syr=syr(good_tpx_files);
s=s(good_tpx_files);
% aviso_day=aviso_day(good_tpx_files);
nfiles=length(syr);

ssh_total=nans(nlon_tpx,nlat_tpx,nfiles);
% sst_total=ssh_total;
time_aviso=nans(1,nfiles);


    
%     yr_name=num2str(tpx_year);
%     sst_anom_year=double(ncread([path_oisst,'sst.day.mean.',yr_name,'.nc'],'sst'));
%     sst_anom_year(sst_anom_year<= -9.9692e+36)=nan;
%     sst_time=double(ncread([path_oisst,'sst.day.mean.',yr_name,'.nc'],'time'));
%     sst_time=sst_time-min(sst_time)+1;
%     max_sst_time=max(sst_time);
%             sshave=zeros(length(lon_tpx),length(lat_tpx));
    
    ii=find(0<=(syr-tpx_year) & (syr-tpx_year)<1);
    for j=1:length(ii)
        ifile=ii(j);
        load([s(ifile).folder,'\',s(ifile).name])
%         junk_day=aviso_day(ii(j));

        if ~exist('offset_adt','var') 
            % only take delayed mode ssh for the means fine for the anomly
            %JML 6/27/2023 no ssh mean in black or caspin sea, so use
            %anomaly instead

            adt(global_basins_aviso(10).pos|global_basins_aviso(6).pos)=sshanom(global_basins_aviso(10).pos|global_basins_aviso(6).pos);
            ssh_total(:,:,ifile)=adt;
%             if junk_day<=max_sst_time
%                 sst_total(:,:,ifile)=sst_anom_year(:,:,junk_day);
%             end
            time_aviso(ifile)=syr(ifile);
        end
        clear offsset_adt
    end

           
end        
            
        
        