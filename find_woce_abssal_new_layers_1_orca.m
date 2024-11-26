function [data_out]=find_woce_abssal_new_layers_1_orca(data_in,coords,layer_bounds,path_OHCA_data_out)


%% load 2004 GK salinity 
% [pres_gk,lat_gk,lon_gk,sal_gk]=read_gk;
%[pres,lat,lon_out,sal,Asal]=make_read_gk_absal;
% 
eval(['load ',path_OHCA_data_out,'/GK_clim/GK_abs_sal.mat Asal sal pres lon lat'])

sal_gk=Asal;
lat_gk=lat;
lon(lon<0)=lon(lon<0)+360;
lon_gk=lon;
pres_gk=pres;

lon_gk=[lon_gk(end/2+1:end)-360,lon_gk(1:end/2)];
sal_gk=[sal_gk(end/2+1:end,:,:);sal_gk(1:end/2,:,:)];

lon_gk=[lon_gk(end-6:end)-360,lon_gk,lon_gk(1:6)+360];
sal_gk=[sal_gk(end-6:end,:,:);sal_gk;sal_gk(1:6,:,:)];


[lat_gk_l_all,lon_gk_l_all]=meshgrid(lat_gk,lon_gk);

nlat_gk=length(lat_gk);
nlon_gk=length(lon_gk);
npres_gk=length(pres_gk);


max_depth_gk=nans(nlon_gk,nlat_gk);
for ilon_gk=1:nlon_gk
    for ilat_gk=1:nlat_gk
        
        junk_sal_gk=squeeze(sal_gk(ilon_gk,ilat_gk,:));
       mdep_gk=max(pres_gk(squeeze(isfinite(junk_sal_gk(:)))));
        if ~isempty(mdep_gk)
            max_depth_gk(ilon_gk,ilat_gk)=mdep_gk;
        end 
    end
end

%%

temp=data_in(:,1);
press=data_in(:,3);
nprof=length(temp);
data_out=data_in;
data_out1=data_out(:,1);
data_out2=data_out(:,2);
data_out3=data_out(:,3);

 tic
parfor j=1:nprof



max_depth_junk=max(press{j}(:));



    if length(press{j}(:))>2&&max_depth_junk>=100



        press_junk=double(press{j}(:));
        temp_junk=double(temp{j}(:));



% Set the Radius to look for the deepest salinity cast  

        good_lat_junk=find((lat_gk>=coords(j,2)-2) & (lat_gk<=coords(j,2)+2));
        good_lon_junk=find((lon_gk>=coords(j,1)-2) & (lon_gk<=coords(j,1)+2));

% Grid the mean Salinity to the 
        if ~isempty(good_lon_junk) && ~isempty(good_lat_junk); 
            njunk=length(press_junk);
%             length(good_lat_junk)
%             length(good_lon_junk)
%             j
            sal_junk=squeeze(interp3(lat_gk(good_lat_junk),lon_gk(good_lon_junk),pres_gk,sal_gk(good_lon_junk,good_lat_junk,:),repmat(coords(j,2),njunk,1),repmat(coords(j,1),njunk,1),press_junk));
        else
            sal_junk=NaN;
        end

        if ~isfinite(sum(sal_junk)) && ~isempty(good_lon_junk) && ~isempty(good_lat_junk)
            % if near edge find nearest grid point that goes the depest if
            % none with in 2 degrees report no salinity
           



           lat_gk_l=lat_gk_l_all(good_lon_junk,good_lat_junk);
           lon_gk_l=lon_gk_l_all(good_lon_junk,good_lat_junk);
           sal_gk_l=sal_gk(good_lon_junk,good_lat_junk,:);
           max_depth_gk_l=max_depth_gk(good_lon_junk,good_lat_junk);
            dist=sqrt((coords(j,2)-lat_gk_l).^2+(coords(j,1)-lon_gk_l).^2);


            dist(max_depth_gk_l< layer_bounds(2))=NaN;
            dist(~isfinite(max_depth_gk_l))=NaN;
            % find the deepest depth that is deeper than the showest layer
            a=find(max_depth_gk_l==max(max_depth_gk_l(:)));
            % find the closest of the deepest
            [~,b]=min(dist(a));
            pos_close=a(b);
            
            % if there are no 
            if length(find(isfinite(dist)==1))==1
                pos_close=[];
            end


            if ~isempty(pos_close)
            lat_junk=lat_gk_l(pos_close);
            lon_junk=lon_gk_l(pos_close);
            good_lon_pos= lon_gk(good_lon_junk)==lon_junk;
            good_lat_pos= lat_gk(good_lat_junk)==lat_junk;
            sal_junk=squeeze(interp1(pres_gk,squeeze(sal_gk_l(good_lon_pos,good_lat_pos,:)),press_junk));
            else
                sal_junk=NaN;
            end

        end



      if isfinite(nansum(sal_junk))



     good_pos=find(isfinite(temp_junk) & isfinite(sal_junk) & isfinite(press_junk));

     data_out1{j}=temp_junk(good_pos);
     data_out2{j}=sal_junk(good_pos);
     data_out3{j}=press_junk(good_pos);



%         if mod(j,5000)==0 ,disp(100*j./nprof), end
      end

    end
end
     data_out(:,1)=data_out1;
     data_out(:,2)=data_out2;
     data_out(:,3)=data_out3;


end
           
     
          