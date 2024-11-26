cd '/Volumes/Data/Globalhc/SAL/Floats'

ncload('htanom_under_1800_1_1950_2009.nc')


[hc_one_1800,one_mask_1800,topo_1800,vol_1800]=heat_curv_gen_nc_input_1800(one,lon,lat,time);



ncload('htanom_under_700_1950_2009.nc')


[hc_one_700,one_mask_700,topo_700,vol_700]=heat_curv_gen_nc_input_700(one,lon,lat,time);

ncload('htanom_under_top_1950_2009.nc')


[hc_one_top,one_mask_top,topo_top,vol_top]=heat_curv_gen_nc_input_top(one,lon,lat,time);

%%
plot(time,hc_one_top,'r')
hold on
plot(time,hc_one_700,'g')

plot(time,hc_one_1800,'m')
hc_com=hc_one_1800.*.15+hc_one_700.*.25+hc_one_top.*.6;


plot(time,hc_com,'k')
axis([1950 2026 0 1])

extra_mid=[2010.5:2013.5];


extra=[2014.5:2025.5];

part=(extra-extra(1)).^2;

part_mid=ones(1,length(extra_mid)).*hc_com(end);


part=(part./part(end)).*(1-hc_com(end)-.05)+hc_com(end);

plot([time' extra_mid extra],[hc_com part_mid part],'k')


plot([ extra_mid extra],[ part_mid part],'r')


total_hc=[hc_com part_mid part];
total_time=[time' extra_mid extra];

%%
figure



plot(time,hc_one_top,'r')
hold on
plot(time,hc_one_700,'g')

plot(time,hc_one_1800,'m')
hc_com_vol=(hc_one_1800.*vol_1800+hc_one_700.*vol_700+hc_one_top.*vol_top)./(vol_1800+vol_700+vol_top);


plot(time,hc_com_vol,'k')
axis([1950 2026 0 1])

extra_mid=[2010.5:2013.5];
del_ice=.025;

extra=[2014.5:2025.5];

part_vol=(extra-extra(1)).^2;

part_mid_vol=((extra_mid-extra_mid(1)).*[del_ice]./(extra_mid(end)-extra_mid(1)))+hc_com_vol(end)+del_ice/(extra_mid(end)-extra_mid(1));


part_vol=(part_vol./part_vol(end)).*(1-part_mid_vol(end)-.05)+part_mid_vol(end);

plot([time' extra_mid extra],[hc_com_vol part_mid_vol part_vol],'k')


plot([ extra_mid extra],[ part_mid_vol part_vol],'r')


total_hc_vol=[hc_com_vol part_mid_vol part_vol];
total_time_vol=[time' extra_mid extra];



figure


plot(total_time,total_hc_vol,'k')
axis([1950 2025 0 1 ]);
hold on
