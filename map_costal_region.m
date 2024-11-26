function basin_regions=map_costal_region(LON,LAT,ibasin)


switch ibasin   

    case 1
         
         pos_South_Africa=LON>=0&LON<=27&LAT<=-18.5&LAT>=-37.4;
         basin_regions(1).name='South_Africa';
         basin_regions(1).pos=pos_South_Africa;

         pos_Australia11=LON>=116&LON<=142.3&LAT<=-30.5&LAT>=-39.2;
         pos_Australia12=LON>=112&LON<=117&LAT<=-34.4&LAT>=-35.8;
         basin_regions(2).name='Australia1';
         basin_regions(2).pos=pos_Australia12|pos_Australia11;

         pos_Tasmania=LON>=142.3&LON<=149&LAT<=-37.8&LAT>=-45;
         basin_regions(3).name='Tasmania';
         basin_regions(3).pos=pos_Tasmania;

         pos_Australia2=LON>=149&LAT<=-30&LAT>=-39;
         basin_regions(4).name='Australia2';
         basin_regions(4).pos=pos_Australia2;

         pos_Australia31=LON>=110&LON<=125&LAT<=-13.5&LAT>=-32.5;
         pos_Australia32=LON>=112&LON<=117&LAT<=-32&LAT>=-34.4;
         basin_regions(5).name='Australia3';
         basin_regions(5).pos=pos_Australia31|pos_Australia32;

         pos_India1=LON>=85&LON<=98&LAT<=25&LAT>=11;
         basin_regions(6).name='India1';
         basin_regions(6).pos=pos_India1;

         pos_India2=LON>=63&LON<=77&LAT<=26&LAT>=4;
         basin_regions(7).name='India2';
         basin_regions(7).pos=pos_India2;

         pos_Oman=LON>=56&LON<=63&LAT<=28&LAT>=23;
         basin_regions(8).name='Oman';
         basin_regions(8).pos=pos_Oman;

%          pos_PersianGulf=LON<=56&LAT<=31&LAT>=23;
%          basin_regions(9).name='PersianGulf';
%          basin_regions(9).pos=pos_PersianGulf;

         pos_Yeman=LON>=44.5&LON<=60&LAT<=23&LAT>=12.4;
         basin_regions(9).name='Yeman';
         basin_regions(9).pos=pos_Yeman;

         pos_Somalia1=LON>=42.5&LON<=44.5&LAT<=13&LAT>=10.5;
         basin_regions(10).name='Somalia1';
         basin_regions(10).pos=pos_Somalia1;
    case 2
%          pos_South_Africa=LON>=0&LON<=27&LAT<=-18.5&LAT>=-37.4;
%          basin_regions(1).name='South_Africa';
%          basin_regions(1).pos=pos_South_Africa;
          pos_New_Zealand1=(LON>=169&LON<=172.4&LAT<=-40.4&LAT>=-43)|...
            (LON>=167&LON<=171&LAT<=-42.6&LAT>=-44.2);
          basin_regions(1).name='New_Zealand1';
          basin_regions(1).pos=pos_New_Zealand1;

          pos_New_Zealand2=(LON>=164&LON<=172&LAT<=-45.7&LAT>=-51);
          basin_regions(2).name='New_Zealand2';
          basin_regions(2).pos=pos_New_Zealand2;

          pos_New_Zealand3=(LON>=172.5&LON<=178&LAT<=-42.2&LAT>=-43.5)|...
              (LON>=170&LON<=178&LAT<=-43.5&LAT>=-45.7);
          basin_regions(3).name='New_Zealand3';
          basin_regions(3).pos=pos_New_Zealand3;

          pos_New_Zealand4=(LON>=172.4&LON<=176&LAT<=-39&LAT>=-41.6);
          basin_regions(4).name='New_Zealand4';
          basin_regions(4).pos=pos_New_Zealand4;

          pos_New_Zealand5=(LON>=170&LON<=180&LAT<=-32&LAT>=-39);
          basin_regions(5).name='New_Zealand5';
          basin_regions(5).pos=pos_New_Zealand5;
          
          pos_Austalia1=LON>=125 &LON<=142 & LAT<=-30 & LAT>=-40;
          basin_regions(6).name='Austraila1';
          basin_regions(6).pos=pos_Austalia1;

          pos_Tasmania=LON>=142.3&LON<=149&LAT<=-37.8&LAT>=-45;
          basin_regions(7).name='Tasmania';
          basin_regions(7).pos=pos_Tasmania;

          pos_Austalia2=LON>=149 &LON<=155 & LAT<=-28.7 & LAT>=-40;
          basin_regions(8).name='Austraila2';
          basin_regions(8).pos=pos_Austalia2;

          pos_Austalia3=LON>=143 &LON<=156 & LAT<=-11.25 & LAT>=-28.7;
          basin_regions(8).name='Austraila3';
          basin_regions(8).pos=pos_Austalia3;

          pos_Austalia4=LON>=120 &LON<=142.4 & LAT<=-8 & LAT>=-28.7;
          basin_regions(8).name='Austraila4';
          basin_regions(8).pos=pos_Austalia4;






end

