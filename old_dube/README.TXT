README.TXT for HC/ directory

In this subdirectory, all profile QC is done and global heat content
maps are estimated.

Programs:

First all data must be downloaded and read using the appropriate
scripts in the directories:  Floats/, GTSPP/, Mtpers/, and WOD01/.
These progs will have created w????.mat (WOD01 data), g????.mat (GTSPP data)
and f????.mat (Float data) files in this directory.  Here ???? is the 
number for the WMO square. 

Note:  Also need to run files in Levitus/ directory to save that data
into matlab format too.

Next QC is done using the following matlab scripts:

  toss.m	- Basic QC, gets rid of unphysical data
  remdups.m	- combines datasets into d????.mat files and removes 
		  duplicates.
  fixtop.m	- fixes NaN's in 'mixed layers' above 25m.  If data was
		  missing for depth shallower than 25m, I assumed that
		  all temps. shallower than the shallowest existing data
		  were equal to the shallowest avail. measurement.  We
		  can probably do better for the mixed layer, but for 
		  depth-integrated quantities, this is not too bad.
  fixbox.m	- regroups data into geographically similar WMO squares
		  and eliminates or consolidates some with little data.
  qc1.m		- statistical cutoff - a few special cases
  qc2.m		- does round 2 of qc - full of special cases
  fixbottom.m	- fixes cutoff profiles, or "extends" all profs. with
		  enough data to 750m.

That's it for QC.  Once these are run, our QC'ed, mered, interpolated
profile data set is saved in e????.mat files, where ???? is still the
WMO square code.  

The following program is kinda old and was an attempt
to see how big an error the "fixbottom" process might cause:
  
  testfix.m	- (optional) does some tests to see if "fixbottom" worked
		  reasonably.

Next, do heat content analysis:

  makeheat.m 	- makes heat content anomalies and saves them in one big
		  file
  interptpx.m 	- interpolates topex onto each profile.
  mapclim.m 	- makes heat content 10-year mean.  Note, this takes
		  a while.  Uses high-res levitus as initial guess.

  mapdiff.m	- begins process of making difference estimate.  Calculates
		  XBT - (alpha * T/P) and spits out hdata?????.txt files.
		  Here ????? is a year and a letter denoting the time
		  period for each map (eg., 1993a is centered around 1993.0 
		  and 1993c is centered around 1993.75).
  mapheat1.f 	- fortran program that actually does the objective mapping
		  this reads in hdata?????.txt, and map.grd (which contains
		  the grid to which we will be mapping the estimate).  I
		  use the shell script rmap1.sh to run this automatically
		  for all the hdata?????.txt files.  mapheat1.f spits out
		  map?????.txt files containg the objectivly mapped data.
  mapheat2.f	- same as mapheat1.f, but allows you to run multiple jobs
		  at the same time in case you have more than 1 avaliable
		  cpu on the same machine (can also be run by a rmap2.sh
		  script file)
  rmap?.sh	- shell script to run mapheat?.f
  xbtfix.m	- once all map?????.txt files are generated using mapheat.f,
		  this matlab script reads in the mapped files and saves
		  heat content estimate into hc?????.mat files and also
		  computes global integral time series and saves it in
		  hcseries.mat
  makehovs.m 	- makes zonally-integrated heat content time series 
		  (HC v. time and lat.) and makes a plot
  makef?.m	- makes nice plots for JGR paper
