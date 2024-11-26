function [var]=read_netcdf_getall_getprofiles_tuna(file_name_nc,varname)


finfo=ncinfo(file_name_nc);
var_names={finfo.Variables.Name};
var=[];

if ~isempty(find(strcmp(varname,var_names), 1)) 
     
    var=ncread(file_name_nc,varname)';
end
   

