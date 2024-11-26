	program main

c  This program objectively maps XBT-TPX data onto a specified grid
c  the program requests the name of the file containing the XBT-TPX
c  data to be gridded.  Requires the file map.grd.
c  written 4/29/03 by josh willis
c  To compile on newcomp:
c  g77 -O2 -o mapst.x mapst.f -L/home/jwillis/lib -llapack -lcblas \
c  -lf77blas -latlas
c  To compile using atlas:
c  pgf77 -fast -o mapheat.x mapheat.f -L/usr/lib -llapack -lcblas \
c  -lf77blas -latlas -lg2c
c  To compile using g77:
c  g77 -O2 -o mapst.x mapst.f -llapack

	parameter (ng = 500000)
	parameter (nd = 200000)
	parameter (bmax = 25000)
	parameter (bmaxmax = 100000)
	parameter (nover = 120)
	real gcds(ng,2),mdat(ng,3),invmat(350,350),idat(350,3),dgrid(350)
	real ddat(nd),xdat(nd),tdat(nd),yr(nd),cds(nd,2),iidat(350)
	real dcds(350,2),datalon,datalat,glon,glat,dave
	real tlon(72,36),tlat(72,36),tm(2),dist(bmaxmax),tmpsort(bmaxmax)
	real tcds(72,36,2),dellat,dellon,ttind(nover,bmaxmax),tmpind(bmaxmax)
	character*80 dfname,mfname,nfname
	integer i,j,k,ngrid,ndata,n,iind,jind,ninver,ind(bmaxmax),iseed
	integer tind(72,36,bmax),tlen(72,36),info,data(bmax),tflag(72,36)
	integer tm1,tm2,nhrs,lda,ldb,nloops,rind(bmaxmax),ipiv(350)
	external compar
	integer compar,icount
c
c
	iseed=1
c

c                              10        20        30        40        50
c                     12345678901234567890123456789012345678901234567890123
	dfname(1:14)='hdata1992d.txt'
	nfname(1:16)='hdata1992d.notes'
	mfname(1:17)='map1992d_3deg.txt'
c get name of file with input data and read in data
	open(66,file='input2',form='formatted',status='old')
	read(66,'(a14)'),dfname(1:14)
	close(66)
	nfname(1:10)=dfname(1:10)
	mfname(4:8) = dfname(6:10)
	write(*,*),dfname,nfname,mfname

	open(66,file=dfname,form='formatted',status='old')
	read(66,101,end=10) (ddat(i),xdat(i),tdat(i),yr(i),
     &		cds(i,1),cds(i,2), i=1,nd)
c       read(66,111,end=10)(ddat(i),tdat(i,1),yr(i),cds(i,1),cds(i,2),
c    &          i=1,nd)
   10	continue
  101	format(6(g16.7e2))
  111	format(6(g16.7e2))
	close(66)
	ndata=i-1

c load grid info
	open(66,file='map.grd',form='formatted',status='old')
	read(66,102,end=20) (gcds(i,1),gcds(i,2), i=1,nd)
   20	continue
  102	format(2(g16.7e2))
	ngrid=i-1
	close(66)

	open(69,file=nfname,form='formatted',status='unknown')
	write(69,*),dfname
	write(69,*)'number of points:  ',ndata
c store all indices within 20 deg on a 5 x 5 degree grid to aid with
c finding closest indicies for inversion
	icount = 0
	do i=1,72
	   do j=1,36
	      tlen(i,j) = 0
	      tcds(i,j,1) = (i-1)*5-177.5
	      tcds(i,j,2) = (j-1)*5-87.5
	      do k=1,ndata
		 datalon = cds(k,1)
		 datalat = cds(k,2)
		 if (tcds(i,j,1).lt.-150.and.datalon.gt.150) 
     &			datalon = datalon - 360
		 if (tcds(i,j,1).gt.150.and.datalon.lt.-150) 
     &			datalon = datalon + 360
		 dellon = abs(datalon-tcds(i,j,1))
		 dellat = abs(datalat-tcds(i,j,2))
		 if (dellon.lt.15.0.and.dellat.lt.15.0) then
		    tlen(i,j) = tlen(i,j) + 1
		    tmpind(tlen(i,j)) = k
		 end if
	      end do
	      if (tlen(i,j).le.bmax) then
		 do k=1,tlen(i,j)
		    tind(i,j,k) = tmpind(k)
		 end do
		 tflag(i,j)=0
	      else
		 icount = icount +1
		 tflag(i,j)=icount
		 do k=1,tlen(i,j)
		    ttind(icount,k) = tmpind(k)
		 end do
	      end if
	   end do
	end do

