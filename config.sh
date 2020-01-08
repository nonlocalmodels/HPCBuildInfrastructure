: ${POWERTIGER_ROOT:?} ${BUILD_TYPE:?}

export INSTALL_ROOT=${POWERTIGER_ROOT}/build
export SOURCE_ROOT=${POWERTIGER_ROOT}/src

################################################################################
# Package Configuration
################################################################################
# BLAZE
export BLAZE_VERSION=3.5

# BLAZE Iterative
export BLAZE_ITERATIVE_VERSION=

# YAML-CPP
export YAML_CPP_VERSION=

# CMAKE
export CMAKE_VERSION=3.13.2

# HWLOC
export HWLOC_VERSION=1.11.12

# BOOST 
export BOOST_VERSION=1.68.0
export BOOST_ROOT=${INSTALL_ROOT}/boost
export BOOST_BUILD_TYPE=$(echo ${BUILD_TYPE/%WithDebInfo/ease} | tr '[:upper:]' '[:lower:]')

# Jemalloc
export JEMALLOC_VERSION=5.1.0

# GCC
export GCC_VERSION=9.1.0

# HPX
export HPX_VERSION=1.3.0

# Max number of parallel jobs
export PARALLEL_BUILD=$(grep -c ^processor /proc/cpuinfo)
