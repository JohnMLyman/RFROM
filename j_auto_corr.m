function [N_star,c]=j_auto_corr(y)


% this code computes the auto corelation for half the time series
% c the auto corelation
% N_star are the effective degrees of freedom

y=double(y);
x=y;
mx=mean(x);
var=sum((x-mx).^2);

N=length(x);
clear c
for i=1:N-1
    
x1=x(1:N-i+1);
x2=x(i:N);
c(i)=sum((x1-mx).*(x2-mx))./var;

end
% find the first zero crossing

neg=find(c <=0);
if ~isempty(neg)
    pos_0=neg(1);
else
    pos_0=length(c);
end

% estimate nd
% n1=pos_0-1;
% n2=pos_0;
% c1=c(pos_0-1);
% c2=c(pos_0);
% b=(n1*c2-n2*c1)/(1-n2)
% 
% 
% area_extra=.5*(b-n1)*c1

nd=2.*sum(c(1:(pos_0-1)));

nd=2.*max(cumsum(c));
% if pos_0 == 2  
%     nd=1;
% end 

% figure
% plot(c)
N_star=N/nd;