current_dir=cd;
load('/Volumes/Data/Globalhc/HC/hdata_oco_realtime_jan_clim_2011_2012_700.mat')

nprofiles=length(htanom);
;
% this is the radius that is looked at

del_deg=3;

% this is the number of quatorials that are thought to be good
nqual=3;

% the maxium depth considered to be the surface
 bad_total=nans(1,nprofiles);
for i=1:nprofiles
    
   
        %find the float casts with in del_deg 
        
        
        lon_square=coords(i,1);
        lat_square=coords(i,2);
        
        % find where the from the World Ocean Database
        %[good_place_wod]=j_find_close(coords_wod,lon_square,lat_square,del_deg);
        
        % find other floats are near this cast
        mcds=ones(1,2);
        pos_ge_170=find(coords(:,1)>=170);
        pos_le_170=find(coords(:,1)<=-170);


        mcds(1,1)=lon_square;
        mcds(1,2)=lat_square;
       cds=coords;
%find the nearest points with in 10 degress
      if mcds(1,1)<=-170,cds(pos_ge_170,1)=cds(pos_ge_170,1)-360;end
      if mcds(1,1)>=170,cds(pos_le_170,1)=cds(pos_le_170,1)+360;end
      ll_junk=find(abs(mcds(1,1)-cds(:,1)).*cosd(mcds(1,2))<=10 & ...
		abs(mcds(1,2)-cds(:,2))<=10);
        % find the nearest nabors
        [good_place_junk]=j_find_close(cds(ll_junk,:),lon_square,lat_square,del_deg);
        good_place_floats=ll_junk(good_place_junk);
       
        
        %%%%%%%
        
        
        
        this_cast=find(good_place_floats == i);
 

        ht_sq=htanom(good_place_floats);
        coords_sq=coords(good_place_floats,:);
        
    
       
  
 

   

    %only look at profiles where the mean pressure is less then 1000 dbar
        if (length(find(isfinite(ht_sq) ==1 )) >=2 )
            
            %find the bad places using all the data
            [ind_temp]=ind_out_qua(ht_sq,nqual);
            
       end % if
    


    % get rid of profiles with more than 5% missing


    if length(find(ind_temp == this_cast)) > 0 || isfinite(ht_sq(this_cast,1)) == 0
        bad_total(i)=i;
        
       
    end
    

    
    
     

end %end of WMO files



cd(current_dir);
