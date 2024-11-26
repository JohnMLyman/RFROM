
wmo=[];
d=dir('*.nc');
for ifile=1:length(d)
wmoj=str2num(ncread(d(ifile).name,'WMO_INST_TYPE')');
wmo=[unique(wmoj);wmo];
end

figure(1)
clf
plot(wmoj,'.')
length(find(wmoj==862))