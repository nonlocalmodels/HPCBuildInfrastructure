#!/usr/bin/env bash

################################################################################
# Command-line help
################################################################################
print_usage_abort ()
{
    cat <<EOF >&2
SYNOPSIS
    ${0} {Release|RelWithDebInfo|Debug} {with-gcc|without-gcc}
    [cmake|gcc|boost|hwloc|jemalloc|vtk|hpx|octotiger|yamlcpp|blaze|blazeItertaive ...]
DESCRIPTION
    Download, configure, build, and install Octo-tiger and its dependencies or
    just the specified target.
EOF
    exit 1
}

################################################################################
# Command-line options
################################################################################
if [[ "$1" == "Release" || "$1" == "RelWithDebInfo" || "$1" == "Debug" ]]; then
    export BUILD_TYPE=$1
    echo "Build Type: ${BUILD_TYPE}"
else
    echo 'Build type must be provided and has to be "Release", "RelWithDebInfo", or "Debug"' >&2
    print_usage_abort
fi

if [[ "$2" == "without-gcc" ]]; then
    export NL_WITH_GCC=OFF
    echo " Using the system gcc"
elif [[ "$2" == "with-gcc" ]]; then
    export NL_WITH_GCC=ON
    echo "Using the compiled gcc"
else
    echo 'GCC support must be specified and has to be "with-gcc" for using the compiled gcc or "without-gcc" for using the system one' >&2
    print_usage_abort
fi

while [[ -n $3 ]]; do
    case $3 in
        cmake)
            echo 'Target cmake will build.'
            export BUILD_TARGET_CMAKE=
            shift
        ;;
        gcc)
            echo 'Target gcc will build.'
            export BUILD_TARGET_GCC=
            shift
        ;;
        openmpi)
            echo 'Target openmpi will build.'
            export BUILD_TARGET_OPENMPI=
            shift
        ;;
        boost)
            echo 'Target boost will build.'
            export BUILD_TARGET_BOOST=
            shift
        ;;
        hwloc)
            echo 'Target hwloc will build.'
            export BUILD_TARGET_HWLOC=
            shift
        ;;
        jemalloc)
            echo 'Target jemalloc will build.'
            export BUILD_TARGET_JEMALLOC=
            shift
        ;;
        hpx)
            echo 'Target hpx will build.'
            export BUILD_TARGET_HPX=
            shift
        ;;
        blaze)
            echo 'Target hpx will build.'
            export BUILD_TARGET_BLAZE=
            shift
        ;;
        blazeIterative)
            echo 'Target hpx will build.'
            export BUILD_TARGET_BLAZE_ITERATIVE=
            shift
        ;;
        yamlcpp)
            echo 'Target hpx will build.'
            export BUILD_TARGET_YAMLCPP=
            shift
        ;;
        vtk)
            echo 'Target hpx will build.'
            export BUILD_TARGET_VTK=
            shift
        ;;
        *)
            echo 'Unrecognizable argument passesd.' >&2
            print_usage_abort
        ;;
    esac
done

# Build all if no target(s) specified
if [[ -z ${!BUILD_TARGET_@} ]]; then
    echo 'No targets specified. All targets will build.'
    export BUILD_TARGET_CMAKE=
    export BUILD_TARGET_GCC=
    export BUILD_TARGET_OPENMPI=
    export BUILD_TARGET_BOOST=
    export BUILD_TARGET_HWLOC=
    export BUILD_TARGET_JEMALLOC=
    export BUILD_TARGET_HPX=
    export BUILD_TARGET_BLAZE=
    export BUILD_TARGET_BLAZE_ITERATIVE=
    export BUILD_TARGET_YAMLCPP=
    export BUILD_TARGET_VTK=
fi

################################################################################
# Diagnostics
################################################################################
set -e
set -x

################################################################################
# Configuration
################################################################################
# Script directory
export POWERTIGER_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd )"

# Set Build Configuration Parameters
source config.sh

################################################################################
# Create source and installation directories
################################################################################
mkdir -p ${SOURCE_ROOT} ${INSTALL_ROOT}

################################################################################
# Build tools
################################################################################
[[ -n ${BUILD_TARGET_GCC+x} ]] && \
(
    echo "Building GCC"
    ./build-gcc.sh
)

[[ -n ${BUILD_TARGET_CMAKE+x} ]] && \
(
    echo "Building CMake"
    ./build-cmake.sh
)

export CMAKE_COMMAND=${INSTALL_ROOT}/cmake/bin/cmake

################################################################################
# Dependencies
################################################################################
source gcc-config.sh


[[ -n ${BUILD_TARGET_BOOST+x} ]] && \
(
    echo "Building Boost"
    ./build-boost.sh
)
[[ -n ${BUILD_TARGET_HWLOC+x} ]] && \
(
    echo "Building hwloc"
    ./build-hwloc.sh
)
[[ -n ${BUILD_TARGET_JEMALLOC+x} ]] && \
(
    echo "Building jemalloc"
    ./build-jemalloc.sh
)
[[ -n ${BUILD_TARGET_HPX+x} ]] && \
(
    echo "Building HPX"
    ./build-hpx.sh
)
[[ -n ${BUILD_TARGET_BLAZE+x} ]] && \
(
    echo "Building BLAZE"
    ./build-blaze.sh
)
[[ -n ${BUILD_TARGET_BLAZE_ITERATIVE+x} ]] && \
(
    echo "Building BLAZE ITERATIVE"
    ./build-blaze-iterative.sh
)
[[ -n ${BUILD_TARGET_YAMLCPP+x} ]] && \
(
    echo "Building YAMLCPP"
    ./build-yamlcpp.sh
)
[[ -n ${BUILD_TARGET_VTK+x} ]] && \
(
    echo "Building VTK"
    ./build-vtk.sh
)
################################################################################
# Octo-tiger
################################################################################
[[ -n ${BUILD_TARGET_OCTOTIGER+x} ]] && \
(
    echo "Building Octo-tiger"
    ./build-octotiger.sh
)
