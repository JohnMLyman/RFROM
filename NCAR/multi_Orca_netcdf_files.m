




file_path_in='K:\data\NCAR\model_grid\';
file_path_out='L:\data\NCAR\small_grid\';

sdir=dir([file_path_in,'NCAR_POP_*.nc']);


nfiles=length(sdir);




for ifiles=1:nfiles
% for ifiles=1

%    file_name='g.e20.G.TL319_t13.control.001.pop.h.0183-12-31.nc';
   file_name=sdir(ifiles).name
   
   Orca_netcdf_files(file_name,file_path_in,file_path_out)


  
end


