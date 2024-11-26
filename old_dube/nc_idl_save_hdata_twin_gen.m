function nc_idl_save_hdata_twin_gen(filename)
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
tpx_out=tpx;
yr_out=yr;
hctpx_out=hctpx;
ht_750_out=ht_750;
ht_975_out=ht_975;
ht_1800_out=ht_1800;

  
clear coords tpx hctpx ht_750 ht_975 ht_1800 yr var_coords var_nprof var_tpx var_yr var_hctpx nnn
  
var_nprof.Name='nnn';
var_nprof.Dimension={'nnn'};
nc_addvar(nc_file, var_nprof)

var_coords.Name='coords';
var_coords.Dimension={'nnn','n3'};
%var_coords.Nctype=nc_float;

var_ht_1800.Name='ht_1800';
var_ht_1800.Dimension={'nnn'};

var_ht_750.Name='ht_750';
var_ht_750.Dimension={'nnn'};

var_ht_975.Name='ht_975';
var_ht_975.Dimension={'nnn'};

  
var_hctpx.Name='hctpx';
var_hctpx.Dimension={'nnn'};
%var_hctpx.Nctype=nc_float;
  
var_tpx.Name='tpx';
var_tpx.Dimension={'nnn'};
%var_tpx.Nctype=nc_float;

var_yr.Name='yr';
var_yr.Dimension={'nnn'};
%var_yr.Nctype=nc_float;





%nc{'latitude'}.units = 'degrees';                    % Attributes.%
%nc{'longitude'}.units = 'degrees';
%nc{'depth'}.units = 'meters';


                                                    % Put all the data.
nc_addvar(nc_file, var_coords)
nc_addvar(nc_file, var_hctpx)
nc_addvar(nc_file, var_tpx)
nc_addvar(nc_file, var_yr)
nc_addvar(nc_file, var_ht_750)
nc_addvar(nc_file, var_ht_975)
nc_addvar(nc_file, var_ht_1800)

% add data

clear vardata

vardata.nnn=[1:n_prof_out]';
vardata.coords=coords_out;
vardata.hctpx=hctpx_out;
vardata.ht_750=ht_750_out;
vardata.ht_975=ht_975_out;
vardata.ht_1800=ht_1800_out;
vardata.tpx=tpx_out;
vardata.yr=yr_out;

nc_addnewrecs(nc_file,vardata,'nnn');

nc_dump(nc_file)

