function stud=student90(num)
%
% returns the student t distribution stud for 90% confidence limits 
% given the number of degrees of freedom num

n=[1:30,40:10:60,80:20:120,1e99]';
t=[6.3140,2.9200,2.3530,2.1320,2.0150,1.9430,1.8950,1.8600,1.8330,1.8120,1.7960,1.7820,1.7710,1.7610,1.7530,1.7460,1.7400,1.7340,1.7290,1.7250,1.7210,1.7170,1.7140,1.7110,1.7080,1.7060,1.7030,1.7010,1.6990,1.6970,1.6840,1.6760,1.6710,1.6640,1.6600,1.6580,1.6450]';

stud=NaN*num;
ii=find(num>=1);
stud(ii)=interp1(n,t,num(ii));
