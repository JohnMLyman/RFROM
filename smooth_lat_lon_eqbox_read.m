function input_mat=smooth_lat_lon_eqbox_read(input_mat,jlon,jlat,good,ibasin,...
               large_scale,scale_box_deg_lat,scale_box_eq,lat_change);
if ibasin==2
               % use lon 0 to 360 for the pacific basin
               jj_lon=jlon(good);
               jj_lon(jj_lon<0)=jj_lon(jj_lon<0)+360;
              switch large_scale
                   case 'a'
                       input_mat(:,3)=scale_box_deg_lat.*floor(jlat(good)./scale_box_deg_lat);
                       %compute the longitudnal scale
                       A=scale_box_deg_lat.*abs(sind(lat_change)./(cosd(lat_change).*sind(input_mat(:,3))));
                       B=scale_box_deg_lat./cosd(input_mat(:,3));
                       AA=min(A,scale_box_eq);
                       scale_box_deg_lon=max(AA,B);

                       input_mat(:,2)=scale_box_deg_lon.*floor(jj_lon./scale_box_deg_lon);
                       
                   case 'b'
                       input_mat(:,3)=scale_box_deg_lat.*round(jlat(good)./scale_box_deg_lat);
                       %compute the longitudnal scale
                       A=scale_box_deg_lat.*abs(sind(lat_change)./(cosd(lat_change).*sind(input_mat(:,3))));
                       B=scale_box_deg_lat./cosd(input_mat(:,3));
                       AA=min(A,scale_box_eq);
                       scale_box_deg_lon=max(AA,B);
                       
                       input_mat(:,2)=scale_box_deg_lon.*floor(jj_lon./scale_box_deg_lon);
                      
                   case 'c'
                       input_mat(:,3)=scale_box_deg_lat.*floor(jlat(good)./scale_box_deg_lat);
                       %compute the longitudnal scale
                       A=scale_box_deg_lat.*abs(sind(lat_change)./(cosd(lat_change).*sind(input_mat(:,3))));
                       B=scale_box_deg_lat./cosd(input_mat(:,3));
                       AA=min(A,scale_box_eq);
                       scale_box_deg_lon=max(AA,B);

                       input_mat(:,2)=scale_box_deg_lon.*round(jj_lon./scale_box_deg_lon);
                       
                   case 'd'
                      input_mat(:,3)=scale_box_deg_lat.*round(jlat(good)./scale_box_deg_lat);
                      %compute the longitudnal scale
                       A=scale_box_deg_lat.*abs(sind(lat_change)./(cosd(lat_change).*sind(input_mat(:,3))));
                       B=scale_box_deg_lat./cosd(input_mat(:,3));
                       AA=min(A,scale_box_eq);
                       scale_box_deg_lon=max(AA,B);
                       
                      input_mat(:,2)=scale_box_deg_lon.*round(jj_lon./scale_box_deg_lon);
                      
                   case 'none'
                       input_mat(:,2)=jj_lon;
                       input_mat(:,3)=jlat(good);
                   otherwise
                       'error: wrong type of smoothing'
               end

          
           else
               switch large_scale
                   case 'a'
                       input_mat(:,3)=scale_box_deg_lat.*floor(jlat(good)./scale_box_deg_lat);
                       %compute the longitudnal scale
                       A=scale_box_deg_lat.*abs(sind(lat_change)./(cosd(lat_change).*sind(input_mat(:,3))));
                       B=scale_box_deg_lat./cosd(input_mat(:,3));
                       AA=min(A,scale_box_eq);
                       scale_box_deg_lon=max(AA,B);

                       input_mat(:,2)=scale_box_deg_lon.*floor(jlon(good)./scale_box_deg_lon);
                   case 'b'
                       

                       input_mat(:,3)=scale_box_deg_lat.*round(jlat(good)./scale_box_deg_lat);
                       %compute the longitudnal scale
                       A=scale_box_deg_lat.*abs(sind(lat_change)./(cosd(lat_change).*sind(input_mat(:,3))));
                       B=scale_box_deg_lat./cosd(input_mat(:,3));
                       AA=min(A,scale_box_eq);
                       scale_box_deg_lon=max(AA,B);
                       
                       input_mat(:,2)=scale_box_deg_lon.*floor(jlon(good)./scale_box_deg_lon);
                   case 'c'
                       
                       input_mat(:,3)=scale_box_deg_lat.*floor(jlat(good)./scale_box_deg_lat);
                       %compute the longitudnal scale
                       A=scale_box_deg_lat.*abs(sind(lat_change)./(cosd(lat_change).*sind(input_mat(:,3))));
                       B=scale_box_deg_lat./cosd(input_mat(:,3));
                       AA=min(A,scale_box_eq);
                       scale_box_deg_lon=max(AA,B);
                       
                       input_mat(:,2)=scale_box_deg_lon.*round(jlon(good)./scale_box_deg_lon);
                   case 'd'
                      
                      input_mat(:,3)=scale_box_deg_lat.*round(jlat(good)./scale_box_deg_lat);
                      %compute the longitudnal scale
                       A=scale_box_deg_lat.*abs(sind(lat_change)./(cosd(lat_change).*sind(input_mat(:,3))));
                       B=scale_box_deg_lat./cosd(input_mat(:,3));
                       AA=min(A,scale_box_eq);
                       scale_box_deg_lon=max(AA,B);

                       input_mat(:,2)=scale_box_deg_lon.*round(jlon(good)./scale_box_deg_lon);
                       
                       
                   case 'none'
                       input_mat(:,2)=jlon(good);
                       input_mat(:,3)=jlat(good);
                   otherwise
                       'error: wrong type of smoothing'
               end
end