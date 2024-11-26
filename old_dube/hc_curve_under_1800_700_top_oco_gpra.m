load greg_gpra_oco
%%
figure

total_vol=vol_1800+vol_700+vol_top;

plot(time,(hc_one_top.*vol_top+hc_one_700*vol_700+hc_one_1800.*vol_1800)./total_vol,'r')
hold on
plot(time,(hc_one_700*vol_700+hc_one_1800.*vol_1800)./total_vol,'m')

plot(time,(hc_one_1800.*vol_1800)./total_vol,'b')

axis([1950 2009 0 1])
