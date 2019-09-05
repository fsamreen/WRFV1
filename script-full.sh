#!/bin/bash
# run this code as source xy.sh
echo " Setting up environmental Variables for gcc, gfortran and g++........"
echo 'export DIR=~/Build_WRF/LIBRARIES' >>/home/wrfuser/.profile
echo 'export CC=gcc' >>/home/wrfuser/.profile
echo 'export CXX=g++' >>/home/wrfuser/.profile
echo 'export FC=gfortran' >>/home/wrfuser/.profile
echo 'export FCFLAGS=-m64' >>/home/wrfuser/.profile
echo 'export F77=gfortran' >>/home/wrfuser/.profile
echo 'export FFLAGS=-m64' >>/home/wrfuser/.profile
echo 'export PATH=$DIR/netcdf/bin:$PATH' >>/home/wrfuser/.profile
echo 'export NETCDF=$DIR/netcdf' >>/home/wrfuser/.profile
echo 'export PATH=$DIR/mpich/bin:$PATH' >>/home/wrfuser/.profile
echo 'export LDFLAGS=-L$DIR/grib2/lib' >>/home/wrfuser/.profile
echo 'export CPPFLAGS=-I$DIR/grib2/include' >>/home/wrfuser/.profile
echo 'export JASPERLIB=$DIR/grib2/lib' >>/home/wrfuser/.profile
echo 'export JASPERINC=$DIR/grib2/include' >>/home/wrfuser/.profile
#source ~/.profile
export DIR=/home/wrfuser/Build_WRF/LIBRARIES
export CC=gcc
export CXX=g++
export FC=gfortran
export FCFLAGS=-m64
export F77=gfortran
export FFLAGS=-m64
source /home/wrfuser/.profile
echo "Installing gcc, gfortran and g++......"
sudo apt-get update
sudo apt-get install gfortran -y
sudo apt-get install gcc -y
sudo apt-get install g++ -y
sudo apt-get install m4
sudo apt-get install csh -y
sudo apt-get install perl -y
sudo apt-get install tcsh -y
sudo apt-get install make -y
sudo apt-get dstat -y
which fortran
which gcc
which cpp
gcc --version
gfortran --version
cd /home/wrfuser
mkdir Build_WRF
mkdir TESTS
echo "Testing gfortran, gcc and g++............"
cd /home/wrfuser/TESTS
wget http://www2.mmm.ucar.edu/wrf/OnLineTutorial/compile_tutorial/tar_files/Fortran_C_tests.tar
tar -xf Fortran_C_tests.tar
#Test #1: Fixed Format Fortran Test: TEST_1_fortran_only_fixed.f
gfortran TEST_1_fortran_only_fixed.f
./a.out
#The following should print out to the screen: SUCCESS test 1 fortran only fixed format
#Test #2: Free Format Fortran: TEST_2_fortran_only_free.f90
gfortran TEST_2_fortran_only_free.f90
./a.out
#The following should print out to the screen:#Assume Fortran 2003: has FLUSH, ALLOCATABLE, derived type, and ISO C Binding SUCCESS test 2 fortran only free format
#Test #3: C: TEST_3_c_only.c
gcc TEST_3_c_only.c
./a.out
#The following should print out to the screen: SUCCESS test 3 c only
# Test #4: Fortran Calling a C Function (our gcc and gfortran have different defaults, so we force both to always use 64 bit [-m64] when combining them): TEST_4_fortran+c_c.c, and TEST_4_fortran+x_f.f90
gcc -c -m64 TEST_4_fortran+c_c.c
gfortran -c -m64 TEST_4_fortran+c_f.f90
gfortran -m64 TEST_4_fortran+c_f.o TEST_4_fortran+c_c.o
./a.out
cd /home/wrfuser/TESTS
#Test #5:csh In the command line, type:
./TEST_csh.csh
#The result should be: SUCCESS csh test
#Test #6:perl In the command line, type:
./TEST_perl.pl
#The result should be: SUCCESS perl test
#Test #7:sh In the command line, type:
./TEST_sh.sh
#The result should be: SUCCESS sh test
cd /home/wrfuser/Build_WRF
mkdir LIBRARIES
echo "Downloading required libraries............"
cd /home/wrfuser/Build_WRF/LIBRARIES
wget http://www2.mmm.ucar.edu/wrf/OnLineTutorial/compile_tutorial/tar_files/mpich-3.0.4.tar.gz
wget http://archive.ubuntu.com/ubuntu/pool/universe/m/mpich/mpich_3.2.orig.tar.gz
wget http://www2.mmm.ucar.edu/wrf/OnLineTutorial/compile_tutorial/tar_files/netcdf-4.1.3.tar.gz
wget http://www2.mmm.ucar.edu/wrf/OnLineTutorial/compile_tutorial/tar_files/jasper-1.900.1.tar.gz
wget http://www2.mmm.ucar.edu/wrf/OnLineTutorial/compile_tutorial/tar_files/libpng-1.2.50.tar.gz
wget http://www2.mmm.ucar.edu/wrf/OnLineTutorial/compile_tutorial/tar_files/zlib-1.2.7.tar.gz
echo "Configuring NetCDF............"
cd /home/wrfuser/Build_WRF/LIBRARIES
tar xzvf netcdf-4.1.3.tar.gz     #or just .tar if no .gz present
cd netcdf-4.1.3
./configure --prefix=$DIR/netcdf --disable-dap --disable-netcdf-4 --disable-shared
make
make install
echo "Configuring mpich............"
cd /home/wrfuser/Build_WRF/LIBRARIES
tar xzvf mpich-3.0.4.tar.gz
cd mpich-3.0.4
./configure --prefix=$DIR/mpich
make
make install
echo "Configuring zlib............"
cd /home/wrfuser/Build_WRF/LIBRARIES
tar xzvf zlib-1.2.7.tar.gz     #or just .tar if no .gz present
cd zlib-1.2.7
./configure --prefix=$DIR/grib2
make
make install
echo "Configuring libpng............"
cd /home/wrfuser/Build_WRF/LIBRARIES
tar xzvf libpng-1.2.50.tar.gz     #or just .tar if no .gz present
cd libpng-1.2.50
./configure --prefix=$DIR/grib2
make
make install
echo "Configuring jasper............"
cd /home/wrfuser/Build_WRF/LIBRARIES
tar xzvf jasper-1.900.1.tar.gz     #or just .tar if no .gz present
cd jasper-1.900.1
./configure --prefix=$DIR/grib2
make
make install
echo " Testing for configured libraries........"
cd /home/wrfuser/TESTS
wget http://www2.mmm.ucar.edu/wrf/OnLineTutorial/compile_tutorial/tar_files/Fortran_C_NETCDF_MPI_tests.tar
tar -xf Fortran_C_NETCDF_MPI_tests.tar
#Test #1: Fortran + C + NetCDF
#The NetCDF-only test requires the include file from the NETCDF package be in this directory. Copy the file here:
cp ${NETCDF}/include/netcdf.inc .
#Compile the Fortran and C codes for the purpose of this test (the -c option says to not try to build an executable). Type the following commands:
gfortran -c 01_fortran+c+netcdf_f.f
gcc -c 01_fortran+c+netcdf_c.c
gfortran 01_fortran+c+netcdf_f.o 01_fortran+c+netcdf_c.o -L${NETCDF}/lib -lnetcdff -lnetcdf
./a.out | tee -a /home/wrfuser/wrflog.txt
#The following should be displayed on your screen:
#C function called by Fortran
#Values are xx = 2.00 and ii = 1
#SUCCESS test 1 fortran + c + netcdf
#Test #2: Fortran + C + NetCDF + MPI
cp ${NETCDF}/include/netcdf.inc .
mpif90 -c 02_fortran+c+netcdf+mpi_f.f
mpicc -c 02_fortran+c+netcdf+mpi_c.c
mpif90 02_fortran+c+netcdf+mpi_f.o 02_fortran+c+netcdf+mpi_c.o -L${NETCDF}/lib -lnetcdff -lnetcdf
mpirun ./a.out | tee -a /home/wrfuser/wrflog.txt
#C function called by Fortran
#Values are xx = 2.00 and ii = 1
#status = 2
#SUCCESS test 2 fortran + c + netcdf + mpi
#read -p " Do you want to install WRF, press y for yes: " n1
#if (n1==y
sudo chown wrfuser /home/wrfuser/Build_WRF
sudo chown wrfuser /home/wrfuser/Build_WRF/LIBRARIES
sudo chown wrfuser /home/wrfuser/TESTS
echo "end of script..........."
cd /home/wrfuser/Build_WRF
wget http://www2.mmm.ucar.edu/wrf/src/WRFV3.9.1.1.TAR.gz .
gunzip WRFV3.9.1.1.TAR.gz
tar -xf WRFV3.9.1.1.TAR
#echo " Download WPS......"
cd /home/wrfuser/Build_WRF
wget http://www2.mmm.ucar.edu/wrf/src/WPSV3.9.1.TAR.gz .
gunzip WPSV3.9.1.TAR.gz
tar -xvf WPSV3.9.1.TAR
