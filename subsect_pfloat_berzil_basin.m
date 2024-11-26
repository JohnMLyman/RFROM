
load('C:\Users\lyman\Downloads\pfloat_sal_greg_jan_2021_QC (1).mat')

lon=coords(:,1);
lon(lon<0)=lon(lon<0)+360;
lat=coords(:,2);
[bsn_num]=find_sarah_basin_num(lon,lat);

good=find(bsn_num==24);

coords=coords(good,:);
cycle=cycle(good);
dac_centre=dac_centre(good,:);
data=data(good,:);
date=date(good,:);
date_qc=date_qc(good,:);
id=id(good);
mdep=mdep(good);
npts=npts(good);
pos_qc=pos_qc(good);
press_mis_flag=press_mis_flag(good);
qual=qual(good);
time=time(good,:);
wmo_inst=wmo_inst(good,:);

save 'c:\data\pfloat_sal_greg_jan_2021_QC_barzil_basin.mat' coords ...
    cycle dac_centre data date date_qc id mdep npts pos_qc press_mis_flag ...
    qual time wmo_inst