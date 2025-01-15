function stud=student(num)
%
% returns the student t distribution stud for 95% confidence limits 
% given the number of degrees of freedom num

n=[1:30,40,60,120,1e99]';
t=[12.706,4.303,3.182,2.776,2.571,2.447,2.365,2.306,2.262,2.228,2.201,2.179,2.160,2.145,2.131,2.120,2.110,2.101,2.093,2.086,2.080,2.074,2.069,2.064,2.060,2.056,2.052,2.048,2.045,2.042,2.021,2.000,1.980,1.960]';

stud=NaN*num;
ii=find(num>=1);
stud(ii)=interp1(n,t,num(ii));




