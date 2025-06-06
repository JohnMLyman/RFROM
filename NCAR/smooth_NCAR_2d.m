function var_out=smooth_NCAR_2d(var)
% This function takes a 2x3 gridpoint average the 2-d grid
var=double(var);

% n_Ln=ones(2,1800,3,800);
% var= reshape(var,2,1800,3,800);
% n_var=n_Ln;
% n_var(~isfinite(var))=0;
% var=sum(sum(var,1,'omitnan'),3,'omitnan');
% n_var=sum(sum(n_var,1,'omitnan'),3,'omitnan');
% var_out=reshape(var./n_var,1800,800);



n_Ln=ones(2,1800,2,1200);
var= reshape(var,2,1800,2,1200);
n_var=n_Ln;
n_var(~isfinite(var))=0;
var=sum(sum(var,1,'omitnan'),3,'omitnan');
n_var=sum(sum(n_var,1,'omitnan'),3,'omitnan');
var_out=reshape(var./n_var,1800,1200);


end