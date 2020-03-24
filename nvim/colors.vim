let g:PaperColor_Theme_Options = {
  \   'theme': {
  \     'default': {
  \       'transparent_background': 1
  \     }
  \   },
  \   'language': {
  \     'python': {
  \       'highlight_builtins' : 1
  \     },
  \     'cpp': {
  \       'highlight_standard_library': 1
  \     },
  \     'c': {
  \       'highlight_builtins' : 1
  \     }
  \   }
  \ }

if has('mac')
    let iterm_profile = $ITERM_PROFILE
    colorscheme PaperColor
    if iterm_profile == "dark"
        set background=dark
    else
        set background=light        " Set solarized background color
    endif
else
    let color = system('cat ~/.current_color')

    if color =~# "light"
        set background=light
    else
        set background=dark
    endif
endif

" functions
if exists("*ToggleBackground") == 0
    function ToggleBackground()
        if &background == "dark"
            set background=light
        else
            set background=dark
        endif
    endfunction

    command BG call ToggleBackground()
endif

fun! TrimWhitespace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfun

colorscheme PaperColor
