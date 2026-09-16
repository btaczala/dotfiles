return {
    cmd = { 'clangd', '--background-index', '--clang-tidy', '--log=error', '--header-insertion=never',
        '--background-index-priority=background' },
    filetypes = { 'c', 'cpp', 'objc', 'objcpp' },
    root_markers = { 'compile_commands.json', 'compile_flags.txt', 'CMakeLists.txt', '.git' },
}
