function [temp,time_aviso_total]=load_monthly_all_temp(layer_bounds,path_mat_nc,...
    tree_model_file_name_combined_temp,ilayer,time_aviso_map)


% this code is set up to load in a year plus data at a time
path_mat_nc_temp=[path_mat_nc,'temp\matlab\all\'];
% tree_model_file_name_season_temp=[tree_prefix_temp,'_yearly_overlap_seasonal'];

 layer_name=[num2str(layer_bounds(ilayer-1)),'_',num2str(layer_bounds(ilayer))]
   
    
    tree_file_name_temp=[tree_model_file_name_combined_temp,'_',layer_name];

temp=[];
time_aviso_total=[];
year_start=floor(time_aviso_map(1));
year_end=floor(time_aviso_map(end));
for iyear=year_start:year_end
        mon_start=1;
        mon_end=12;
        if iyear==year_start
            mon_start=floor((time_aviso_map(1)-year_start)*12);
            mon_end=12;
        elseif iyear==year_end
            mon_start=1;
            mon_end=ceil((time_aviso_map(end)-year_end).*12)+1;
        end

       for imonth=mon_start:mon_end

          

           file_name_mat_nc_temp=[tree_file_name_temp,'_',num2str(iyear),'_',num2str(imonth)];
           file_in=[path_mat_nc_temp,file_name_mat_nc_temp,'.mat'];
%            file_in
           if exist(file_in,'file')
              
%               file_in

               % convert to single 

               
               load(file_in,'temp_estimate_mon','time_aviso','lon_tpx','lat_tpx')
               temp=cat(3,temp,temp_estimate_mon);
               time_aviso_total=cat(2,time_aviso_total,time_aviso);
           end

       end
 end
% aviso maps are every 7-days one day was add besuase of rounding error
% that occures with going from double to signle persion and back agianS
time_aviso_total=double(time_aviso_total);
one_day=1/365.;
good_temp=time_aviso_total >=time_aviso_map(1)-one_day & time_aviso_total<=time_aviso_map(end)+one_day; 
time_aviso_total=double(time_aviso_total(good_temp));
temp=double(temp(:,:,good_temp));

