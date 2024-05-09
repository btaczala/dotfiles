recipes_path := "/Users/bartek/Projects/inmusic/ev/ev_conan_recipes"
docker_volumes_path := "/Users/bartek/Projects/inmusic/ev/docker_images"

docker_build:
    cd {{ recipes_path }} && docker buildx build \
        --platform linux/amd64 \
        -t arkaos:linux \
        -f docker/Dockerfile.linux \
        --load \
        . 

_docker *args:
    mkdir -p {{ docker_volumes_path }}/conan_root
    mkdir -p {{ docker_volumes_path }}/workdir
    docker run \
        --platform=linux/amd64 \
        --mount type=bind,source={{ recipes_path }}/recipes,target=/ev_conan_recipes/recipes \
        --mount type=bind,source={{ recipes_path }}/python,target=/ev_conan_recipes/python \
        --mount type=bind,source={{ docker_volumes_path }}/conan_root,target=/root/.conan2 \
        --mount type=bind,source={{ docker_volumes_path }}/workdir,target=/workdir \
        --mount type=volume,source=arkaos-linux-conan-packages,target=/root/.conan2/p \
        arkaos:linux \
        {{ args }}

docker_install_conan2: docker_build
    @just _docker python3 /ev_conan_recipes/python/arkaos_build_settings/conan2_setup.py --install --dest /workdir/conan2
    @just _docker rm -rf /root/.conan2/source_credentials.json

_docker_conan_all_no_build:
    @just _docker /workdir/conan2/conan2 install  \
        -pr:b Linux-GNU-11-x86_64-Release-None \
        -pr:h Linux-GNU-11-x86_64-Release-None \
        --build=missing \
        /workdir

docker_conan_list_packages: docker_build
    @just _docker python3 /ev_conan_recipes/python/list_packages.py \
        --platform Linux-GNU-11-x86_64 \
        --build_type Release \
        --variant default \
        --recipes /ev_conan_recipes/ \
        --dest /workdir

docker_conan_export_package package version path="all": docker_build
    @just _docker /workdir/conan2/conan2 export \
        /ev_conan_recipes/recipes/{{ package }}/{{ path }}/conanfile.py \
        --version {{ version }} \
        --user visualbrands

docker_conan_package package version path="all": docker_build
    @just docker_conan_export_package {{package}} {{version}} {{path}}
    @just _docker /workdir/conan2/conan2 export \
        /ev_conan_recipes/recipes/{{ package }}/{{ path }}/conanfile.py \
        --version {{ version }} \
        --user visualbrands
    @just _docker_conan_all_no_build

docker_conan_all: docker_conan_list_packages
    @just _docker /workdir/conan2/conan2 install  \
        -pr:b Linux-GNU-11-x86_64-Release-None \
        -pr:h Linux-GNU-11-x86_64-Release-None \
        --build=missing \
        /workdir

docker_bash: docker_build
    docker run \
        -it \
        --platform=linux/amd64 \
        --mount type=bind,source={{ recipes_path }}/../docker_volume,target=/out \
        --mount type=bind,source={{ recipes_path }}/../docker_conan_volume,target=/root/.conan2/p \
        arkaos:linux \
        bash

linun_fixes: conan_list
    @just docker_conan_export_package edk 1.0.0
    @just docker_conan_export_package vulkan-loader 1.3.250.0
    @just docker_conan_export_package mvr-gdtf 9.0.6
    @just docker_conan_all
