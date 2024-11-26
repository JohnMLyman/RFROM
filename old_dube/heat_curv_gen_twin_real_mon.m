function [sshtpx]=heat_curv_gen_twin_real_mon(tgrid)

current_dir=cd('/Users/johnlyman/data/Globalhc/HC');
file_path_out='/Users/johnlyman/data/Globalhc/Floats/Argo/CORIOLIS/depth_grid/'
eval(['load ',file_path_out,'aviso_2004_2007']);




% get topex annual cycle

lon=[lon(542:end)-360;lon(1:541)];
lon=[lon(end-1:end)-360;lon;lon(1)+360];
aviso_no_cycle=[aviso_no_cycle(542:end,:,:);aviso_no_cycle(1:541,:,:)];
aviso_no_cycle=[aviso_no_cycle(end-1:end,:,:);aviso_no_cycle;aviso_no_cycle(1,:,:)];



arw=areavec(lon,lat);
sshtpx=ones(length(tgrid),12)*NaN;
for imon=1:12
for i=1:length(tgrid)
    good_time=find(date_aviso(:,2) ==imon & date_aviso(:,1)==floor(tgrid(i)));
    sshave=aviso_no_cycle(:,:,good_time);

    sshave=nansum(sshave,3)./length(good_time);

    sshtpx(i,imon)=nansum(arw(:).*sshave(:));

end
end
cd(current_dir);




