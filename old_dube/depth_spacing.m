function [good]=depth_spacing(depth)

% this function return good=1 if the depth 
% profile has adiquate resolution

% only look over the upper 400 meters

max_depth=max(depth);

good_depth=find(depth <= 400);

depth=depth(good_depth);

% standard depths

s_depths=[10 20 30 50:25:150 200:50:300 400:100:1500 1750:500:3000 4000 5000];

ns=length(s_depths);

good=0;
n=length(depth);


if n > 6
    
del_depth=diff(depth);
del_pos=(depth(1:n-1)+depth(2:n))./2;

del_s_pos=(s_depths(1:ns-1)+s_depths(2:ns))./2;
del_s_depth=diff(s_depths);

s_depth_grid=interp1(del_s_pos,del_s_depth,del_pos);
good=1;


% get rid of data spaced more than twice the standard depths

del_sign=s_depth_grid*2.5-del_depth;



    %get rid of data too course
    
    if min(del_sign) < 0.
        good=0;
    end

    %get rid of data to deep
    
    if min(depth) > 30.
        good=0;
    end
    
    %get rid of data to shallow
    
    if max_depth < 300.
        good=0;
    end
    
% get rid of profiles with not enough data

% this was enetered as a override so that the low resolution xbts would not be removed

good=1;

end
