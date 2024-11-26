density_surface=[18:.02:31];
 lon0=[-180:180];
 lat0=[-90:90];



for den_pos=300:2:600
    
close all
figure(1)
good_time=find((dt_tot(:,1) == 2005) & (dt_tot(:,2) == 2) );
subplot(2,1,1)

m_proj('Miller Cylindrical');


 m_grid
 hold on

m_pcolor(lon0,lat0,griddata(coords_tot(good_time,1),coords_tot(good_time,2),...
    (press_0_tot(good_time,den_pos)-press_gam_tot(good_time,den_pos)),lon0,lat0'));
m_coast('patch',2)
title(num2str(density_surface(den_pos)));


shading flat
hold off
colorbar   
 
subplot(2,1,2)

m_proj('Miller Cylindrical');


 m_grid
 hold on

m_pcolor(lon0,lat0,griddata(coords_tot(good_time,1),coords_tot(good_time,2),...
    (press_0_tot(good_time,den_pos)),lon0,lat0'));
m_coast('patch',2)
title(num2str(density_surface(den_pos)));
shading flat
hold off
colorbar   
 

% figure(2)
% 
% m_proj('Miller Cylindrical');
% 
% 
%  m_grid
%  hold on
% 
% m_pcolor(lon0,lat0,griddata(coords_tot(good_time,1),coords_tot(good_time,2),press_gam_tot(good_time,den_pos),lon0,lat0'));
% m_coast('patch',2)
% 
% title(num2str(density_surface(den_pos)));
% 
% 
% shading flat
% colorbar
% 
% hold off
pause
end