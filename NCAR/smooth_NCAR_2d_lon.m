function var_out=smooth_NCAR_2d_lon(var)
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

var_360=var;

var_out=nan(1800,1200);
var_360(var<180)=var_360(var<180)+360;

n_var(~isfinite(var))=0;


var=sum(sum(var,1,'omitnan'),3,'omitnan');
var_360=sum(sum(var_360,1,'omitnan'),3,'omitnan');
n_var=sum(sum(n_var,1,'omitnan'),3,'omitnan');
var=reshape(var./n_var,1800,1200);
var_360=reshape(var_360./n_var,1800,1200);


var_360(var_360>360)=var_360(var_360>360)-360;
var_out(1:900,:)=var_360(1:900,:);
var_out(901:1800,:)=var(901:1800,:);


end