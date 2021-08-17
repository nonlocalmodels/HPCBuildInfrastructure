#!/usr/bin/env bash

set -ex

: ${SOURCE_ROOT:?} ${INSTALL_ROOT:?} ${GCC_VERSION:?} ${JEMALLOC_VERSION:?}

DIR_SRC=${SOURCE_ROOT}/gmsh
#DIR_BUILD=${INSTALL_ROOT}/jemalloc/build
DIR_INSTALL=${INSTALL_ROOT}/gmsh
FILE_MODULE=${INSTALL_ROOT}/modules/flann/${GMSH_VERSION}

#./build-eigen.sh

DOWNLOAD_URL="https://gmsh.info/src/gmsh-${GMSH_VERSION}-source.tgz"

if [[ ! -d ${DIR_INSTALL} ]]; then
    (
        mkdir -p ${DIR_SRC}
        cd ${DIR_SRC}
        wget ${DOWNLOAD_URL} 
        tar -xf gmsh-${GMSH_VERSION}-source.tgz
        cd gmsh-${GMSH_VERSION}-source
        ${CMAKE_COMMAND} \
        -DCMAKE_INSTALL_PREFIX=${DIR_INSTALL} \
        -DCMAKE_BUILD_TYPE=${BUILD_TYPE} \
        -DCMAKE_CXX_FLAGS="${CXXFLAGS}" \
        -DCMAKE_EXE_LINKER_FLAGS="${LDCXXFLAGS}" \
        -DCMAKE_SHARED_LINKER_FLAGS="${LDCXXFLAGS}" \
        -DENABLE_BUILD_SHARED=YES \
        -DENABLE_BUILD_LIB=YES \
        -DENABLE_BUILD_DYNAMIC=YES
        make -j${PARALLEL_BUILD}
        make install
    )
fi

mkdir -p $(dirname ${FILE_MODULE})
cat >${FILE_MODULE} <<EOF
#%Module
proc ModulesHelp { } {
  puts stderr {blaze}
}
module-whatis {flann}
set root    ${DIR_INSTALL}
conflict    flann
module load gcc/${GCC_VERSION}
prereq      gcc/${GCC_VERSION}
prepend-path    CPATH              \$root/include
prepend-path    PATH               \$root/bin
prepend-path    PATH               \$root/sbin
prepend-path    MANPATH            \$root/share/man
prepend-path    LD_LIBRARY_PATH    \$root/lib
prepend-path    LIBRARY_PATH       \$root/lib
prepend-path    PKG_CONFIG_PATH    \$root/lib/pkgconfig
setenv          FLANN_ROOT      \$root
setenv          flann_VERSION   ${FLANN_VERSION}
EOF

