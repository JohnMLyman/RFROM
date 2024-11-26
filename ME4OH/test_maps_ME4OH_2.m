% pcolor(nanmean(sum(ohc(:,:,:,:),3),4)'.*1e9)
% 
%  pcolor(nanmean(sum(ohc_ME4OH(:,:,:,:),3),4)'.*1e12)

s=size(ohc);

figure(1)
for idepth=1:s(3)
       figure(1)
       clf
       pcolor(nanmean(ohc_ME4OH(:,:,idepth,:),4)'.*1e12)
       shading flat
       
       figure(2)
       clf
       pcolor(nanmean(ohc(:,:,idepth,:),4)'.*1e9)
       shading flat
       pause

end