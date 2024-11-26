function [good_level,jj]=depth_spacing_per_int_2016_tuna(depth2,depth_int_top, depth_int_bottom,min_ratio_good)

% this function return good=1 if all spacing between measurements
% inbetween depth_int_bottom and depth_in_top are grater than the min_ratio
% of the spacing given in s_depth.

% profile has adiquate resolution

s_depths=[0 10 20 30 50:25:150 200:50:300 400:100:1500 1750:500:3000 4000 5000];

ns=length(s_depths);


depth=[0;depth2];
n=length(depth);
del_pos=(depth(1:n-1)+depth(2:n))./2;
del_depth=diff(depth);

% you have to set boundaries for the profile resolution
del_s_pos=[s_depths(1),(s_depths(1:ns-1)+s_depths(2:ns))./2,s_depths(end)];
del_s_depth=diff(s_depths);
del_s_depth=[del_s_depth(1),del_s_depth,del_s_depth(end)];
s_depth_grid=interp1(del_s_pos,del_s_depth,del_pos);


per_space=s_depth_grid./del_depth;
per_space=[per_space;0];
good=(per_space >= min_ratio_good);

pos_top=find((depth-depth_int_top)<=0, 1, 'last' );
pos_bottom=find((depth-depth_int_bottom)<0, 1, 'last' );

good=good(pos_top:pos_bottom);

good_level=~ismember(0,good);
if pos_top~=1
    jj=(pos_top-1:pos_bottom);
    
else
    jj=(pos_top:pos_bottom);
end
end
