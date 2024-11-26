function []=nc_idl_surface_sal_new(filename)

% ncexample.m -- "NetCDF Toolbox for Matlab-5" example.
%  ncexample (no argument) is a short example that lists
%   itself, builds a simple NetCDF file, then displays
%   its variables.
 
% Copyright (C) 1997 Dr. Charles R. Denham, ZYDECO.
%  All Rights Reserved.
%   Disclosure without explicit written consent from the
%    copyright owner does not constitute publication.
 
% Version of 12-Jun-1997 16:23:04.



 
% ---------------------------- DEFINE THE FILE --------------------------- %
nc_file=[filename,'.nc']

nc_create_empty(nc_file)
% Define dimensions.


%load /home/shoko2/wills/globalhc_dirs/Globalhc/SAL/Floats/total_den_grid_april_19.mat
eval(['load /Volumes/Data/Globalhc/SAL/Floats/argo/',filename,'.mat'])

% Define dimensions.

[n_prof_out,n_coords]=size(coords_surface);


nc_add_dimension(nc_file,'n3',n_coords);
nc_add_dimension(nc_file,'n2',3);
nc_add_dimension(nc_file,'nnn',0);

coords_out=coords_surface;
time_out=time_surface;
dt_out=dt_surface;

surface_sal_out=surface_sal_surface;

  % Define variables.
clear coords_surface time_surface dt_surface surface_sal_surface var_coords_surface var_nprof ...
    var_time_surface var_dt_surface var_surface_sal_surface nnn 

var_nprof.Name='nnn';
var_nprof.Dimension={'nnn'};
nc_addvar(nc_file, var_nprof)

var_coords_surface.Name='coords_surface';
var_coords_surface.Dimension={'nnn','n3'};

var_dt_surface.Name='dt_surface';
var_dt_surface.Dimension={'nnn','n2'};

var_surface_sal_surface.Name='surface_sal_surface';
var_surface_sal_surface.Dimension={'nnn'};

var_time_surface.Name='time_surface';
var_time_surface.Dimension={'nnn'};

nc_addvar(nc_file, var_coords_surface)
nc_addvar(nc_file, var_time_surface)
nc_addvar(nc_file, var_surface_sal_surface)
nc_addvar(nc_file, var_dt_surface)

clear vardata

vardata.nnn=[1:n_prof_out]';
vardata.coords_surface=coords_out;
vardata.time_surface=time_out;
vardata.dt_surface=dt_out;
vardata.surface_sal_surface=surface_sal_out;


nc_addnewrecs(nc_file,vardata,'nnn');

nc_dump(nc_file)






          
