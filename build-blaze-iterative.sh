#!/usr/bin/env bash

set -ex

: ${SOURCE_ROOT:?} ${INSTALL_ROOT:?} ${GCC_VERSION:?} ${BLAZE_ITERATIVE_VERSION:?}

DIR_SRC=${SOURCE_ROOT}/blaze-iterative
#DIR_BUILD=${INSTALL_ROOT}/jemalloc/build
DIR_INSTALL=${INSTALL_ROOT}/blaze-iterative
FILE_MODULE=${INSTALL_ROOT}/modules/blaze/${BLAZE_ITERATIVE_VERSION}


if [[ ! -d ${DIR_INSTALL} ]]; then
    (
        mkdir -p ${DIR_SRC}
        cd ${DIR_SRC}
        cd ..
        git clone https://github.com/STEllAR-GROUP/BlazeIterative.git        
        cd BlazeIterative
        ${CMAKE_COMMAND} \
        -DCMAKE_INSTALL_PREFIX=${DIR_INSTALL} \
        -DCMAKE_BUILD_TYPE=${BUILD_TYPE} \
        -DCMAKE_CXX_FLAGS="${CXXFLAGS}" \
        -DCMAKE_EXE_LINKER_FLAGS="${LDCXXFLAGS}" \
        -DCMAKE_SHARED_LINKER_FLAGS="${LDCXXFLAGS}" \
        -Dblaze_DIR=${INSTALL_ROOT}/blaze 
        make -j${PARALLEL_BUILD}
        make install
    )
fi

mkdir -p $(dirname ${FILE_MODULE})
cat >${FILE_MODULE} <<EOF
#%Module
proc ModulesHelp { } {
  puts stderr {blaze-iterative}
}
module-whatis {blaze_iterative}
set root    ${DIR_INSTALL}
conflict    blaze-iterative
module load gcc/${GCC_VERSION}
prereq      gcc/${GCC_VERSION}
prepend-path    CPATH              \$root/include
prepend-path    PATH               \$root/bin
prepend-path    PATH               \$root/sbin
prepend-path    MANPATH            \$root/share/man
prepend-path    LD_LIBRARY_PATH    \$root/lib
prepend-path    LIBRARY_PATH       \$root/lib
prepend-path    PKG_CONFIG_PATH    \$root/lib/pkgconfig
setenv          blaze_iterative_ROOT \$root
setenv          BLAZE_ITERATIV__VERSION   ${BLAZE_ITERATIve__VERSION}
EOF

