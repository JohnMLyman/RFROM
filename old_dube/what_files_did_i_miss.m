
d=sdir(['grad_den_0_grid_aden_den_no_*.mat']);
d_ind=sdir(['ind_grad_den_0_grid_aden_den_no_*.mat']);
 
d_length=length(d)
d_ind_length=length(d_ind)


for i=1:d_length

    
    num(i)=str2num(d(i).name(30:33));
    
   if i <= d_ind_length
       num_ind(i)=str2num(d_ind(i).name(34:37));
   end %if


end %for

num_ind=num_ind(32+333+12:end);
num=num(33+334+13:end);
