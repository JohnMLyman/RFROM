function []=write_ascii_CERES_RFROM(rate,ceres,tgrid,file_name)



% area_of_earth=5.1e14./2;
% sec_in_year=(60.*60*24*365.25);
% fac=1./(sec_in_year.*area_of_earth);
% 
% 
% start_ind=3;
% end_ind_off=2;
% 
% 
% rate=(hc(start_ind:end)-hc(1:end-end_ind_off)).*fac;
% time_rate=.5.*(tgrid(1:end-end_ind_off)+tgrid(start_ind:end));



d=[tgrid rate ceres];
fid = fopen(file_name, 'w');
fprintf(fid, 'Time(Years)       OHU(W/M^2)  CERES(W/M^2) \n\n');
fprintf(fid, '%10.1f  %15.3f %15.3f \n', d');
fclose(fid);

