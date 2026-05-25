#!/bin/bash
set -e -x

sed -i.bak "s/@TARGET_MULTIARCH@/${CONDA_TOOLCHAIN_HOST/conda-/}/g" src/EGL/meson.build
cat src/EGL/meson.build

# Get meson to find pkg-config when cross compiling
export PKG_CONFIG="${BUILD_PREFIX}/bin/pkg-config"

meson setup builddir \
    ${MESON_ARGS} \
    -Dasm=enabled \
    -Dx11=enabled \
    -Degl=true \
    -Dglx=enabled \
    -Dgles1=true \
    -Dgles2=true \
    -Dtls=true \
    -Ddispatch-tls=true \
    -Dheaders=true

ninja -v -C builddir
ninja -C builddir install