c loop through grid points, pick out 300 closest points and 50 more
c randomly sampled within 10 degrees to do inversion
	open(67,file=mfname,form='formatted',status='unknown')
	t1 = dtime(tm)
	do i=1,ngrid
	   
c	   figure out where we are and get datapoints
	   glon = gcds(i,1)
	   if (glon.eq.180.0) glon=-180.0
	   glat = gcds(i,2)
	   iind = int((glon+180)/5) + 1
	   jind = int((glat+90)/5) + 1
c	   calculate distance from grid point to each possible data point
	   ninver = tlen(iind,jind)
	   do j=1,ninver
	      if (ninver.le.bmax) then
	         ind(j) = tind(iind,jind,j)
	      else
		 ind(j) = ttind(tflag(iind,jind),j)
	      end if
	      datalon = cds(ind(j),1)
	      datalat = cds(ind(j),2)
	      if (glon.lt.-150.0.and.datalon.gt.150.0) datalon = datlon - 360
	      if (glon.gt.150.0.and.datalon.lt.-150.0) datalon = datlon + 360
	      dist(j) = ((glon-datalon)**2 + (glat-datalat)**2)**(.5)
	   end do
	   call ssort(dist,ind,ninver,2)

c          pick out 50 random data points spread out over the box
	   if (ninver.gt.350) then
	      do j=1,ninver-300
		 rind(j) = j
		 tmpsort(j) = rand(1)
	      end do
	      call ssort(tmpsort,rind,ninver-300,2)
              do j=1,50
		 rind(j) = ind(rind(j) + 300)
	      end do
              do j=1,50
		 ind(j+300) = rind(j)
	      end do
	      ninver = 350
	   end if

c	   just in case theres one without any data
	   if (ninver.lt.1) then
	      do j=1,3
	        mdat(i,j) = 0.0
	      end do
	      dave = 0.0
	   else
c	      matrix fill
	      do j=1,ninver
		 dcds(j,1)=cds(ind(j),1)
		 dcds(j,2)=cds(ind(j),2)
	         if (gcds(i,1).lt.-150.0.and.dcds(j,1).gt.150.0) 
     &			dcds(j,1) = dcds(j,1) - 360
	         if (gcds(i,1).gt.150.0.and.dcds(j,1).lt.-150.0) 
     &			dcds(j,1) = dcds(j,1) + 360
	      end do

	      do j=1,ninver
		 do k=1,ninver
		    invmat(j,k) = ( (dcds(j,1) - dcds(k,1))**2
     & 			+ (dcds(j,2) - dcds(k,2))**2 )**(0.5)
 		    invmat(j,k) = (exp(-invmat(j,k)/8.0) + 
     & 			3.4 * exp(-((invmat(j,k)/3.0)**2)))/4.4
		 end do
		 idat(j,1) = ddat(ind(j))
		 idat(j,2) = xdat(ind(j))
		 idat(j,3) = tdat(ind(j))
	      end do
c	This part adds varience to the diagonal of 2.2 which is a
c		ratio between the varibility bellow a year and above
c		a year from the spectra published by wunch...
	      do j=1,ninver
		 invmat(j,j) = invmat(j,j) + 2.2
	      end do
c	      inversion
	      call sposv('L',ninver,3,invmat,350,idat,350,info)
c	      data grid matrix
	      dave = 0.0
	      do j=1,ninver
		 dgrid(j) = ( (dcds(j,1) - gcds(i,1))**2
     &			+ (dcds(j,2) - gcds(i,2))**2 )**(0.5)
		 dave = dave + dgrid(j)/ninver
		 dgrid(j) = (exp(-dgrid(j)/8.0) + 
     &			3.4 * exp(-((dgrid(j)/3.0)**2)))/4.4
	      end do
c	      calculate map value
              do j=1,ninver
		 iidat(j) = idat(j,1)
	      end do
	      mdat(i,1) = sdot(ninver,dgrid,1,iidat,1)
              do j=1,ninver
		 iidat(j) = idat(j,2)
	      end do
	      mdat(i,2) = sdot(ninver,dgrid,1,iidat,1)
              do j=1,ninver
		 iidat(j) = idat(j,3)
	      end do
	      mdat(i,3) = sdot(ninver,dgrid,1,iidat,1)
	   end if
	   write(67,103) mdat(i,1),mdat(i,2),mdat(i,3)
  103	   format(3(e16.7e2))
	end do
	total = dtime(tm)
	write(69,*) 'runtime:  ',total
	close(69)
	close(67)
	end
	
       
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c	function ssort to do sorting
*DECK SSORT
      SUBROUTINE SSORT (X, Y, N, KFLAG)
