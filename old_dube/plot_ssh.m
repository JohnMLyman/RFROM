
for i=1:52
pcolor(lon_tpx,lat_tpx,squeeze(ssh_total(:,:,i)'));
shading flat
caxis([-30 30])
i
pause
end