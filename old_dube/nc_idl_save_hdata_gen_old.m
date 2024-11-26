function nc_idl_save_hdata_gen_old(filename)
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

nc = netcdf([filename '.nc'], 'clobber');              % Create NetCDF file.

nc.description = '13-year record of heatcontent';                   % Global attributes.
nc.author = 'Dr. John M/ Lyman';
nc.date = 'Agust 29, 2006';
%load /home/shoko2/wills/globalhc_dirs/Globalhc/SAL/Floats/total_den_grid_april_19.mat
eval(['load '  filename]);

% Define dimensions.

[n_prof,n_coords]=size(coords);
nc('n_prof') = n_prof;
nc('n3')=n_coords;


  % Define variables.



nc{'coords'}={'n_prof','n3'};

nc{'htanom'}={'n_prof'};
nc{'tpx'}={'n_prof'};
nc{'htdiff'}={'n_prof'};
nc{'yr'}={'n_prof'};

%nc{'latitude'}.units = 'degrees';                    % Attributes.%
%nc{'longitude'}.units = 'degrees';
%nc{'depth'}.units = 'meters';


                                                    % Put all the data.

nc{'coords'}(:) = coords;

nc{'htanom'}(:) = htanom;
nc{'htdiff'}(:) = htdiff;
nc{'tpx'}(:) = tpx;



nc = close(nc);                                      % Close the file.

