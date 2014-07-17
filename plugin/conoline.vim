scriptencoding utf-8

if exists("g:loaded_conoline")
  finish
endif
let g:loaded_conoline = 1

let s:save_cpo = &cpo
set cpo&vim

command! ConoLineEnable call conoline#enable()
command! ConoLineDisable call conoline#disable()
command! ConoLineToggle call conoline#toggle()

if exists("g:conoline_auto_enable") && g:conoline_auto_enable == 1
  augroup conoline_vimenter
    autocmd VimEnter * call conoline#enable()
  augroup END
endif

let &cpo = s:save_cpo
unlet s:save_cpo
" vim set\ ts=2\ sts=2\ sw=2\ et
