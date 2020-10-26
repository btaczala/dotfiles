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


function! SwitchBackgroudIfNeeded(...)
    if has('mac')
        let s:mode = systemlist("defaults read -g AppleInterfaceStyle")[0]
        if s:mode ==? "dark"
            let s:new_bg = "dark"
        else
            let s:new_bg = "light"
        endif
        if &background !=? s:new_bg
            let &background = s:new_bg
        endif
    endif
endfunction

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

colorscheme toast
call SwitchBackgroudIfNeeded()
autocmd  FocusGained  *   :call SwitchBackgroudIfNeeded()
