% This code will compute a few different mappings with the corvarience
% function from Wills 2004 and see what the weighting function looks like 
% this code will copute the wieghts at 0,0

%n=200;
%f=3
sigma_ave=1.;

% x=rand(n,1)*1500;
% 
% y=rand(n,1)*1500;

%x(1)=0.;
%y(1)=0.;
dist=sqrt((x*ones(1,n)-ones(n,1)*x').^2+(y*ones(1,n)-ones(n,1)*y').^2);
dist_center=sqrt((x').^2+(y').^2);

E=.22*exp(-1.*dist/920)+.78*exp(-1.*(dist/100).^2);

c=.22*exp(-1.*dist_center/920)+.78*exp(-1.*(dist_center/100).^2);

z=ones(n,1);

E=E+eye(n);

w=c*(inv(E));

[junk,ind]=sort(-abs(w));

w=w(ind);

weight_sum_sqares=sum(w(f+1:end).^2);
weight_total_ave=(36-f)/(36^2);
weight_overlap=sum((w(1:f)-(1/36)).^2);

sigma=sigma_ave*sqrt(weight_sum_sqares+weight_total_ave+weight_overlap);


sigma_topex=sqrt(1/(36));

sigma_diff=sqrt(sum(w.^2));

sigma2=sqrt(sigma_topex^2+sigma_diff^2);
