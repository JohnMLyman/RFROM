function var_out=sum_NCAR_2d(var)
% This function takes the sum of 2x3 gridpoint on a 2-d grid




var= reshape(var,2,1800,2,1200);

var=sum(sum(var,1,'omitnan'),3,'omitnan');

var_out=reshape(var,1800,1200);

end