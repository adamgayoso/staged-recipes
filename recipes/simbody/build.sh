#!/bin/bash

# FIXME: This is a hack to make sure the environment is activated.
# The reason this is required is due to the conda-build issue
# mentioned below.
#
# https://github.com/conda/conda-build/issues/910
source activate "${CONDA_DEFAULT_ENV}"

mkdir build
cd build
if [[ "$OSTYPE" == "linux-gnu" ]]; then
	cmake .. \
		-LAH \
		-DCMAKE_INSTALL_PREFIX="$PREFIX" \
		-DBUILD_USING_OTHER_LAPACK="$PREFIX/lib/libopenblas.so" \
		-DBUILD_VISUALIZER=off
	make -j$(nproc)
	ctest -j$(nproc)
	make -j$(nproc) install
elif [[ "$OSTYPE" == "darwin"* ]]; then
	cmake .. \
		-LAH \
		-DCMAKE_INSTALL_PREFIX="$PREFIX" \
		-DBUILD_USING_OTHER_LAPACK="$PREFIX/lib/libopenblas.dylib" \
		-DBUILD_VISUALIZER=off
	make
	ctest
	make install
fi
