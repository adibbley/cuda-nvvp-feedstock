#!/bin/bash

# Install to conda style directories
[[ -d lib64 ]] && mv lib64 lib

[[ ${target_platform} == "linux-64" ]] && targetsDir="targets/x86_64-linux"
[[ ${target_platform} == "linux-ppc64le" ]] && targetsDir="targets/ppc64le-linux"
[[ ${target_platform} == "linux-aarch64" ]] && targetsDir="targets/sbsa-linux"

for i in `ls`; do
    [[ $i == "build_env_setup.sh" ]] && continue
    [[ $i == "conda_build.sh" ]] && continue
    [[ $i == "metadata_conda_debug.yaml" ]] && continue

    if [[ $i == "libnvvp" ]]; then
        for j in `find "${i}" -maxdepth 1`; do
	        [[ "${j}" == "libnvvp/nvvp" ]] || continue
            echo patchelf --force-rpath --set-rpath "\$ORIGIN/../lib:\$ORIGIN/../${targetsDir}/lib" "${j}" ...
            patchelf --force-rpath --set-rpath "\$ORIGIN/../lib:\$ORIGIN/../${targetsDir}/lib" "${j}"
        done
    fi

    cp -rv $i ${PREFIX}
done
