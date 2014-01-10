# Script to create static libraries for windows using on mingw-w64 v3.0
# cross compiler on Ubuntu 14.04 (older versions of mingw-w64 didn't work)

# install cross compilers
sudo apt-get install make gcc-mingw-w64-x86-64 gcc-mingw-w64-i686 mingw-w64

# create output dirs
mkdir -p lib/{i386,x64}

# get libprotobuf
wget https://protobuf.googlecode.com/files/protobuf-2.5.0.tar.gz
tar xzvf protobuf-2.5.0.tar.gz
cd protobuf-2.5.0

# Build for win32
./configure --host=i686-w64-mingw32 --disable-shared
make
cp src/.libs/libprotobuf.a ../lib/i386/
make clean

# Build for win64
./configure --host=x86_64-w64-mingw32 --disable-shared
make
cp src/.libs/libprotobuf.a ../lib/x64/
make clean

