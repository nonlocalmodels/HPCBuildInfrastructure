#!/usr/bin/env bash

set -ex

: ${SOURCE_ROOT:?} ${INSTALL_ROOT:?} ${GCC_VERSION:?} ${VTK_VERSION:?}

DIR_SRC=${SOURCE_ROOT}/nl
#DIR_BUILD=${INSTALL_ROOT}/jemalloc/build
DIR_INSTALL=${INSTALL_ROOT}/nl
FILE_MODULE=${INSTALL_ROOT}/modules/nl/${NL_VERSION}


if [[ ! -d ${DIR_INSTALL} ]]; then
    (
        mkdir -p ${DIR_SRC}
        cd ${DIR_SRC} 
        git clone https://github.com/nonlocalmodels/NLMech.git
        cd NLMech 
        git checkout ${NL_VERSION}
        mkdir -p build 
        cd build 
        ${CMAKE_COMMAND} \
        -DCMAKE_INSTALL_PREFIX=${DIR_INSTALL} \
        -DCMAKE_BUILD_TYPE=${BUILD_TYPE} \
        -DCMAKE_CXX_FLAGS="${CXXFLAGS}" \
        -DCMAKE_EXE_LINKER_FLAGS="${LDCXXFLAGS}" \
        -DCMAKE_SHARED_LINKER_FLAGS="${LDCXXFLAGS}" \
        -DHPX_DIR="${INSTALL_ROOT}/hpx/lib64/cmake/HPX" \
        -Dblaze_DIR="${INSTALL_ROOT}/blaze/share/blaze/cmake" \
        -Dblaze_INCLUDE_DIR="${INSTALL_ROOT}/blaze/include" \
        -DBLAZEITERATIVE_DIR="${INSTALL_ROOT}/blaze-iterative/" \
        -DYAML_CPP_DIR="${INSTALL_ROOT}/yamlcpp/" \
        -DBOOST_ROOT=${BOOST_ROOT} \
        -DVTK_DIR="${INSTALL_ROOT}/vtk/lib64/cmake/vtk-${VTK_VERSION::-2}" \
        -DGMSH_DIR="${INSTALL_ROOT}/gmsh/" \
        -DEnable_PCL=ON \
        -DPCL_DIR="${INSTALL_ROOT}/pcl/share/pcl-${PCL_VERSION::-2}" \
        -DEnable_Tools=ON \
        .. 
        make -j${PARALLEL_BUILD}
        make install
    )
fi

mkdir -p $(dirname ${FILE_MODULE})
cat >${FILE_MODULE} <<EOF
#%Module
proc ModulesHelp { } {
  puts stderr {NL}
}
module-whatis {NL}
set root    ${DIR_INSTALL}
conflict    NL
module load gcc/${GCC_VERSION}
prereq      gcc/${GCC_VERSION}
prepend-path    CPATH              \$root/include
prepend-path    PATH               \$root/bin
prepend-path    PATH               \$root/sbin
prepend-path    MANPATH            \$root/share/man
prepend-path    LD_LIBRARY_PATH    \$root/lib
prepend-path    LIBRARY_PATH       \$root/lib
prepend-path    PKG_CONFIG_PATH    \$root/lib/pkgconfig
setenv          NL_ROOT      \$root
setenv          NL_VERSION   ${NL_VERSION}
EOF

