import 'ev_conan_recipes_docker.justfile'

conan_path := "/Users/bartek/Projects/inmusic/conan2/conan2"
build_type := "Debug"
sanitizer := "None"

vpn_start:
    networksetup -connectpppoeservice  "InMusic Belgium"
    ping debian-server-arkaos.corp.numark.com -c 1

conan_config:
    {{ conan_path }} config install http://imb-store-0-be.corp.numark.com:8084/conan/configs/conan_configs_v2.zip
    rm -rf ~/.conan2/source_credentials.json

conan_list build_type="Release": vpn_start conan_config
    cd {{ invocation_directory() }} && python3 {{ invocation_directory() }}/python/list_packages.py --platform Darwin-AppleClang-14.0-arm64 --build_type {{ build_type }} --variant default
    yapf -i {{ invocation_directory() }}/conanfile.py
    python3 -m json.tool {{ invocation_directory() }}/options.json > {{ invocation_directory() }}/nice_options.json
    mv {{ invocation_directory() }}/nice_options.json {{ invocation_directory() }}/options.json

config_install:
    {{ conan_path }} config install http://imb-store-0-be.corp.numark.com:8084/conan/configs/conan_configs_v2.zip

_conan_install package version *args:
    {{ conan_path }} install \
    --profile:host Darwin-AppleClang-14.0-arm64-{{ build_type }}-{{ sanitizer }} \
    --profile:build Darwin-AppleClang-14.0-arm64-{{ build_type }}-{{ sanitizer }} \
    --build="missing" \
    --user=visualbrands \
    {{ invocation_directory() }}/conanfile.py \
    {{ args }}

conan_create package version recipe_path *args: vpn_start
    {{ conan_path }} create {{ invocation_directory() }}/{{ recipe_path }} --name {{ package }} \
        --version {{ version }} \
        --user visualbrands \
        --profile:host Darwin-AppleClang-14.0-arm64-{{ build_type }}-{{ sanitizer }} \
        --profile:build Darwin-AppleClang-14.0-arm64-{{ build_type }}-{{ sanitizer }} \
        --build=missing {{ args }} \
        --no-remote

clean:
    rm -rf ~/.conan2

_conan_export name version path:
    {{ conan_path }} export {{ invocation_directory() }}/{{ path }} --version {{ version }} --name {{ name }} --user visualbrands

_conan_test name version path *args:
    {{ conan_path }} test {{ invocation_directory() }}/recipes/{{ name }}/{{ path }}/test_package \
        --profile:host Darwin-AppleClang-14.0-arm64-{{ build_type }}-{{ sanitizer }} \
        --profile:build Darwin-AppleClang-14.0-arm64-{{ build_type }}-{{ sanitizer }} \
        {{ name }}/{{ version }}@visualbrands {{ args }}

conan_package name version path="all": conan_list
    @just _conan_export {{ name }} {{ version }} recipes/{{ name }}/{{ path }}/conanfile.py
    @just _conan_install {{ name }} {{ version }}
    @just _conan_test {{ name }} {{ version }} {{ path }}

conan_all: vpn_start
    {{ conan_path }} install \
    --profile:host Darwin-AppleClang-14.0-arm64-{{ build_type }}-{{ sanitizer }} \
    --profile:build Darwin-AppleClang-14.0-arm64-{{ build_type }}-{{ sanitizer }} \
    --build="missing" \
    --format=json \
    --user=visualbrands \
    {{ invocation_directory() }}/conanfile.py

conan_test: conan_list
    cd {{ invocation_directory() }} && python3 python/test_packages.py \
        --platform Darwin-AppleClang-14.0-arm64 --build_type {{ build_type }} \
        --sanitizer {{ sanitizer }} \
        --conan2 ../../conan2

