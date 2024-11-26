
function [tu,rp,p_ave] = sw_turn(S,T,P)

% SW_TURN    Turner angle and density ratio
%===========================================================================
% SW_TURN  $Revision: 1.0 $   $Date: 2004/09/21 $
%  
%
% USAGE:  [tu,rp,p_ave] = sw_turn(S,T,P) 
%
% DESCRIPTION:
%    Calculates turner angle (tu) and density ratio (rp) 
%    at the mid depths from the equations,
%
%               -g      d(pdens)
%         N2 =  ----- x --------
%               pdens     d(z)
%
%    Also returns Potential Vorticity from q = f*N2/g.  
%
% INPUT:  (all must have same dimensions MxN)
%   S   = salinity    [psu      (PSS-78) ]
%   T   = temperature [degree C (IPTS-68)]
%   P   = pressure    [db]   
%
% OUTPUT:
%   tu    = Turner Angle (M-1xN)  [unitless]
%   rp    = Density Ratio (M-1xN)  [unitless]
%   p_ave = Mid pressure between P grid     (M-1xN)  [db]
%
% AUTHOR:  Gregory C. Johnson 2004-09-21  (gregory.c.johnson@noaa.gov)
%
% DISCLAIMER:
%   This software is provided "as is" without warranty of any kind.  
%
% REFERENCES:
%   Ruddick, B., 1983. "A practical indicator of the stability 
%   of the water column to double-diffusive activity".  Deep-Sea 
%   Research, Vol 30., No. 10A. pp. 1105-1107.
% 
%=========================================================================

% CALLER:  general purpose
% CALLEE:  sw_pden.m, sw_ptmp.m, sw_alpha.m, sw_beta.m

%-------------
% CHECK INPUTS
%-------------
if ~(nargin==3) 
   error('sw_turn.m: Must pass 3 parameters ')
end %if

% CHECK S,T,P dimensions and verify consistent
[ms,ns] = size(S);
[mt,nt] = size(T);
[mp,np] = size(P);

% CHECK THAT S & T HAVE SAME SHAPE
if (ms~=mt) | (ns~=nt)
   error('check_stp: S & T must have same dimensions')
end %if

% CHECK OPTIONAL SHAPES FOR P
if     mp==1  & np==1      % P is a scalar.  Fill to size of S
   P = P(1)*ones(ms,ns);
elseif np==ns & mp==1      % P is row vector with same cols as S
   P = P( ones(1,ms), : ); %   Copy down each column.
elseif mp==ms & np==1      % P is column vector
   P = P( :, ones(1,ns) ); %   Copy across each row
elseif mp==ms & np==ns     % PR is a matrix size(S)
   % shape ok 
else
   error('check_stp: P has wrong dimensions')
end %if
[mp,np] = size(P);
   
% IF ALL ROW VECTORS ARE PASSED THEN LET US PRESERVE SHAPE ON RETURN.
Transpose = 0;
if mp == 1  % row vector
   P       =  P(:);
   T       =  T(:);
   S       =  S(:);   

   Transpose = 1;
end %if
%***check_stp


%------
% BEGIN
%------

% get some indices

[m,n] = size(P);
iup   = 1:m-1;
ilo   = 2:m;

% derive some properties

th=sw_ptmp(S,T,P,0);
sg=sw_pden(S,T,P,0)-1000;

% compute some first-difference gradients

dthdz=diff(th)./diff(P);
dsadz=diff(S)./diff(P);

% compute some average values at mid-points

p_ave=P(iup,:)/2+P(ilo,:)/2;
th_ave=th(iup,:)/2+th(ilo,:)/2;
te_ave=T(iup,:)/2+T(ilo,:)/2;
sa_ave=S(iup,:)/2+S(ilo,:)/2;

% compute some derived properties at mid-points

a_ave=sw_alpha(sa_ave,te_ave,p_ave);
b_ave=sw_beta(sa_ave,te_ave,p_ave);

% compute density ratio and turner angle

rp=(a_ave.*dthdz)./(b_ave.*dsadz);
Nt2=-a_ave.*dthdz;
Ns2=b_ave.*dsadz;
tu=atan2((Nt2-Ns2),(Nt2+Ns2));
  
if Transpose
  rp    = rp';
  tu    = tu';
  p_ave = p_ave';
end %if
return
%-------------------------------------------------------------------
