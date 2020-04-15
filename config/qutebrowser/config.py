
c.url.searchengines = {"DEFAULT": "https://google.com/search?q={}", "wa": "https://wiki.archlinux.org/?search={}", "g": "https://google.com/search?q={}"}
c.auto_save.session = True
config.bind('d', 'scroll-page 0 0.5 ')
config.bind('x', 'tab-close')
config.bind('<ctrl-b>', 'buffer')

config.bind('<z><l>', 'spawn --userscript qute-pass')
config.bind(',m', 'spawn mpv --title=mpv_youtube {url}')
config.bind(',M', 'hint links spawn mpv --title=mpv_youtube mpv {hint-url}')

config.bind('<z><u><l>', 'spawn --userscript qute-pass --username-only')
config.bind('<z><p><l>', 'spawn --userscript qute-pass --password-only')
config.bind('<z><o><l>', 'spawn --userscript qute-pass --otp-only')

c.fonts.tabs="Unifont, Medium 8"
