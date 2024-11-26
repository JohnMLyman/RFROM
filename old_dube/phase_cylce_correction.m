% correct phase
neg=find(amp_annual < 0);
amp2=amp_annual;
amp2=abs(amp2);
p2=phase_annual;
p2(neg)=p2(neg)+pi;



small=find(p2 < 0);

p2(small)=p2(small)+2.*pi;


% correct phase
neg=find(amp_semi < 0);
amp2=amp_semi;
amp2=abs(amp2);
ps2=phase_semi;
ps2(neg)=ps2(neg)+pi;



small=find(ps2 < 0);

ps2(small)=ps2(small)+2.*pi;