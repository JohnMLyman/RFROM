function [sal_den,temp_den,press_den,press_top_den,press_bot_den] = vert_den_grid(sal,temp,press,den,den_grid)

% Input

% sal, temp, press and den all (nprofiles,ndepth)
% den_grid an array of the denisty grid that you are gridding to (nden).


% Output
% sal_den,temp_den,press_den are (nprofiles, nden) 
%press_top_den and press_bot_den are the pressure at the top and bottom of
%the inputted profiles.


n_den=length(den_grid);

% grid data to sigma surface and gama surface

n_pos=size(sal,1);
sal_den=NaN*ones(1,n_den);
temp_den=sal_den;
press_den=sal_den;
press_top_den=NaN;
press_bot_den=press_top_den;


% grid to density referanced to the surface

    junk_sal=sal;
    junk_temp=temp;
    junk_press=press;
    junk_den=den;
   
  
    pos_den=find(finite(junk_den) == 1);
    % only grid to surfaces with 5 or more points.
    if length(pos_den) >= 5 
       
        
       
        junk_sal=junk_sal(pos_den);
       junk_temp=junk_temp(pos_den);
       junk_press=junk_press(pos_den);
       junk_den=junk_den(pos_den);
       
       % if two values are the same get rid of the shallow one
       
       [junk,pos_un]=unique(junk_den);
       junk_sal=junk_sal(pos_un);
       junk_temp=junk_temp(pos_un);
       junk_press=junk_press(pos_un);
       junk_den=junk_den(pos_un);
       
       % find the pressure of each surface
   
       press_den(:)=interp1(junk_den, ...
		junk_press,den_grid);
        temp_den(:)=interp1(junk_den, ...
		junk_temp,den_grid);
         sal_den(:)=interp1(junk_den, ...
		junk_sal,den_grid);
       
        press_top_den=min(junk_press);
        press_bot_den=min(junk_press);

        
    end %if
    
 
