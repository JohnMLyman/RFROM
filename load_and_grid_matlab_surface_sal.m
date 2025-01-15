%load_and_grid_matlab
function [iyear]=load_and_grid_matlab_surface_sal(file_path,file_name,lat_grid,lon_grid,time_grid)

eval(['load ',file_path,file_name,'.mat surface_sal_surface dt_surface coords_surface '])

yr=dt_surface(:,1)+(dt_surface(:,2)-1)/12+dt_surface(:,3)/365.;
coords=coords_surface;

ntime=length(time_grid);
nlon=length(lon_grid);
nlat=length(lat_grid);

sal_out=ones(nlon,nlat,ntime)*NaN;
one_out=sal_out;






tic,for iyear=1:ntime
    'Surface Salinity'
    iyear
    time_grid(iyear)
    

    max_year=(time_grid(iyear))+.5;
    min_year=(time_grid(iyear))-.5;
    good_data=find((yr > min_year) & (yr <= max_year));
    ngood=length(good_data);
    one_map=ones(1,ngood);
    data=ones(ngood,2)*NaN;
    
    data(:,1)=surface_sal_surface(good_data);
    data(:,2)=one_map;
    
    %time_junk=yr(good_data);
    cds_junk=coords(good_data,:);
    toc,'before objective map'
    [data_grid]=objective_map_annual_sal(lon_grid,lat_grid,data,cds_junk);
    toc,'out of objective map'
    sal_out(:,:,iyear)=data_grid(:,:,1);
    one_out(:,:,iyear)=data_grid(:,:,2);
      
      clear data_grid data
      toc,'next step'
end

time=time_grid';
sal=sal_out;

one=one_out;
lon=lon_grid';
lat=lat_grid';
file_name_out=[file_path,file_name,'_',num2str(time_grid(1)-.5),'_',num2str(time_grid(end)-.5)];
eval(['save ',file_name_out,'_6_deg.mat sal one lon lat time'])


    
