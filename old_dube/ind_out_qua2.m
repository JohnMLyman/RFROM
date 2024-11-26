function [ind_bad]=ind_out_qua2(vec,n_qua)
% this fuction find the indiceses of points that lie outside of n_qua
% quatorils of the median the mean of vec. twice

[ind1]=ind_out_std(vec,n_qua);

good=[1:length(vec)];
good(ind1)=[];
vec(ind1)=[];


good2=[1:length(vec)];
[ind2]=ind_out_qua(vec,n_qua);
vec(ind2)=[];
[ind3]=ind_out_qua(vec,n_qua);




ind_bad=[good2(ind3),good(ind2),ind1'];

%ind_bad=[good(ind2),ind1'];


