function pos_off_coast=find_off_coast(LON,LAT,topo_coast)
pos_coast=isfinite(topo_coast);
lon_coast=LON(pos_coast);
lat_coast=LAT(pos_coast);

lon_coast=lon_coast(:);
lat_coast=lat_coast(:);

ncoast=length(lon_coast);
LON2=LON;
LON2(LON2>180)=LON2(LON2>180)-360;
pos_off_coast=LON2*0;
for icoast=1:ncoast

    lonp=lon_coast(icoast);
    latp=lat_coast(icoast);
    if lonp>30 & lonp<300
        distcoast=sqrt((LON-lonp).^2+(LAT-latp).^2);
        good_junk=distcoast<2;
    else
        if lonp>300
            lonp=lonp-360;
        end
        distcoast=sqrt((LON2-lonp).^2+(LAT-latp).^2);
        good_junk=distcoast<2;
    end

    pos_off_coast=pos_off_coast|good_junk;

end