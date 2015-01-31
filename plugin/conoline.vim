scriptencoding utf-8

if exists('g:loaded_conoline')
  finish
endif
let g:loaded_conoline = 1

let s:save_cpo = &cpo
set cpo&vim

" ======== Default variables ========"{{{
if !exists('g:conoline_auto_enable')
  let g:conoline_auto_enable = 1
endif

if !exists('g:conoline_use_colorscheme_default_normal')
  let  g:conoline_use_colorscheme_default_normal = 0
endif
if !exists('g:conoline_use_colorscheme_default_insert')
  let  g:conoline_use_colorscheme_default_insert = 0
endif

" Set default colors for light colorscheme
if !exists('g:conoline_color_insert_light')
  let g:conoline_color_insert_light = 'guibg=#ffffff ctermbg=15'
endif
if !exists('g:conoline_color_insert_nr_light')
  let g:conoline_color_insert_nr_light = 'guibg=#ffffff ctermbg=15'
endif
if !exists('g:conoline_color_normal_light')
  let g:conoline_color_normal_light = 'guibg=#eaeaea ctermbg=255'
endif
if !exists('g:conoline_color_normal_nr_light')
  let g:conoline_color_normal_nr_light = 'guibg=#eaeaea ctermbg=255'
endif

" Set default colors for dark colorscheme
if !exists('g:conoline_color_insert_dark')
  let g:conoline_color_insert_dark = 'guibg=#000000 ctermbg=232'
endif
if !exists('g:conoline_color_insert_nr_dark')
  let g:conoline_color_insert_nr_dark = 'guibg=#000000 ctermbg=232'
endif
if !exists('g:conoline_color_normal_dark')
  let g:conoline_color_normal_dark = 'guibg=#181818 ctermbg=234'
endif
if !exists('g:conoline_color_normal_nr_dark')
  let g:conoline_color_normal_nr_dark = 'guibg=#181818 ctermbg=234'
endif
"}}}

" ======== Commands ========"{{{
command! ConoLineEnable call conoline#enable()
command! ConoLineDisable call conoline#disable()
command! ConoLineToggle call conoline#toggle()
command! ConoLineColorLight call conoline#set_hl('light')
command! ConoLineColorDark call conoline#set_hl('dark')
"}}}

" ======== Auto Commands ========"{{{
if g:conoline_auto_enable
  augroup conoline_vimenter
    autocmd VimEnter * call conoline#enable()
  augroup END
endif
"}}}

let &cpo = s:save_cpo
unlet s:save_cpo
" vim set\ ts=2\ sts=2\ sw=2\ et
