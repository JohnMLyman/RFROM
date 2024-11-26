function [ind_bad_wod]=ind_out_qua_argo_wod(vec_argo,vec_wod,n_qua)
% this fuction find the indiceses of points in vec_wod that lie outside of n_qua quatoail of
% the median of the vec_argo.

vec=vec_argo;

good=(find(isfinite(vec) == 1 ));
n=length(good);
vec2=vec(good);
vec2=sort(vec2);

%find the quatorials
quat=interp1([0:n-1]/(n-1),vec2,[.25 .5 .75]);

min_good=quat(2)-n_qua*(quat(3)-quat(1)); 
max_good=quat(2)+n_qua*(quat(3)-quat(1));


ind_bad_wod=find(vec_wod > max_good | vec_wod < min_good);

