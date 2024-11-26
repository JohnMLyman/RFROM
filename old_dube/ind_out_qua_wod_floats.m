function [ind_bad]=ind_out_qua_press(vec_all,n_qua,pos_floats,pos_wod)
% this fuction find the indiceses of float data thatthat lie outside of n_qua quatoail of
% the median of the vec_wod.


%               Inputs
% pos_floats are the location of the floats
% pos_wod are the position of the World ocean data base
% vec_all is a vector contaning both floats and the World ocean data base
% n_qua is the number of quatorials

%               Output
% ind_bad the indices of pos_floats that are bad 


vec=vec_all(pos_wod);
vec_floats=vec_all(pos_floats);

good=(find(finite(vec) == 1 ));
n=length(good);
vec2=vec(good);
vec2=sort(vec2);

%find the quatorials

if n > 1
quat=interp1([0:n-1]/(n-1),vec2,[.25 .5 .75]);

min_good=quat(2)-n_qua*(quat(3)-quat(1)); 
max_good=quat(2)+n_qua*(quat(3)-quat(1));


ind_bad=find(vec_floats > max_good | vec_floats < min_good);

else
    ind_bad=[];
end