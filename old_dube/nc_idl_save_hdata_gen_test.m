function nc_idl_save_hdata_gen_test

%

%eval(['load '  filename]);

mode = bitor ( nc_clobber_mode, nc_64bit_offset_mode );
nc_file=['idl_test_sncs.nc']

nc_create_empty(nc_file,mode)

coords=(rand(2,3));
% Define dimensions.

[n_prof,n_coords]=size(coords);

nc_add_dimension(nc_file,'n3',(n_coords));

nc_add_dimension(nc_file,'n_prof',n_prof);
  % Define variables.
clear varstruct
varstruct.Name='coords_out';
varstruct.Dimension={'nprof','n3'};
%varsturct.Nctype=nc_float;

  
% % var_htanom.Name='htanom';
% % var_htanom.Dimension={'n_prof'};
% % %var_htanom.Nctype=nc_float;
% %   
% % var_tpx.Name='tpx';
% % var_tpx.Dimension={'n_prof'};
% % %var_tpx.Nctype=nc_float;
% % 
% % var_yr.Name='yr';
% % var_yr.Dimension={'n_prof'};
% % %var_yr.Nctype=nc_float;
% % 
% % var_htdiff.Name='htdiff';
% % var_htdiff.Dimension={'n_prof'};
% % %var_htdiff.Nctype=nc_float;



%nc{'latitude'}.units = 'degrees';                    % Attributes.%
%nc{'longitude'}.units = 'degrees';
%nc{'depth'}.units = 'meters';


                                                    % Put all the data.
nc_addvar(nc_file, varstruct);
%nc_varput(nc_file,'coords')
% % nc_addvar(nc_file, var_htanom)
% % nc_addvar(nc_file, var_tpx)
% % nc_addvar(nc_file, var_yr)
% % nc_addvar(nc_file, var_htdiff)

clear vardata
vardata.coords_out=coords
nc_addnewrecs(nc_file,vardata)
nc_dump(nc_file)

