function [coords_tot,fpress_tot,sal_tot, temp_tot,wmo_tot]= load_data_wmo_square_floats_surface(wmo,del_deg)


% find the data file names near to the others.
coords_tot=[];
fpress_tot=[];

sal_tot=[];
temp_tot=[];

wmo_tot=[];

[wmo_squares,min_lon,max_lon,min_lat,max_lat]=find_wmo_square_floats_surface(wmo,del_deg);
min_lon;
max_lon;
min_lat;
max_lat;


for i=1:length(wmo_squares)
    
   
    
    

      if exist(['den_den_no_f',num2str(wmo_squares(i)),'.mat'])
    eval(['load den_den_no_f',num2str(wmo_squares(i)),'.mat']);
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
    fpress=fpress(good_locations,:);
    
   
   
    sal=sal(good_locations,:);
    temp=temp(good_locations,:);
    
    
    
        
    coords_tot=[coords_tot',coords']';
    fpress_tot=[fpress_tot',fpress']';
    
  %  id_tot=[id_tot',id]';
    
    
    
    wmo_tot=[wmo_tot',ones(np,1)'*wmo_squares(i)]';
    
    
    sal_tot=[sal_tot',sal']';
    temp_tot=[temp_tot',temp']';
    
    
    
    
    
   
    
    
    
    end
    end
    
end


clear coords  ...
    fpress  ...
    sal  temp 
% % % this section gets rid of duplicates.
% % 
% % time_tot(find(time_tot >= 30))=NaN;
% % 
% % time_place=type_data*200*1000*100000+(coords(:,1)+181+(coords(:,2)+91)*1000)*100000 ... 
% %     +(dt(:,1)-1800)*100+dt(:,2)+dt(:,3)/100+time./10000;


