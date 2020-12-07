#!/usr/bin/env bash

set -ex

: ${SOURCE_ROOT:?} ${INSTALL_ROOT:?} ${GCC_VERSION:?} ${JEMALLOC_VERSION:?}

DIR_SRC=${SOURCE_ROOT}/flann
#DIR_BUILD=${INSTALL_ROOT}/jemalloc/build
DIR_INSTALL=${INSTALL_ROOT}/flann
FILE_MODULE=${INSTALL_ROOT}/modules/flann/${FLANN_VERSION}

DOWNLOAD_URL="https://github.com/mariusmuja/flann/archive/${FLANN_VERSION}.tar.gz"

if [[ ! -d ${DIR_INSTALL} ]]; then
    (
        mkdir -p ${DIR_SRC}
        cd ${DIR_SRC}
        wget ${DOWNLOAD_URL} 
        tar -xf ${FLANN_VERSION}.tar.gz
        cd flann-${FLANN_VERSION}
        wget https://src.fedoraproject.org/rpms/flann/raw/master/f/flann-1.8.4-srcfile.patch
        git apply flann-1.8.4-srcfile.patch 
        ${CMAKE_COMMAND} \
        -DCMAKE_INSTALL_PREFIX=${DIR_INSTALL} \
        -DCMAKE_BUILD_TYPE=${BUILD_TYPE} \
        -DCMAKE_CXX_FLAGS="${CXXFLAGS}" \
        -DCMAKE_EXE_LINKER_FLAGS="${LDCXXFLAGS}" \
        -DCMAKE_SHARED_LINKER_FLAGS="${LDCXXFLAGS}" \
        -DBUILD_MATLAB_BINDINGS=OFF \
        -DBUILD_PYTHON_BINDINGS=OFF \
        -DUSE_OPENMP=OFF \
        -DBUILD_DOC=OFF \
        -DBUILD_TESTS=OFF
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

