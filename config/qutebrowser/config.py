config.load_autoconfig()
c.tabs.position = "top"
# Remap 'jkl;' to replace 'hjkl'
config.bind('j', 'scroll left')  # Remap 'h' functionality to 'j'
config.bind('k', 'scroll down')  # Remap 'j' functionality to 'k'
config.bind('l', 'scroll up')    # Remap 'k' functionality to 'l'
config.bind(';', 'scroll right') # Remap 'l' functionality to ';'
config.bind('<Meta-Shift-]>', 'tab-next') # Remap 'l' functionality to ';'
config.bind('<Meta-Shift-[>', 'tab-prev') # Remap 'l' functionality to ';'
config.bind('<Meta-r>', 'reload -f') # Remap 'l' functionality to ';'
config.bind('<Meta-t>', 'open -t') # Remap 'l' functionality to ';'
config.bind('<Ctrl-o>', 'back') # Remap 'l' functionality to ';'
config.bind('<Ctrl-i>', 'forward') # Remap 'l' functionality to ';'

config.set('hints.chars', 'asdfjkl;')
config.set('window.hide_decoration', False)

