% this code loads in all the alphas


file_path_out='/Users/johnlyman/data/Globalhc/Floats/Argo/CORIOLIS/depth_grid/'

alon=[-181:181];alat=[-91:91];
eval(['load ',file_path_out,'aviso_mask lon lat mask']);

lon=[lon(542:end)-360;lon(1:541)];
lon=[lon(end-1:end)-360;lon;lon(1)+360];
mask=[mask(542:end,:);mask(1:541,:)];
mask=[mask(end-1:end,:);mask;mask(1,:)];

al_1800=ones(length(lon),length(lat),12)*NaN;
al_975=al_1800;



for imon=1:12
    
    
    eval(['load ',file_path_out,'hregress_750_',num2str(imon)]);
    eval(['load ',file_path_out,'hregress_975_',num2str(imon)]);
    eval(['load ',file_path_out,'hregress_1800_',num2str(imon)]);
    alpha_1800=interp2(alat,alon,alpha_1800,lat,lon');
    alpha_975=interp2(alat,alon,alpha_975,lat,lon');
    alpha_750=interp2(alat,alon,alpha_750,lat,lon');
        
    alpha_1800(isnan(mask))=NaN;
    alpha_975(isnan(mask))=NaN;
    alpha_750(isnan(mask))=NaN;
    
    al_1800(:,:,imon)=alpha_1800;
    al_975(:,:,imon)=alpha_975;
    al_750(:,:,imon)=alpha_750;
    
end


%compute the mean and varience of Alpha


mean_al_975=nansum(al_975,3)./12;

std_al_975=sqrt(nansum((al_975-repmat(mean_al_975,[1 1 12])).^2,3)./12);






