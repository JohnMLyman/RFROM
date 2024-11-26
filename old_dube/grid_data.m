function [data_out,error_map]=grid_data,data,data_coords,time,lon_grid,lat_grid
%this code will grid data arrording to Willis 2004, see page 183 of
%   Wunsch the ocean circulation inverse problem, grids three different parms

%  
%        INPUTS
%  data(np,3) missing values marked as NaN.
%  data_coords (np,2) the position in lon,lat of the data
%  time(np) is the normalized time in days (ie. the time of the grided output is time=0)
%    it save on time only pass times with in a window of the original time)
%  lon_grid (nlon) the longitudes of the outputted grid
%  lat_grid (nlat) the latitudes of the outputted grid .
%  period  the period in days of the temperol scale,
%    it is used in computing the amout of noise used in the
%     obsective mapping
% large_scale is the scale of the

%      OUTPUTS
%  data_out(nlon,nlat,3) the grided data set
%  error_map(nlon,nlat) the error computed from the coverences, it is not scalled!


%if grid is not selected than grid on a 1 degree grid


%This part sets the defaults 1x1 grid by 365 days.



large_scale=8.
small_scale=.9
lon_grid=[0:359]-180;
lat_grid=[0:179]-90;
%time_scale is in days.
time_scale=30.;


coords=complex(data_coords(:,1),data_coords(:,2));

s=size(data);
nlon=length(lon_grid);
nlat=length(lat_grid);


np=s(1);



data_out=ones(nlon,nlat,3)*NaN;
error_map=ones(nlon,nlat)*NaN;

for ilat=1:nlat
for ilon=1:nlon
%print,ilon,ilat
    grid_position=complex(lon_grid(ilon),lat_grid(ilat));

    junk_coords=coords;

% make the data inversion on the 300 closest point plus 50 with in 10 degrees
%   of the grid point

% controll for wrap around

    pos_positive=find(float(grid_position) < -150 & float(junk_coords) >= 150);
    cpos=length(pos_positive);
    pos_negitive=find(float(grid_position) > 150 & float(junk_coords) <= -150);
    cneg=length(pos_negitive);

    if cpos ~= 0 
        junk_coords(pos_positive)=junk_coords(pos_positive)-360;
    end
    
    if cneg ~= 0
            junk_coords(pos_negitive)=junk_coords(pos_negitive)+360;
    end

    data_dist=abs(junk_coords-grid_position);

% take data with in 10 degrees



    good_pos=find(((data_dist < 10.) and (finite(data(:,1)) == 1)));
    c_good=length(c_good);


weigth_pos=sqrt((data_dist/.small_scale).^2+(time./time_scale).^2);
% now subset the data and sort it

% take all data in the window.
    if c_good >= 2 
        
        [trash,sort_pos]=sort(weigth_pos(good_pos));
       pos_order=good_pos(sort_pos);

       data_dist=data_dist(pos_order);
       junk_time=time(pos_order);
       junk_data=data(pos_order,*);
       junk_coords=junk_coords(pos_order);

    %junk_junk_coords=junk_coords
    %junk_junk_data=junk_data
    %junk_junk_data_dist=data_dist

% "Randomly" select from points with in 10 degrees of the points

       good_over=[1:50];

       if c_good > 350 
         num_over=c_good -300;
         ran_pos=round((num_over-1)*rand(50))


    ran_pos=ran_pos(unique(ran_pos,sort(ran_pos)));
    n_ran=length(ran_pos);

% get rid of duplicate points
    while n_ran < 50
       ran_pos=[ran_pos,round ((num_over-1)*randomu(seed,50-n_ran)) ]
       ran_pos=ran_pos(uniq(ran_pos,sort(ran_pos)))
       n_ran=length(ran_pos);
    end

         over_pos=indgen(num_over)+300;
     good_over=over_pos(ran_pos);


         junk_data=[junk_data(0:299,*),junk_data(good_over,*)]
         junk_coords=[junk_coords(0:299),junk_coords(good_over)]

         data_dist=[data_dist(0:299),data_dist(good_over)]

         c_good=350;
       end

%make the coverience function for the data that are near the grid point

    junk_pos=findgen(c_good)
    data_data=fltarr(c_good)+1.
    data_data_dist=abs(junk_coords##data_data -junk_coords#data_data)
    data_data_time=abs(junk_time##data_data -junk_time#data_data)
    


    cov = (exp(-data_data_dist/large_scale) + 3.4 * exp(-((data_data_dist/small_scale)^2+(data_data_time/time_scale)^2)))/4.4

%add noise to the diagonal according to Zang and Wunsch 2001 spectrum.

       noise_zang=2.2


        cov(junk_pos,junk_pos)=cov(junk_pos,junk_pos)+noise_zang
        %coveriance matrix of the data and the grid

        cov_grid= (exp(-data_dist/large_scale) + 3.4 * exp(-((data_dist/small_scale)^2+(junk_time/time_scale)^2)))/4.4
%invert the coverance matrix

    %add the coverience to the inverse

    s_junk_data=size(junk_data)

    y_junk=fltarr(s_junk_data(1),s_junk_data(2)+1)
    y_junk(*,0:2)=junk_data
    y_junk(*,3)=cov_grid

    cov_inv_dot_data=LA_LINEAR_EQUATION(cov,transpose(y_junk))





%plot,data_dist,cov_grid,psym=4
%wait,51
    %cov_grid= cov_grid +

    cov_inv_dot_data_0=reform(cov_inv_dot_data(0,*))
     cov_inv_dot_data_1=reform(cov_inv_dot_data(1,*))
     cov_inv_dot_data_2=reform(cov_inv_dot_data(2,*))
     cov_inv_dot_data_3=reform(cov_inv_dot_data(3,*))

    data_out(ilon,ilat,0)=cov_grid##transpose(cov_inv_dot_data_0)
    data_out(ilon,ilat,1)=cov_grid##transpose(cov_inv_dot_data_1)
    data_out(ilon,ilat,2)=cov_grid##transpose(cov_inv_dot_data_2)
    error_map(ilon,ilat)=noise_zang-cov_grid##transpose(cov_inv_dot_data_3)


    end
    end


    end




return
end
