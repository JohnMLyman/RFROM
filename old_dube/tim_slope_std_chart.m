% load in data from file assume header is of the form:
%   YEAR,PMEL_R_0_W08,PMEL_R_0_L09,PMEL_R_0_I09,PMEL_R_0_G11,PMEL_R_0_GR12,PMEL_R_0_C13,PMEL_R_1_W08,PMEL_R_2_W08
% % set a=[paste file data here];
% 1 0_W08 W08
% 2 0_L09 L09
% 3 0_C13 0_I09
% 4 0_I09 0_G11
% 5 0_G11 0_GR12
% 6 0_GR12 0_C13
% 7 0_None 1_W08
% 8 1_W08  2_W08 
% 9 2_W08  mean
% MEAN


%read_pmelR
read_dom2
min_year=1993
%min_year=1970

time=YEAR;


good=find(time>=min_year);

time=time(good);



var_name{1}='W08';
var_name{2}='L09';
var_name{4}='I09';
var_name{6}='GR12';
var_name{5}='G11';
var_name{3}='C13';
var_name{7}='NONE';
var_name{8}='a1W08';
var_name{9}='a2W08';
slope_t=nans(1,9);
for i=1:9
    
    
    eval(['ohca=10.*' var_name{i} ';']);
    ohca=ohca(good);
    var_name(i)
    [y_model,y_model_err,slope_error,slope,dof]=j_fit_tim(time',ohca');
    [var_name(i) slope slope_error dof]
    
    eval([var_name{i} '_slope= slope;']);
    
end
