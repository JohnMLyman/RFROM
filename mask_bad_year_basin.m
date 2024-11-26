function [ht]=mask_bad_year_basin(ht,time_aviso,file_basin_mask,...
    nbasin_use,global_basins_aviso,ilayer,nlon,nlat)



load(file_basin_mask,'bad_year_basin','time_basin')


for iyear=1:length(time_aviso)
 
    junk_mask=false(nlon,nlat);
    ht_junk=ht(:,:,iyear);

    diff_time=time_aviso(iyear)-time_basin;
    
    iyear_basin1=find(diff_time>=0 &diff_time<.5,1,'first');
    iyear_basin2=find(diff_time<=0 &diff_time>-.5,1,'first');
    
    if isfinite(time_aviso(iyear))
        
      
        
    
    
        for ibasin=nbasin_use
         
           b1=bad_year_basin(ibasin,ilayer-1,iyear_basin1);
           b2=bad_year_basin(ibasin,ilayer-1,iyear_basin2);
           if isempty(b2); b2=0; end
           if isempty(b1); b1=0; end
            junk_mask(global_basins_aviso(ibasin).pos)=...
                b1|b2;
        end
    
    
       ht_junk(junk_mask)=nan;
       ht(:,:,iyear)=ht_junk;

    end







end