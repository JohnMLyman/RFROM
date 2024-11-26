function nc_idl_save_tsdata_gen(filename)
% for some reason I can only get the 64-bit version of the mex file to work
% using these methods.

%load /home/shoko2/wills/globalhc_dirs/Globalhc/SAL/Floats/total_den_grid_april_19.mat
eval(['load '  filename]);
nc_file=[filename,'.nc']

nc_create_empty(nc_file)
% Define dimensions.

[n_prof_out,n_coords]=size(coords);


nc_add_dimension(nc_file,'n3',n_coords);

nc_add_dimension(nc_file,'nnn',0);
  % Define variables.

  
coords_out=coords;
temp_out=temp;
yr_out=yr;
temp_out=temp;
sal_out=sal;

  
clear coords temp sal var_coords var_nprof var_temp var_yr var_sal var_htanom nnn
  
var_nprof.Name='nnn';
var_nprof.Dimension={'nnn'};
nc_addvar(nc_file, var_nprof)

var_coords.Name='coords';
var_coords.Dimension={'nnn','n3'};
%var_coords.Nctype=nc_float;

  
var_temp.Name='temp';
var_temp.Dimension={'nnn'};
%var_htanom.Nctype=nc_float;

var_sal.Name='sal';
var_sal.Dimension={'nnn'};
%var_htanom.Nctype=nc_float;


var_yr.Name='yr';
var_yr.Dimension={'nnn'};
%var_yr.Nctype=nc_float;




%nc{'latitude'}.units = 'degrees';                    % Attributes.%
%nc{'longitude'}.units = 'degrees';
%nc{'depth'}.units = 'meters';


                                                    % Put all the data.
nc_addvar(nc_file, var_coords)
nc_addvar(nc_file, var_sal)
nc_addvar(nc_file, var_temp)
nc_addvar(nc_file, var_yr)

% add data

clear vardata

vardata.nnn=[1:n_prof_out]';
vardata.coords=coords_out;
vardata.sal=sal_out;
vardata.temp=temp_out;
vardata.yr=yr_out;

nc_addnewrecs(nc_file,vardata,'nnn');

nc_dump(nc_file)

