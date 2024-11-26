function ncexample

% ncexample.m -- "NetCDF Toolbox for Matlab-5" example.
%  ncexample (no argument) is a short example that lists
%   itself, builds a simple NetCDF file, then displays
%   its variables.
 
% Copyright (C) 1997 Dr. Charles R. Denham, ZYDECO.
%  All Rights Reserved.
%   Disclosure without explicit written consent from the
%    copyright owner does not constitute publication.
 
% Version of 12-Jun-1997 16:23:04.

type(mfilename)

help(mfilename)
 
% ---------------------------- DEFINE THE FILE --------------------------- %

ncquiet                                              % No NetCDF warnings.

nc = netcdf('all_data_gam.nc', 'clobber');              % Create NetCDF file.

nc.description = 'Argo on nutral desity surfaces';                   % Global attributes.
nc.author = 'Dr. John M/ Lyman';
nc.date = 'April 24, 2006';
load /home/shoko2/wills/globalhc_dirs/Globalhc/SAL/Floats/total_den_grid_april_19.mat

% Define dimensions.

[n_prof,n_den]=size(press_gam_tot);
nc('n_prof') = n_prof;
nc('n_den')=n_den;
nc('n3')=2;
nc('n4')=3;

  % Define variables.


nc{'press_gam'} = {'n_prof', 'n_den'};

nc{'sal_gam'} = {'n_prof', 'n_den'};
nc{'temp_gam'} = {'n_prof', 'n_den'};
nc{'coords'}={'n_prof','n3'};
nc{'dt'}={'n_prof','n4'};
nc{'press_gam_top'}={'n_prof'};
nc{'press_gam_bot'}={'n_prof'};
nc{'density_levels'}={'n_den'};
%nc{'latitude'}.units = 'degrees';                    % Attributes.%
%nc{'longitude'}.units = 'degrees';
%nc{'depth'}.units = 'meters';


                                                    % Put all the data.
nc{'press_gam'}(:) = press_gam_tot;
nc{'sal_gam'}(:) = sal_gam_tot;
nc{'temp_gam'}(:) = temp_gam_tot;
nc{'coords'}(:) = coords_tot;
nc{'dt'}(:) = dt_tot;
nc{'density_levels'}(:) = density_surface;
nc{'press_gam_top'}(:) = press_top_gam_tot;
nc{'press_gam_bot'}(:) = press_bot_gam_tot;

nc = close(nc);                                      % Close the file.

