current_dir=cd;
cd('/Volumes/ThunderBay/Data/Globalhc/SAL/Floats/argo');

d=sdir(['den_den*.mat']);
% this is the radius that is looked at

del_deg=3;

% this is the number of quatorials that are thought to be good
nqual=3;

% the maxium depth considered to be the surface

max_depth=30;
for i=1:length(d)
    
   
    file_name=d(i).name
    wmo_number=str2num(file_name(13:16));
    
  
    
      [coords_tot,fpress_tot,sal_tot, temp_tot,wmo_tot]= load_data_wmo_square_floats_surface(wmo_number,del_deg)


        
    %
   
    
    good_locations=find(wmo_tot == wmo_number );
    
    %this section will do the qc based on nearest naighbor
    
    n_good=length(good_locations);
    
    bad_wod=[];
    bad_total=[];
    s_floats=size(sal_tot);
   %s_wod=size(sal_0_wod);
    nd=s_floats(2);
    
    for iqc=1:n_good
       
        
        %find the float casts with in del_deg 
        
        
        isquare=good_locations(iqc);
        
        lon_square=coords_tot(isquare,1);
        lat_square=coords_tot(isquare,2);
        
        % find where the from the World Ocean Database
        %[good_place_wod]=j_find_close(coords_wod,lon_square,lat_square,del_deg);
        
        % find other floats are near this cast
        
        [good_place_floats]=j_find_close(coords_tot,lon_square,lat_square,del_deg);
        
       
        
        %%%%%%%
        
        
        
        this_cast=find(good_place_floats == isquare);
 

        press=fpress_tot(good_place_floats,:);
        sal=sal_tot(good_place_floats,:);
        temp=temp_tot(good_place_floats,:);
    
  
        
        coords=coords_tot(good_place_floats,:);
        
    
       
  
 
        

        ii_total=[];
        


   

            den_temp=temp(:,1);
            den_sal=sal(:,1); 
            den_press=press(:,1);
     
    % only take profiles at the surface        
     
    too_deep=find(den_press >= max_depth);
        den_sal(too_deep)=NaN;
        den_temp(too_deep)=NaN;
    %only look at profiles where the mean pressure is less then 1000 dbar
        if (length(find(isfinite(den_temp) ==1 )) >=2 )
            
            %find the bad places using all the data
            [ind_temp]=ind_out_qua(den_temp,nqual);
            [ind_sal]=ind_out_qua(den_sal,nqual);
            [ind_press]=ind_out_qua(den_press,nqual);
            ii_total=[ii_total,ind_sal',ind_temp',ind_press'];
       end % if
    


    % get rid of profiles with more than 5% missing


    if length(find(ii_total == this_cast)) > 0 | isfinite(den_temp(this_cast,1)) == 0
        bad_total=[bad_total',iqc]';
        per_done=100.*iqc/n_good
        per_bad_total=100.*length(bad_total)/iqc
    end
    
clear  ii_total
    end %end of WMO sqruare
    
    
     

eval(['save ind_den_den_no_f',num2str(wmo_number),'.mat bad_total per_bad_total '])


   clear coords_tot fpress_tot sal_tot temp_tot wmo_tot
end %end of WMO files



cd(current_dir);
