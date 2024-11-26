function [ind_bad]=ind_out_qua(vec,n_qua)
% this fuction find the indiceses of points that lie outside of n_qua quatoail of
% the median of the vec.



good=(find(isfinite(vec) == 1 ));
n=length(good);
vec2=vec(good);
vec2=sort(vec2);

%find the quatorials
quat=interp1([0:n-1]/(n-1),vec2,[.25 .5 .75]);

min_good=quat(2)-n_qua*(quat(3)-quat(1)); 
max_good=quat(2)+n_qua*(quat(3)-quat(1));


ind_bad=find(vec > max_good | vec < min_good);