C***BEGIN PROLOGUE  SSORT
C***PURPOSE  Sort an array and optionally make the same interchanges in
C            an auxiliary array.  The array may be sorted in increasing
C            or decreasing order.  A slightly modified QUICKSORT
C            algorithm is used.
C***LIBRARY   SLATEC
C***CATEGORY  N6A2B
C***TYPE      SINGLE PRECISION (SSORT-S, DSORT-D, ISORT-I)
C***KEYWORDS  SINGLETON QUICKSORT, SORT, SORTING
C***AUTHOR  Jones, R. E., (SNLA)
C           Wisniewski, J. A., (SNLA)
C***DESCRIPTION
C
C   SSORT sorts array X and optionally makes the same interchanges in
C   array Y.  The array X may be sorted in increasing order or
C   decreasing order.  A slightly modified quicksort algorithm is used.
C
C   Description of Parameters
C      X - array of values to be sorted   (usually abscissas)
C      Y - array to be (optionally) carried along
C      N - number of values in array X to be sorted
C      KFLAG - control parameter
C            =  2  means sort X in increasing order and carry Y along.
C            =  1  means sort X in increasing order (ignoring Y)
C            = -1  means sort X in decreasing order (ignoring Y)
C            = -2  means sort X in decreasing order and carry Y along.
C
C***REFERENCES  R. C. Singleton, Algorithm 347, An efficient algorithm
C                 for sorting with minimal storage, Communications of
C                 the ACM, 12, 3 (1969), pp. 185-187.
C***ROUTINES CALLED  XERMSG
C***REVISION HISTORY  (YYMMDD)
C   761101  DATE WRITTEN
C   761118  Modified to use the Singleton quicksort algorithm.  (JAW)
C   890531  Changed all specific intrinsics to generic.  (WRB)
C   890831  Modified array declarations.  (WRB)
C   891009  Removed unreferenced statement labels.  (WRB)
C   891024  Changed category.  (WRB)
C   891024  REVISION DATE from Version 3.2
C   891214  Prologue converted to Version 4.0 format.  (BAB)
C   900315  CALLs to XERROR changed to CALLs to XERMSG.  (THJ)
C   901012  Declared all variables; changed X,Y to SX,SY. (M. McClain)
C   920501  Reformatted the REFERENCES section.  (DWL, WRB)
C   920519  Clarified error messages.  (DWL)
C   920801  Declarations section rebuilt and code restructured to use
C           IF-THEN-ELSE-ENDIF.  (RWC, WRB)
C***END PROLOGUE  SSORT
C     .. Scalar Arguments ..
      INTEGER KFLAG, N
C     .. Array Arguments ..
      REAL X(*)
      INTEGER Y(*)
C     .. Local Scalars ..
      REAL R, T, TT, TTY, TY
      INTEGER I, IJ, J, K, KK, L, M, NN
C     .. Local Arrays ..
      INTEGER IL(21), IU(21)
C     .. External Subroutines ..
c     EXTERNAL XERMSG
C     .. Intrinsic Functions ..
      INTRINSIC ABS, INT
C***FIRST EXECUTABLE STATEMENT  SSORT
      NN = N
      IF (NN .LT. 1) THEN
c         CALL XERMSG ('SLATEC', 'SSORT',
c     +      'The number of values to be sorted is not positive.', 1, 1)
         RETURN
      ENDIF
C
      KK = ABS(KFLAG)
      IF (KK.NE.1 .AND. KK.NE.2) THEN
c         CALL XERMSG ('SLATEC', 'SSORT',
c     +      'The sort control parameter, K, is not 2, 1, -1, or -2.', 2,
c     +      1)
         RETURN
      ENDIF
C
C     Alter array X to get decreasing order if needed
C
      IF (KFLAG .LE. -1) THEN
         DO 10 I=1,NN
            X(I) = -X(I)
   10    CONTINUE
      ENDIF
C
      IF (KK .EQ. 2) GO TO 100
C
C     Sort X only
C
      M = 1
      I = 1
      J = NN
      R = 0.375E0
C
   20 IF (I .EQ. J) GO TO 60
      IF (R .LE. 0.5898437E0) THEN
         R = R+3.90625E-2
      ELSE
         R = R-0.21875E0
      ENDIF
C
   30 K = I
C
C     Select a central element of the array and save it in location T
C
      IJ = I + INT((J-I)*R)
      T = X(IJ)
C
C     If first element of array is greater than T, interchange with T
C
      IF (X(I) .GT. T) THEN
         X(IJ) = X(I)
         X(I) = T
         T = X(IJ)
      ENDIF
      L = J
C
C     If last element of array is less than than T, interchange with T
C
      IF (X(J) .LT. T) THEN
         X(IJ) = X(J)
         X(J) = T
         T = X(IJ)
C
C        If first element of array is greater than T, interchange with T
C
         IF (X(I) .GT. T) THEN
            X(IJ) = X(I)
            X(I) = T
            T = X(IJ)
         ENDIF
      ENDIF
