function [coords_tot, density_surface, dg_hi_tot, dg_lo_tot, dt_tot, fpress_tot, gam_tot, id_tot, ...
    mdep_tot, npts_tot, per_bad_grad_tot, press_0_tot, press_bot_0_tot, press_bot_gam_tot, press_gam_tot, ...
    press_top_0_tot, press_top_gam_tot, qual_tot, ratio_bad_tot, sal_tot, sal_0_tot, sal_gam_tot, temp_tot,...
    temp_0_tot, temp_gam_tot, time_tot,wmo_tot]= ...
        load_data_wmo_square_floats_cell(wmo,del_deg)


% find the data file names near to the others.
density_surface=[];
coords_tot=[];
dg_hi_tot=[];
dg_lo_tot=[];
dt_tot=[];
fpress_tot=[];
gam_tot=[];
id_tot=[];
mdep_tot=[];
npts_tot=[];


press_bot_0_tot=[];
press_bot_gam_tot=[];
press_gam_tot=[];
press_top_0_tot=[];
press_top_gam_tot=[];

press_gam_tot=[];
sal_gam_tot=[];
temp_gam_tot=[];

press_0_tot=[];
sal_0_tot=[];
temp_0_tot=[];

sal_tot=[];
temp_tot=[];

ratio_bad_tot=[];
wmo_tot=[];
time_tot=[];
qual_tot=[];
per_bad_grad_tot=[];

[wmo_squares,min_lon,max_lon,min_lat,max_lat]=find_wmo_square_floats_cell(wmo,del_deg);
min_lon;
max_lon;
min_lat;
max_lat;
current_dir=cd;
%cd('../../SAL/WOD05/junk/');

for i=1:length(wmo_squares)
    
   
    
    

      if exist(['greg_f',num2str(wmo_squares(i)),'.mat'])
    eval(['load greg_f',num2str(wmo_squares(i)),'.mat']);
    wmo_squares(i)
    lon_junk=coords(:,1);
    lat_junk=coords(:,2);
    b=0;
    % this part of the code takes care of the two cases that are at the
    % boundary
    
    if (max_lon <= -180+del_deg+1) & (min_lon >= 170-del_deg-1)
        % switch to 0-360 frame work
        
       neg_pos=find(lon_junk <= 0);
       if length(neg_pos)>0
           lon_junk(neg_pos)=lon_junk(neg_pos)+360;
       end
       max_lon2=max_lon+360;
       b=1;
    end
    
    if (min_lon >= 180-del_deg-1) & (max_lon <= -170+del_deg+1)
        
        % switch to 0-360 frame work
       
       neg_pos=find(lon_junk <= 0);
       if length(neg_pos)>0
           lon_junk(neg_pos)=lon_junk(neg_pos)+360;
       end
       max_lon2=max_lon+360;
       
       b=1;
    end
    
    % is this section of the box in radius of the position?
    
    max_lon3=max_lon;
    if b == 1 
        max_lon3=max_lon2;
    end
    
    good_locations = find((lon_junk >= min_lon) & (lon_junk <= max_lon3) & (lat_junk <= max_lat) & (lat_junk >= min_lat) );
  
   % good_locations=find(finite(lon_junk));
    clear lon_junk lat_junk
    
    np=length(good_locations);
    
    
    
    
    if np > 0 
        
      
    coords=coords(good_locations,:);
    dg_hi=dg_hi(good_locations,:);
    dg_lo=dg_lo(good_locations,:);
    dt=dt(good_locations,:);
    fpress=fpress(good_locations,:);
    gam=gam(good_locations,:);
    id=id(good_locations);
    mdep=mdep(good_locations);
    npts=npts(good_locations);
    per_bad_grad=per_bad_grad;
    ratio_bad=ratio_bad(good_locations)';
    
    press_bot_gam=press_bot_gam(good_locations);
    press_top_gam=press_top_gam(good_locations);
   
    press_bot_0=press_bot_0(good_locations);
    press_top_0=press_top_0(good_locations);
   
    sal=sal(good_locations,:);
    temp=temp(good_locations,:);
    
    press_gam=press_gam(good_locations,:);
    sal_gam=sal_gam(good_locations,:);
    temp_gam=temp_gam(good_locations,:);
    
    press_0=press_0(good_locations,:);
    sal_0=sal_0(good_locations,:);
    temp_0=temp_0(good_locations,:);
    
    time=time(good_locations);
        
    coords_tot=[coords_tot',coords']';
    dg_lo_tot=[dg_lo_tot',dg_lo']';
    dg_lo_tot=[dg_lo_tot',dg_lo']';
    fpress_tot=[fpress_tot',fpress']';
    dt_tot=[dt_tot',dt']';
    gam_tot=[gam_tot',gam']';
    
  %  id_tot=[id_tot',id]';
  id_tot=[];
    qual_tot=[qual_tot',qual]';
    
    mdep_tot=[mdep_tot',mdep']';
    npts_tot=[npts_tot',npts']';
    
    
    wmo_tot=[wmo_tot',ones(np,1)'*wmo_squares(i)]';
    per_bad_grad_tot=[per_bad_grad_tot',ones(np,1)'*per_bad_grad]';
    ratio_bad_tot=[ratio_bad_tot',ratio_bad']';
    
    press_bot_0_tot=[press_bot_0_tot',press_bot_0']';
    press_top_0_tot=[press_top_0_tot',press_top_0']';
    
    press_bot_gam_tot=[press_bot_gam_tot',press_bot_gam']';
    press_top_gam_tot=[press_top_gam_tot',press_top_gam']';
    
    press_0_tot=[press_0_tot',press_0']';
    sal_0_tot=[sal_0_tot',sal_0']';
    temp_0_tot=[temp_0_tot',temp_0']';
    
    press_gam_tot=[press_gam_tot',press_gam']';
    sal_gam_tot=[sal_gam_tot',sal_gam']';
    temp_gam_tot=[temp_gam_tot',temp_gam']';
    
    sal_tot=[sal_tot',sal']';
    temp_tot=[temp_tot',temp']';
    
    
    time_tot=[time_tot',time']';
    
    
    
   
    
    
    
    end
    end
    
end


cd(current_dir);
clear coords dg_hi dg_lo  dt ...
    fpress  gam  id  mdep  npts  per_bad_grad  press_0  press_bot_0 ...
    press_bot_gam  press_gam  press_top_0  press_top_gam  qual  ratio_bad ...
    sal  sal_0  sal_gam  temp  temp_0  temp_gam  time
% % % this section gets rid of duplicates.
% % 
% % time_tot(find(time_tot >= 30))=NaN;
% % 
% % time_place=type_data*200*1000*100000+(coords(:,1)+181+(coords(:,2)+91)*1000)*100000 ... 
% %     +(dt(:,1)-1800)*100+dt(:,2)+dt(:,3)/100+time./10000;


