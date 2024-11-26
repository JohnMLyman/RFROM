function [ind_bad]=ind_out_std(vec,n_std)
% this fuction find the indiceses of points that lie outside of n_std std of
% the mean vec.

n=length(find(finite(vec) == 1));
mean_vec=nansum(vec)/n;

var_vec=(vec-mean_vec).^2;

std_vec=sqrt(nansum(var_vec)./n);

ind_bad=find(sqrt(var_vec) > n_std.*std_vec);

