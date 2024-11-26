% must load sst and ssh data from  read_ssh_matfiles_compact_yearly

tgrid=[1993.5:.5:2021];

nyears=length(tgrid);

arwj=areavec(lon_tpx,lat_tpx);
ht_sst_out=nans(nlon_tpx,nlat_tpx,nyears);
ht_ssh_out=ht_sst_out;

[LON,LAT]=ndgrid(lon_tpx,lat_tpx);
[global_basins_aviso]=find_basin_paige(LON,LAT);
nbasin=length(global_basins_aviso);


basin_ssh_curve=nans(nbasin,nyears);
basin_sst_curve=nans(nbasin,nyears);

for itime=1:nyears
        jyear=tgrid(itime);
        jht_sst_out=mean(sst_total(:,:,time_aviso<jyear+.5&time_aviso>=jyear-.5),3,'omitnan').*arwj;
        jht_ssh_out=mean(ssh_total(:,:,time_aviso<jyear+.5&time_aviso>=jyear-.5),3,'omitnan').*arwj;

        ht_sst_out(:,:,itime)=jht_sst_out;
        ht_ssh_out(:,:,itime)=jht_ssh_out;
        for ibasin=1:nbasin
            pos_basin=global_basins_aviso(ibasin).pos;
            jcurve_sst=jht_sst_out;
            jcurve_sst(~pos_basin)=0;
            jcurve_sst=nansum(jcurve_sst,1);
            jcurve_sst=nansum(jcurve_sst,2);
            basin_sst_curve(ibasin,itime)=jcurve_sst;

            jcurve_ssh=jht_ssh_out;
            jcurve_ssh(~pos_basin)=0;
            jcurve_ssh=nansum(jcurve_ssh,1);
            jcurve_ssh=nansum(jcurve_ssh,2);
            basin_ssh_curve(ibasin,itime)=jcurve_ssh;




        end


end


sst_curve=ht_sst_out;
sst_curve=nansum(sst_curve,1);
sst_curve=squeeze(nansum(sst_curve,2));

ssh_curve=ht_ssh_out;
ssh_curve=nansum(ssh_curve,1);
ssh_curve=squeeze(nansum(ssh_curve,2));


