
c.url.searchengines = {"DEFAULT": "https://google.com/search?q={}", "wa": "https://wiki.archlinux.org/?search={}", "g": "https://google.com/search?q={}"}
c.auto_save.session = True
config.bind('d', 'scroll-page 0 0.5 ')
config.bind('x', 'tab-close')
config.bind('<ctrl-b>', 'buffer')
config.bind(',p', 'spawn --userscript qute-pass --dmenu-invocation dmenu')

c.fonts.tabs="Unifont, Medium 8"
