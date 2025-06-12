function [ptemp_prof,sal_prof]=find_prof_NCAR(ptemp,sal,pos_2d,ndepth)

%     ndepth=62;
    s_sal=size(sal);
    nprof=length(pos_2d);
    nlon=s_sal(1);
    nlat=s_sal(2);
    
    ind_3d=repmat(pos_2d,[1 ndepth])';
    ind_3d=ind_3d(:);
    
    [pos_lon,pos_lat]=ind2sub([nlon nlat],ind_3d);
    
    pos_depth=repmat(1:ndepth,[1 nprof])';
    
    pos_3d= sub2ind([nlon nlat ndepth],pos_lon,pos_lat,pos_depth);
    

    ptemp_prof=reshape(ptemp(pos_3d),ndepth,nprof);
    sal_prof=reshape(sal(pos_3d),ndepth,nprof);


end

