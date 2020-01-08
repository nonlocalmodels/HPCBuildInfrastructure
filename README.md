# HPCBuildInfrastructure



## Dependencies and version

Please edit the config.sh to specify the version of all dependencies you like 
to use. Even if you are not building the gcc with this script, you should 
provide the version number so the module files will work correctly. 

## Building and installation
```bash
./build-all.sh Release without-gcc hpx
```
This will build hpx in the `Release` type using the system gcc.

Arguments:

1. `Release|RelWithDebInfo|Debug` - Build type 
2. `with-gcc|without-gcc` - Build the gnu compiler or use the one loaded by a module file
3. `cmake|gcc|boost|hwloc|jemalloc|vtk|hpx|yamlcpp|blaze|blazeiterative|NL`
