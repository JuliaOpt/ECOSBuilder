# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder


name = "GLPKBuilder"
version = v"2.0.6"

# Collection of sources required to build ECOSBuilder
sources = [
    "https://github.com/embotech/ecos/archive/v2.0.6.tar.gz" =>
    "ffc4b44e813a5c68abd464b638d216f09385d9b6e40cf487ac384289e6a27988",

]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir
cd ecos-2.0.6/
make shared
mkdir $prefix/lib

if [[ $target = *"w64"* ]]; then
    cp libecos.dll $prefix/lib
fi
if [[ $target = *"linux"* ]] || [[ $target = *"freebsd"* ]]; then
    cp libecos.so $prefix/lib;
fi
if [[ $target = *"apple"* ]]; then
    cp libecos.dylib $prefix/lib
fi
"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = [
    Linux(:i686, :glibc),
    Linux(:x86_64, :glibc),
    Linux(:aarch64, :glibc),
    Linux(:armv7l, :glibc, :eabihf),
    Linux(:powerpc64le, :glibc),
    Linux(:i686, :musl),
    Linux(:x86_64, :musl),
    Linux(:aarch64, :musl),
    Linux(:armv7l, :musl, :eabihf),
    MacOS(:x86_64),
    FreeBSD(:x86_64),
    Windows(:i686),
    Windows(:x86_64)
]

# The products that we will ensure are always built
products(prefix) = [
    LibraryProduct(prefix, "libecos", :libecos)
]

# Dependencies that must be installed before this package can be built
dependencies = [
    
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies)

