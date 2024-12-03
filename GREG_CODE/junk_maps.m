s=size(ct_res_old)
idepth=58;

for itime=1:s(4)


    figure(1)

    pcolor(ct_res(:,:,idepth,itime)')
    shading flat
    
% 
%     figure(2)
% 
%     pcolor((ct_res(:,:,idepth,itime)-ct_res_old(:,:,idepth,itime))')
%     shading flat
    pause


end

