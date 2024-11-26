path_temp_old='H:\erddap\temp_vertnetcdf\tree_temp_vert_nosshsst_newcycle\yearly_withcycle\';
path_sal_old='H:\erddap\sal_vertnetcdf\tree_sal_vert_nosshsst_newcycle\yearly_withcycle\';

path_temp_new='H:\erddap_filt\sal_vertnetcdf_stable\tree_sal_vert_nosshsst_newcycle\yearly_withcycle\';
path_sal_new='H:\erddap_filt\sal_vertnetcdf_stable\tree_sal_vert_nosshsst_newcycle\yearly_withcycle\';

path_temp_old='H:\erddap_filt\temp_vertnetcdf\tree_temp_vert_nosshsst_newcycle\yearly_withcycle\';
path_sal_old='H:\erddap_filt\sal_vertnetcdf\tree_sal_vert_nosshsst_newcycle\yearly_withcycle\';

file_date='2012_09';

temp_old=ncread([path_temp_old,'RFROM_TEMP_',file_date,'.nc'],'ocean_temperature');
sal_old=ncread([path_sal_old,'RFROM_SAL_',file_date,'.nc'],'ocean_salinity');

temp_new=ncread([path_temp_new,'RFROM_TEMP_STABLE_',file_date,'.nc'],'ocean_temperature');
sal_new=ncread([path_sal_new,'RFROM_SAL_STABLE_',file_date,'.nc'],'ocean_salinity');

lat=ncread([path_temp_old,'RFROM_TEMP_',file_date,'.nc'],'latitude');
lon=ncread([path_temp_old,'RFROM_TEMP_',file_date,'.nc'],'longitude');
pres=ncread([path_temp_old,'RFROM_TEMP_',file_date,'.nc'],'mean_pressure');


sal_a16_old=(squeeze(sal_old(1340,:,:,1)));
sal_a16_new=(squeeze(sal_new(1340,:,:,1)));

temp_a16_old=(squeeze(temp_old(1340,:,:,1)));
temp_a16_new=(squeeze(temp_new(1340,:,:,1)));



contourf([1:720],-1.*pres,squeeze(temp_new(1340,:,:,1))',[0:1:29])
contourf([1:720],-1.*pres,squeeze(sal_new(1340,:,:,1))',[34:.2:37.5])

% s=size(temp_new);
% 
% sal_new_filt=nan(s);
% temp_new_filt=nan(s);
% 
% parfor idepth=1:s(3)
%     for itime=1:4
%          sal_new_filt(:,:,idepth,itime)=nanmedflit2_globe(sal_new(:,:,idepth,itime),3);
%          temp_new_filt(:,:,idepth,itime)=nanmedflit2_globe(temp_new(:,:,idepth,itime),3);
%     end
% end
% 
% sal_new_filt2=nan(s);
% temp_new_filt2=nan(s);
% parfor idepth=1:s(3)
%     for itime=1:4
%          sal_new_filt2(:,:,idepth,itime)=nanmedflit2_globe(sal_new_filt(:,:,idepth,itime),3);
%          temp_new_filt2(:,:,idepth,itime)=nanmedflit2_globe(temp_new_filt(:,:,idepth,itime),3);
%     end
% end
% 
% sal_a16_new_filt=(squeeze(sal_new_filt(1340,:,:,1)));
% 
% 
% temp_a16_new_filt=(squeeze(temp_new_filt(1340,:,:,1)));
% 
% sal_a16_new_filt2=(squeeze(sal_new_filt2(1340,:,:,1)));
% 
% 
% temp_a16_new_filt2=(squeeze(temp_new_filt2(1340,:,:,1)));
