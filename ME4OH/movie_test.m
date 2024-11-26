s=size(ohca_1)

for itime=1:s(3)

    figure(1)
    contourf(lon,lat,ohca_2(:,:,itime)',...
        [-1:.1:1].*1e-3)
    title(num2str((itime)))
    colorbar
    figure(2)
    contourf(lon,lat,ohca_mask_2(:,:,itime)',...
        [-1:.1:1].*1e-3)
    title(num2str(itime))
    colorbar
    figure(3)
    pcolor(lon,lat,...
        abs(ohca_2(:,:,itime)'-ohca_mask_2(:,:,itime)')./ohca_2(:,:,itime)')
    caxis([0 1])
    shading flat
    colorbar
    pause
end