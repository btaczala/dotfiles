import 'ev_conan_recipes_docker.justfile'

conan_path := "/Users/bartek/Projects/inmusic/conan2/conan2"
conan_dir := "/Users/bartek/Projects/inmusic/conan2/"
build_type := "Debug"
sanitizer := "None"
variant := "default"
profile := "Darwin-AppleClang-14.0-arm64"

vpn_start:
    #!/usr/bin/env -S bash -x
    networksetup -connectpppoeservice  "InMusic Belgium"
    while ! ping debian-server-arkaos.corp.numark.com -c 1
    do
        sleep 2
    done

conan_setup:
    python3 python/arkaos_build_settings/conan2_setup.py --install --dest {{conan_dir}}

conan_config: vpn_start
    rm -rf ~/.conan2/source_credentials.json
    {{conan_path}} config install conf

clean:
    rm -rf ~/.conan2

_conan_export name version path:
    {{ conan_path }} export {{ invocation_directory() }}/{{ path }} --version {{ version }} --name {{ name }}

conan_all *args:
    # python3 python/list_options.py --recipes recipes --dest conf/profiles
    @just conan_config
    # python3 python/build_packages.py --platform Darwin-AppleClang-14.0-arm64 --build_type {{build_type}} --variant {{variant}} --recipes ./recipes --conan2 {{conan_dir}} --dest out --verbose --sanitizer {{sanitizer}} --color  --skip-upload {{args}} 
    python3 python/build_packages.py --platform Darwin-AppleClang-14.0-arm64 --build-type {{build_type}} --variant {{variant}} --recipes ./recipes --conan2 {{conan_dir}} --dest out --verbose --sanitizer {{sanitizer}} --color  {{args}} 

conan_test_all: conan_config
    @just conan_all --test_all

conan_package name version path="all": conan_config
    python3 python/list_options.py --recipes recipes --dest conf/profiles
    @just conan_config
    @just sanitizer={{ sanitizer }} build_type={{ build_type }} _conan_export {{ name }} {{ version }} recipes/{{ name }}/{{ path }}/conanfile.py
    @just sanitizer={{ sanitizer }} variant={{ variant }} build_type={{ build_type }} conan_all

move file:
    sha256sum ~/Downloads/{{file}} | awk '{print $1}' | pbcopy
    mv ~/Downloads/{{file}} /Volumes/Shares/ci/conan
