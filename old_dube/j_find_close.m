function [good_place]=j_find_close(coords,lon_cast,lat_cast,del_deg) 

 size_coords=size(coords);

        if (size_coords(1) >=2) 
            
        del_lon=abs(coords(:,1)-lon_cast);
        del_lat=abs(coords(:,2)-lat_cast);
        
     % This is puts the casts into between 1-180
    
     
     
     
        big_del_lon=find(del_lon > 180);
     
        if length(big_del_lon) > 0 
            del_lon(big_del_lon)=abs(del_lon(big_del_lon)-360);
        end
     
       % This makes it so del lon is between 0-180
       
       big_del_lon=find(del_lon > 180);
       
       
        
        distance=sqrt((del_lon).^2+(del_lat).^2);
 
 
 
        good_place=find(distance <= del_deg);
 
      
        else
            good_place=[];
end %else
        
    
    