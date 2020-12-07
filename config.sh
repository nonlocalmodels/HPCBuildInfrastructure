: ${POWERTIGER_ROOT:?} ${BUILD_TYPE:?}

export INSTALL_ROOT=${POWERTIGER_ROOT}/build
export SOURCE_ROOT=${POWERTIGER_ROOT}/src

################################################################################
# Package Configuration
################################################################################
# BLAZE
export BLAZE_VERSION=3.5

# BLAZE Iterative
export BLAZE_ITERATIVE_VERSION=master

# YAML-CPP
export YAMLCPP_VERSION=0.6.3

# CMAKE
export CMAKE_VERSION=3.18.4

# HWLOC
export HWLOC_VERSION=2.2.0

# BOOST 
export BOOST_VERSION=1.73.0
export BOOST_ROOT=${INSTALL_ROOT}/boost
export BOOST_BUILD_TYPE=$(echo ${BUILD_TYPE/%WithDebInfo/ease} | tr '[:upper:]' '[:lower:]')

# Jemalloc
export JEMALLOC_VERSION=5.1.0

# GCC
export GCC_VERSION=9.3.0

# HPX
export HPX_VERSION=1.5.0

# VTK 
export VTK_VERSION=9.0.1

#FLANN
export FLANN_VERSION=1.9.1

# Max number of parallel jobs
export PARALLEL_BUILD=$(grep -c ^processor /proc/cpuinfo)
