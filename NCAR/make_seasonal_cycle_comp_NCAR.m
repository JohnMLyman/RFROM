function [amp_annual_total,phase_annual_total,amp_semi_total,phase_semi_total,...
    amp_third_total,phase_third_total,slope_total,mean_total,model_err_total]=...
    make_seasonal_cycle_comp_NCAR(yr,ohca)

% This code makes the synthetic SST anomaly files that are used in the in
% the rest of the code.  They are made each time, so that the seasonal
% cycle is computed so the seasonal cycle removed from these files is the
% same as that removed from ssh and heat
tic
percent_good_fit=.8;
s_ohca=size(ohca);
    


nlon_tpx=s_ohca(1);
nlat_tpx=s_ohca(2);

nlayers=s_ohca(3);
ntime=s_ohca(4);




%    
% now fit a seasonal cycle and save it


    
amp_annual_total=nans(nlon_tpx,nlat_tpx,nlayers);
amp_semi_total=amp_annual_total;
amp_third_total=amp_annual_total;

phase_annual_total=amp_annual_total;
phase_semi_total=amp_annual_total;
phase_third_total=amp_annual_total;

slope_total=amp_annual_total;
mean_total=amp_annual_total;
model_err_total=amp_annual_total;

parfor ilat=1:nlat_tpx 
    for ilon=1:nlon_tpx 
        for ilayer=1:nlayers
         jyin=squeeze(ohca(ilon,ilat,ilayer,:));
         jtime=yr;
         good=isfinite(jyin);
         jyin=jyin(good)';
         jtime=jtime(good);

         if length(jtime)>percent_good_fit*ntime % only fit a seasonal cycle when there is 50% coverage

             [~,amp_annual,phase_annual,amp_semi,phase_semi,amp_third,phase_third,slope_fit,mean_fit,model_err]=...
                 j_fit_annual_tree(jtime,jyin);
             amp_annual_total(ilon,ilat,ilayer)=amp_annual;
             amp_semi_total(ilon,ilat,ilayer)=amp_semi;
             amp_third_total(ilon,ilat,ilayer)=amp_third;
             
             phase_annual_total(ilon,ilat,ilayer)=phase_annual;
             phase_semi_total(ilon,ilat,ilayer)=phase_semi;
             phase_third_total(ilon,ilat,ilayer)=phase_third;

             slope_total(ilon,ilat,ilayer)=slope_fit;
             mean_total(ilon,ilat,ilayer)=mean_fit;
%              model_err_total(ilon,ilat,ilayer)=model_err;
         end
         end
%                  
    end
end


% save([file_name_ohca],...
%     'amp_annual_total','phase_annual_total','amp_semi_total','phase_semi_total',...
%     'amp_third_total','phase_third_total','slope_total','mean_total',...
%     'yr','lon_tpx','lat_tpx')

toc./60

end



function parsave_sstanom(filename,anom,time,lon,lat)

    if exist(filename,'file')
        delete(filename)
    end
    nlon=length(lon);
    nlat=length(lat);
    ntime=length(time);
    mySchema.Name   = '/';
%     mySchema.Format = "classic";
    mySchema.Dimensions(1).Name   = 'lon';
    mySchema.Dimensions(1).Length = nlon;
    mySchema.Dimensions(2).Name   = 'lat';
    mySchema.Dimensions(2).Length = nlat;
    mySchema.Dimensions(3).Name   = 'time';
    mySchema.Dimensions(3).Length = ntime;
    
    map_dimen(1).Name='lon';
    map_dimen(2).Name='lat';
    map_dimen(3).Name='time';
    map_dimen(1).Length=nlon;
    map_dimen(2).Length=nlat;
    map_dimen(3).Length=ntime;
    

     lon_att(1).Name='units';
    lon_att(1).Value='degrees_east';
    lon_att(2).Name='Description';
    lon_att(2).Value='Longitude (positive east)';
    lon_att(3).Name='standard_name';
    lon_att(3).Value='longitude';
    
    mySchema.Variables(1).Name='lon';
    mySchema.Variables(1).Dimensions=map_dimen(1);
    mySchema.Variables(1).Datatype='single';
    mySchema.Variables(1).FillValue='disable';
    
    mySchema.Variables(2).Name='lat';
    mySchema.Variables(2).Dimensions=map_dimen(2);
    mySchema.Variables(2).Datatype='single';
    mySchema.Variables(2).FillValue='disable';

    mySchema.Variables(3).Name='time';
    mySchema.Variables(3).Dimensions=map_dimen(3);
    mySchema.Variables(3).Datatype='single';
    mySchema.Variables(3).FillValue='disable';

    mySchema.Variables(4).Name='anom';
    mySchema.Variables(4).Dimensions=map_dimen;
    mySchema.Variables(4).Datatype='double';
    mySchema.Variables(4).FillValue='disable';

    ncwriteschema(filename, mySchema);
    ncwrite(filename,'lon',lon,[1]);
    ncwrite(filename,'lat',lat,[1]);
    ncwrite(filename,'time',time,[1]);
    ncwrite(filename,'anom',anom,[1 1 1]);


end
