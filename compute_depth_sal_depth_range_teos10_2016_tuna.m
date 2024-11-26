function [sal,temp]=compute_depth_sal_depth_range_teos10_2016_tuna(data,sal,temp,coords,depth_int_top, depth_int_bottom)


% this function integrates heat content down to a prescribed depths
% depth_int_bottom to depth_int_top .

%number of points required
del_depth=depth_int_bottom-depth_int_top;
%if depth_int_top <= 100; np_r=4; else  np_r=1; end
if depth_int_top <= 100; min_ratio_good=.5; else  min_ratio_good=1./3.; end


s_temp=size(sal);
np=s_temp(1);
%%
for iprof=1:np


    press_junk=data{iprof,3}(:);
    depth_junk=sw_dpth(press_junk,coords(iprof,2));
    long_junk=coords(iprof,1);
    lat_junk=coords(iprof,2);
    temp_junk=data{iprof,1}(:);
    sal_junk=data{iprof,2}(:);

    ngood_sal=length(find(isfinite(sal_junk)));

    if ngood_sal >=2
%     jj=find(depth_junk >= depth_int_top  & depth_junk <= depth_int_bottom);
   

   
    [good_level,jj]=depth_spacing_per_int_2016_tuna(depth_junk,depth_int_top, depth_int_bottom,min_ratio_good);
   
    
    
   % if press_junk(1) < 15 && depth_junk(end) >= depth_int_bottom && press_junk(1)>=0 && numel(jj) >np_r
        
    if good_level==1 && press_junk(1)>=0 
        
        % fix the botoom and top of the profile so that heat conent is
        % computed consistently across different float set ups
        % fix top
                depth_depth_int=depth_junk(jj);
                press_depth_int=press_junk(jj);
                temp_depth_int=temp_junk(jj);
                sal_depth_int=sal_junk(jj);

                if depth_int_top == 0 && depth_junk(1) ~= 0

                    depth_depth_int=[0 ;depth_junk(jj)];
                    press_depth_int=[0 ;press_junk(jj)];
                    temp_depth_int=[temp_junk(1); temp_junk(jj)];
                    sal_depth_int=[sal_junk(1) ;sal_junk(jj)];  
                    depth_junk=[0 ;depth_junk];
                    press_junk=[0 ;press_junk];
                    temp_junk=[temp_junk(1); temp_junk];
                    sal_junk=[sal_junk(1) ;sal_junk]; 

                else



                   

                    % for the cases when the depth at the top of the layer
                    % is between surface and first measurement

                    if depth_junk(1) > depth_int_top
                        depth_depth_int=[0 ;depth_junk(jj)];
                        press_depth_int=[0 ;press_junk(jj)];
                        temp_depth_int=[temp_junk(1); temp_junk(jj)];
                        sal_depth_int=[sal_junk(1) ;sal_junk(jj)]; 
                        
                        depth_junk=[0 ;depth_junk];
                        press_junk=[0 ;press_junk];
                        temp_junk=[temp_junk(1); temp_junk];
                        sal_junk=[sal_junk(1) ;sal_junk]; 
                    end

                    
                     


                     % fix top 

                    if (depth_depth_int(1)< depth_int_top)

                        
                        depth_depth_int=[depth_int_top;depth_depth_int(2:end)];
                        temp_depth_int=[interp1(depth_junk,temp_junk,depth_int_top);temp_depth_int(2:end)];
                        sal_depth_int=[interp1(depth_junk,sal_junk,depth_int_top);sal_depth_int(2:end)];
                        press_depth_int=[interp1(depth_junk,press_junk,depth_int_top);press_depth_int(2:end)];

                    end
        
                
            
            
                end
        
        
        
        % fix bottom 
       
        
            if ( depth_depth_int(end)> depth_int_bottom)


                depth_depth_int=[depth_depth_int(1:end-1);depth_int_bottom];
                temp_depth_int=[temp_depth_int(1:end-1);interp1(depth_junk,temp_junk,depth_int_bottom)];
                sal_depth_int=[sal_depth_int(1:end-1);interp1(depth_junk,sal_junk,depth_int_bottom)];
                press_depth_int=[press_depth_int(1:end-1);interp1(depth_junk,press_junk,depth_int_bottom)];

            end

            % compute heat content
            CT=gsw_CT_from_t(sal_depth_int,temp_depth_int,press_depth_int);
            temp(iprof)=trapz(depth_depth_int, ...
            CT)'./del_depth;
            [SA,~] = gsw_SA_from_SP(sal_depth_int,press_depth_int,long_junk,lat_junk);
%             CT=gsw_CT_from_t(sal_depth_int,temp_depth_int,press_depth_int);
            sal(iprof)=trapz(depth_depth_int, ...
            SA)'./del_depth;
      
        
        
    
    
    end
    end
end