C
C     Find an element in the second half of the array which is smaller
C     than T
C
   40 L = L-1
      IF (X(L) .GT. T) GO TO 40
C
C     Find an element in the first half of the array which is greater
C     than T
C
   50 K = K+1
      IF (X(K) .LT. T) GO TO 50
C
C     Interchange these elements
C
      IF (K .LE. L) THEN
         TT = X(L)
         X(L) = X(K)
         X(K) = TT
         GO TO 40
      ENDIF
C
C     Save upper and lower subscripts of the array yet to be sorted
C
      IF (L-I .GT. J-K) THEN
         IL(M) = I
         IU(M) = L
         I = K
         M = M+1
      ELSE
         IL(M) = K
         IU(M) = J
         J = L
         M = M+1
      ENDIF
      GO TO 70
C
C     Begin again on another portion of the unsorted array
C
   60 M = M-1
      IF (M .EQ. 0) GO TO 190
      I = IL(M)
      J = IU(M)
C
   70 IF (J-I .GE. 1) GO TO 30
      IF (I .EQ. 1) GO TO 20
      I = I-1
C
   80 I = I+1
      IF (I .EQ. J) GO TO 60
      T = X(I+1)
      IF (X(I) .LE. T) GO TO 80
      K = I
C
   90 X(K+1) = X(K)
      K = K-1
      IF (T .LT. X(K)) GO TO 90
      X(K+1) = T
      GO TO 80
C
C     Sort X and carry Y along
C
  100 M = 1
      I = 1
      J = NN
      R = 0.375E0
C
  110 IF (I .EQ. J) GO TO 150
      IF (R .LE. 0.5898437E0) THEN
         R = R+3.90625E-2
      ELSE
         R = R-0.21875E0
      ENDIF
C
  120 K = I
C
C     Select a central element of the array and save it in location T
C
      IJ = I + INT((J-I)*R)
      T = X(IJ)
      TY = Y(IJ)
C
C     If first element of array is greater than T, interchange with T
C
      IF (X(I) .GT. T) THEN
         X(IJ) = X(I)
         X(I) = T
         T = X(IJ)
         Y(IJ) = Y(I)
         Y(I) = TY
         TY = Y(IJ)
      ENDIF
      L = J
C
C     If last element of array is less than T, interchange with T
C
      IF (X(J) .LT. T) THEN
         X(IJ) = X(J)
         X(J) = T
         T = X(IJ)
         Y(IJ) = Y(J)
         Y(J) = TY
         TY = Y(IJ)
C
C        If first element of array is greater than T, interchange with T
C
         IF (X(I) .GT. T) THEN
            X(IJ) = X(I)
            X(I) = T
            T = X(IJ)
            Y(IJ) = Y(I)
            Y(I) = TY
            TY = Y(IJ)
         ENDIF
      ENDIF
C
C     Find an element in the second half of the array which is smaller
C     than T
C
  130 L = L-1
      IF (X(L) .GT. T) GO TO 130
C
C     Find an element in the first half of the array which is greater
C     than T
C
  140 K = K+1
      IF (X(K) .LT. T) GO TO 140
C
C     Interchange these elements
C
      IF (K .LE. L) THEN
         TT = X(L)
         X(L) = X(K)
         X(K) = TT
         TTY = Y(L)
         Y(L) = Y(K)
         Y(K) = TTY
         GO TO 130
      ENDIF
C
C     Save upper and lower subscripts of the array yet to be sorted
C
      IF (L-I .GT. J-K) THEN
         IL(M) = I
         IU(M) = L
         I = K
         M = M+1
      ELSE
         IL(M) = K
         IU(M) = J
         J = L
         M = M+1
      ENDIF
      GO TO 160
C
C     Begin again on another portion of the unsorted array
C
  150 M = M-1
      IF (M .EQ. 0) GO TO 190
      I = IL(M)
      J = IU(M)
C
  160 IF (J-I .GE. 1) GO TO 120
      IF (I .EQ. 1) GO TO 110
      I = I-1
C
  170 I = I+1
      IF (I .EQ. J) GO TO 150
      T = X(I+1)
      TY = Y(I+1)
      IF (X(I) .LE. T) GO TO 170
      K = I
C
  180 X(K+1) = X(K)
      Y(K+1) = Y(K)
      K = K-1
      IF (T .LT. X(K)) GO TO 180
      X(K+1) = T
      Y(K+1) = TY
      GO TO 170
C
C     Clean up
C
  190 IF (KFLAG .LE. -1) THEN
         DO 200 I=1,NN
            X(I) = -X(I)
  200    CONTINUE
      ENDIF
      RETURN
      END
