function [model_all]=make_trees_mean_eqbox(use,ht_use,tpx,sst,coords,yr,nbasins_use,good_yr,good_prof,large_scale,...
    scale_box_deg_lat,scale_box_eq,lat_change)
  



if ~exist("large_scale",'var')
    large_scale='none';
end

model_all=[];

global_basins=find_basin_paige(coords(:,1),coords(:,2));



paroptions = statset('UseParallel',true);

nbasins=length(global_basins);
if ~exist('nbasins_use','var')
    nbasins_use=[1:nbasins];
end
for ibasin=nbasins_use
       junk_pos=global_basins(ibasin).pos;
       
       good=good_yr & good_prof & junk_pos & use;

       ht_mat=ht_use(good)';
       
       if ~isempty(ht_mat)
           input_mat=nans(length(ht_mat),5);
           input_mat(:,1)=yr(good);
           
           if ibasin==2
               % use lon 0 to 360 for the pacific basin
               jj_lon=coords(good,1);
               jj_lon(jj_lon<0)=jj_lon(jj_lon<0)+360;


               switch large_scale
                   case 'a'
                       input_mat(:,3)=scale_box_deg_lat.*floor(coords(good,2)./scale_box_deg_lat);
                       %compute the longitudnal scale
                       A=scale_box_deg_lat.*abs(sind(lat_change)./(cosd(lat_change).*sind(input_mat(:,3))));
                       B=scale_box_deg_lat./cosd(input_mat(:,3));
                       AA=min(A,scale_box_eq);
                       scale_box_deg_lon=max(AA,B);

                       input_mat(:,2)=scale_box_deg_lon.*floor(jj_lon./scale_box_deg_lon);
                       
                   case 'b'
                       input_mat(:,3)=scale_box_deg_lat.*round(coords(good,2)./scale_box_deg_lat);
                       %compute the longitudnal scale
                       A=scale_box_deg_lat.*abs(sind(lat_change)./(cosd(lat_change).*sind(input_mat(:,3))));
                       B=scale_box_deg_lat./cosd(input_mat(:,3));
                       AA=min(A,scale_box_eq);
                       scale_box_deg_lon=max(AA,B);
                       
                       input_mat(:,2)=scale_box_deg_lon.*floor(jj_lon./scale_box_deg_lon);
                      
                   case 'c'
                       input_mat(:,3)=scale_box_deg_lat.*floor(coords(good,2)./scale_box_deg_lat);
                       %compute the longitudnal scale
                       A=scale_box_deg_lat.*abs(sind(lat_change)./(cosd(lat_change).*sind(input_mat(:,3))));
                       B=scale_box_deg_lat./cosd(input_mat(:,3));
                       AA=min(A,scale_box_eq);
                       scale_box_deg_lon=max(AA,B);

                       input_mat(:,2)=scale_box_deg_lon.*round(jj_lon./scale_box_deg_lon);
                       
                   case 'd'
                      input_mat(:,3)=scale_box_deg_lat.*round(coords(good,2)./scale_box_deg_lat);
                      %compute the longitudnal scale
                       A=scale_box_deg_lat.*abs(sind(lat_change)./(cosd(lat_change).*sind(input_mat(:,3))));
                       B=scale_box_deg_lat./cosd(input_mat(:,3));
                       AA=min(A,scale_box_eq);
                       scale_box_deg_lon=max(AA,B);
                       
                      input_mat(:,2)=scale_box_deg_lon.*round(jj_lon./scale_box_deg_lon);
                      
                   case 'none'
                       input_mat(:,2)=coords(good,1);
                       input_mat(:,3)=coords(good,2);
                   otherwise
                       'error: wrong type of smoothing'
               end
          
           else
                switch large_scale
                   case 'a'
                       input_mat(:,3)=scale_box_deg_lat.*floor(coords(good,2)./scale_box_deg_lat);
                       %compute the longitudnal scale
                       A=scale_box_deg_lat.*abs(sind(lat_change)./(cosd(lat_change).*sind(input_mat(:,3))));
                       B=scale_box_deg_lat./cosd(input_mat(:,3));
                       AA=min(A,scale_box_eq);
                       scale_box_deg_lon=max(AA,B);

                       input_mat(:,2)=scale_box_deg_lon.*floor(coords(good,1)./scale_box_deg_lon);
                   case 'b'
                       

                       input_mat(:,3)=scale_box_deg_lat.*round(coords(good,2)./scale_box_deg_lat);
                       %compute the longitudnal scale
                       A=scale_box_deg_lat.*abs(sind(lat_change)./(cosd(lat_change).*sind(input_mat(:,3))));
                       B=scale_box_deg_lat./cosd(input_mat(:,3));
                       AA=min(A,scale_box_eq);
                       scale_box_deg_lon=max(AA,B);
                       
                       input_mat(:,2)=scale_box_deg_lon.*floor(coords(good,1)./scale_box_deg_lon);
                   case 'c'
                       
                       input_mat(:,3)=scale_box_deg_lat.*floor(coords(good,2)./scale_box_deg_lat);
                       %compute the longitudnal scale
                       A=scale_box_deg_lat.*abs(sind(lat_change)./(cosd(lat_change).*sind(input_mat(:,3))));
                       B=scale_box_deg_lat./cosd(input_mat(:,3));
                       AA=min(A,scale_box_eq);
                       scale_box_deg_lon=max(AA,B);
                       
                       input_mat(:,2)=scale_box_deg_lon.*round(coords(good,1)./scale_box_deg_lon);
                   case 'd'
                      
                      input_mat(:,3)=scale_box_deg_lat.*round(coords(good,2)./scale_box_deg_lat);
                      %compute the longitudnal scale
                       A=scale_box_deg_lat.*abs(sind(lat_change)./(cosd(lat_change).*sind(input_mat(:,3))));
                       B=scale_box_deg_lat./cosd(input_mat(:,3));
                       AA=min(A,scale_box_eq);
                       scale_box_deg_lon=max(AA,B);

                       input_mat(:,2)=scale_box_deg_lon.*round(coords(good,1)./scale_box_deg_lon);
                       
                       
                   case 'none'
                       input_mat(:,2)=coords(good,1);
                       input_mat(:,3)=coords(good,2);
                   otherwise
                       'error: wrong type of smoothing'
               end
           end

           
           input_mat(:,4)=tpx(good);
           input_mat(:,5)=sst(good);
           ntrees=30;

    
           if ~ismember(ibasin,[1 2 5])
               ntrees=100;
           end


           m=TreeBagger(ntrees,input_mat,ht_mat','Method','regression','MinLeafSize',10,...
                'OOBPrediction','on','PredictorSelection','curvature','OOBPredictorImportance','on',...
                 'Options',paroptions);
%            cmod=compact(m);
           model_all(ibasin).name=global_basins(ibasin).name;
           model_all(ibasin).model=m;

%            compact_model_all(ibasin).name=global_basins(ibasin).name;
%            compact_model_all(ibasin).model=cmod;
%            clear m cmod
           
       end
   
       



end
% clear input_mat


%     view(m.Trees{1},'mode','graph');