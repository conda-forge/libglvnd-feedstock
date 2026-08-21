#!/bin/bash
set -e -x

sed -i.bak "s/@TARGET_MULTIARCH@/${CONDA_TOOLCHAIN_HOST/conda-/}/g" src/EGL/meson.build
cat src/EGL/meson.build

# Get meson to find pkg-config when cross compiling
export PKG_CONFIG="${BUILD_PREFIX}/bin/pkg-config"

ASM=enabled
if [[ $target_platform == "linux-riscv64" ]]; then
    # riscv is missing https://gitlab.freedesktop.org/glvnd/libglvnd/-/merge_requests/287
    ASM=disabled
fi

meson setup builddir \
    ${MESON_ARGS} \
    -Dasm=${ASM} \
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
