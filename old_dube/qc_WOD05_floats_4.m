 d=sdir(['grad_den_0_grid_aden_den_no_*.mat']);
% this is the radius that is looked at

del_deg=3;

% this is the number of quatorials that are thought to be good
nqual=3;

for i=366:400
    
    %eval(['load /home/shoko2/wills/globalhc_dirs/Globalhc/SAL/WOD05/',d(i).name])
    
    %this is a liitle part that I think gets rid of an error in the code
    %that worte the matliab files.
    
%     np=length(mdep);
%     np_npts=length(npts);
%     npts=npts(np_npts-np+1:end);
%     
    file_name=d(i).name
    
     
    eval(['load ',file_name]);
    
    if length(coords)>= 1
        
    wmo_number=str2num(file_name(30:33));
    
   [coords_wod,dt_wod,mdep_wod,npts_wod,press_0_wod, ... 
       sal_0_wod,temp_0_wod,time_wod,type_wod,wmo_wod,density_surface]= ...
        load_data_wmo_square_floats_wod(wmo_number,del_deg);
    
      [coords_tot, density_surface, dg_hi_tot, dg_lo_tot, dt_tot, fpress_tot, gam_tot, id_tot, ...
    mdep_tot, npts_tot, per_bad_grad_tot, press_0_tot, press_bot_0_tot, press_bot_gam_tot, press_gam_tot, ...
    press_top_0_tot, press_top_gam_tot, qual_tot, ratio_bad_tot, sal_tot, sal_0_tot, sal_gam_tot, temp_tot,...
    temp_0_tot, temp_gam_tot, time_tot,wmo_tot]= ...
        load_data_wmo_square_floats(wmo_number,del_deg);  
        
    % type == 1:OSD(low res CTD XCTD, ect); 2:CTD (High resolution CTD); 3:PFL(profiling floats)
    %   4:UOR(undulating Oceangraphic Recorder); 5:GLD(Glider)
   
    
    good_locations=find(wmo_tot == wmo_number );
    
    %this section will do the qc based on nearest naighbor
    
    n_good=length(good_locations);
    
    bad_wod=[];
    bad_total=[];
    s_floats=size(sal_0_tot);
   %s_wod=size(sal_0_wod);
    nd=s_floats(2);
    
    for iqc=1:n_good
       
        
        %find the float casts with in del_deg 
        
        
        isquare=good_locations(iqc);
        
        lon_square=coords_tot(isquare,1);
        lat_square=coords_tot(isquare,2);
        
        % find where the from the World Ocean Database
        [good_place_wod]=j_find_close(coords_wod,lon_square,lat_square,del_deg);
        
        % find other floats are near this cast
        
        [good_place_floats]=j_find_close(coords_tot,lon_square,lat_square,del_deg);
        
       
        
        %%%%%%%
        
        
        
        this_cast=find(good_place_floats == isquare);
 

        pos_floats=[1:length(good_place_floats)];
        pos_wod=[1+length(good_place_floats):length(good_place_floats)+length(good_place_wod)];
        
        coords=[coords_tot(good_place_floats,:)',coords_wod(good_place_wod,:)']';
        dt=[dt_tot(good_place_floats,:)',dt_wod(good_place_wod,:)']';
        
    
    
        press_0=[press_0_tot(good_place_floats,:)',press_0_wod(good_place_wod,:)']';
        sal_0=[sal_0_tot(good_place_floats,:)',sal_0_wod(good_place_wod,:)']';
        temp_0=[temp_0_tot(good_place_floats,:)',temp_0_wod(good_place_wod,:)']';
    
  
 
        

        ii_total=[];
        ii_wod=[];



    for iden=1:nd
            % use nuetral density when it is aviable.

%         if length(find(finite(temp_gam(:,iden))==1)) >= 2
%             den_temp=temp_gam(:,iden);
%             den_sal=sal_gam(:,iden);
%             den_press=press_gam(:,iden);
%             else
            den_temp=temp_0(:,iden);
            den_sal=sal_0(:,iden); 
            den_press=press_0(:,iden);
%         end
    %only look at profiles where the mean pressure is less then 1000 dbar
        if (length(find(finite(den_temp) ==1 )) >=2 & nanmean(den_press) > 500)
            
            %find the bad places using all the data
            [ind_temp]=ind_out_qua(den_temp,nqual);
            [ind_sal]=ind_out_qua(den_sal,nqual);
            [ind_press]=ind_out_qua(den_press,nqual);
            ii_total=[ii_total,ind_sal',ind_temp',ind_press'];
            %find the bad places using all World Ocan Data base (no floats)
            
            if length(pos_wod) > 3 
            [ind_temp]=ind_out_qua_wod_floats(den_temp,nqual,pos_floats,pos_wod);
            [ind_sal]=ind_out_qua_wod_floats(den_sal,nqual,pos_floats,pos_wod);
            [ind_press]=ind_out_qua_wod_floats(den_press,nqual,pos_floats,pos_wod);
            ii_wod=[ii_wod,ind_sal',ind_temp',ind_press'];
            end % if
        end  % if
    end % denisty surface loop
clear den_sal den_tem den_press pos_floats pos_wod 
    % get rid of profiles with more than 5% missing

    if length(find(ii_wod == this_cast)) > 0
        bad_wod=[bad_wod',iqc]';
        per_done=100.*iqc/n_good
        per_bad_wod=100.*length(bad_wod)/iqc
    end

    if length(find(ii_total == this_cast)) > 0
        bad_total=[bad_total',iqc]';
        per_done=100.*iqc/n_good
        per_bad_total=100.*length(bad_total)/iqc
    end
    
clear ii_wod ii_total
   
    end % end of WMO sqruare
    
    
     

eval(['save ind_grad_den_0_grid_aden_den_no_f',num2str(wmo_number),'.mat bad_total bad_wod'])


   clear temp_0 sal_0 press_0 type mdep npts dt coords time ...
temp_0_wod sal_0_wod press_0_wod type_wod mdep_wod npts_wod dt_wod coords_wod time_wod ...
good_locations good_place coords_tot  density_surface  dg_hi_tot  dg_lo_tot  dt_tot  fpress_tot  gam_tot  id_tot  ...
    mdep_tot  npts_tot  per_bad_grad_tot  press_0_tot  press_bot_0_tot  press_bot_gam_tot  press_gam_tot  ...
    press_top_0_tot  press_top_gam_tot  qual_tot  ratio_bad_tot  sal_tot  sal_0_tot  sal_gam_tot  temp_tot ...
    temp_0_tot  temp_gam_tot  time_tot wmo_tot bad_total bad_wod


    end
end %end of WMO files




