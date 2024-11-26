function [fresh_water]=fresh_water_input(temp,sal,depth,mean_sal,max_depth)

% this code computes the fresh water input 

%       Output
% fresh_water in meters is the equivlient fresh water input


%       Inputs

% ALL QUANITIES ARE VECTORS
% temp is the temperature in degrees c
% sal is the salinity of psu
% depth of measurement in meters depth(1) is the location of the shallowest
%       measurmnet
% mean_sal is a mean salinity (probably from levitus)
% max_depth is the maxium depth used.


good=find(depth <=max_depth);


if length(good) >= 5 
    
temp=temp(good);
sal=sal(good);
mean_sal=mean_sal(good);
depth=abs(depth(good));

n=length(good);

dz=(depth(1:n-2)-depth(3:n))./2;

dz=abs([(depth(1)+depth(2))./2,dz,depth(n)-depth(n-1)]);


dfresh_water=dz.*(mean_sal-sal)./sal;


% compute the intergral of fresh water



fresh_water=nansum(dfresh_water);


else
    fresh_water=NaN;
end

