return {
    cmd = { 'qmlls' },
    filetypes = { 'qml' },
    root_markers = { '.qmlls.ini', 'CMakeLists.txt', '.git' },
    on_error = function(code, err)
        if type(err) == 'string' and err:find('table index is nil') then return end
        vim.notify(('qmlls error %d: %s'):format(code, err), vim.log.levels.ERROR)
    end,
}
