clear

for junk3=1:10
n=200
x=rand(n,1)*1000;

y=rand(n,1)*1000;

for f=1:5
   test_weights
    GG(f)=sigma_diff;
    rr(f)=sigma_topex;
end


plot(rr./GG)
hold on
end