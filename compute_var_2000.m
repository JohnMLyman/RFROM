function [var_out]=compute_var_2000(ohca) 

ohca_2000=squeeze(jnansum((ohca),3));

var_out=var(ohca_2000,1,3,'omitnan');

end