function [slope,time,error,lat,lon]=load_heat_slope_300_700_900_1800(file_out)


eval(['load ',file_out,' slope error time lat lon'])
