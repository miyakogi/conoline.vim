scriptencoding utf-8

let s:save_cpo = &cpo
set cpo&vim

function! s:insert()
  highlight! def link CursorLine CursorLineInsert
  highlight! def link CursorLineNr CursorLineInsertNr
endfunction

function! s:normal()
  highlight! def link CursorLine CursorLineNormal
  highlight! def link CursorLineNr CursorLineNormalNr
endfunction

function! s:winenter()
  setlocal cursorline
endfunction

function! s:winleave()
  setlocal nocursorline
endfunction

function! conoline#disable()
  setlocal nocursorline
  autocmd! conoline_only_active_window
  autocmd! conoline_color_insert
  autocmd! conoline_color_enable
  let s:coloring = 0
endfunction

function! s:setcolors()
  " TODO: Refactor this function.
  if &background == "light"
    if !exists("g:conoline_color_insert_light")
      let g:conoline_color_insert_light = "guibg=#ffffff ctermbg=15"
    endif
    if !exists("g:conoline_color_insert_nr_light")
      let g:conoline_color_insert_nr_light = "guibg=#ffffff ctermbg=15"
    endif
    if !exists("g:conoline_color_normal_light")
      let g:conoline_color_normal_light = "guibg=#eaeaea ctermbg=255"
    endif
    if !exists("g:conoline_color_normal_nr_light")
      let g:conoline_color_normal_nr_light = "guibg=#eaeaea ctermbg=255"
    endif
    let s:color_insert = g:conoline_color_insert_light
    let s:color_insert_nr = g:conoline_color_insert_nr_light
    let s:color_normal = g:conoline_color_normal_light
    let s:color_normal_nr = g:conoline_color_normal_nr_light
  else
    if !exists("g:conoline_color_insert_dark")
      let g:conoline_color_insert_dark = "guibg=#000000 ctermbg=232"
    endif
    if !exists("g:conoline_color_insert_nr_dark")
      let g:conoline_color_insert_nr_dark = "guibg=#000000 ctermbg=232"
    endif
    if !exists("g:conoline_color_normal_dark")
      let g:conoline_color_normal_dark = "guibg=#181818 ctermbg=234"
    endif
    if !exists("g:conoline_color_normal_nr_dark")
      let g:conoline_color_normal_nr_dark = "guibg=#181818 ctermbg=234"
    endif
    let s:color_insert = g:conoline_color_insert_dark
    let s:color_insert_nr = g:conoline_color_insert_nr_dark
    let s:color_normal = g:conoline_color_normal_dark
    let s:color_normal_nr = g:conoline_color_normal_nr_dark
  endif
endfunction

function! conoline#enable()
  if !exists("s:coloring")
    let s:coloring = 1
  endif

  call s:setcolors()

  " Set highlight according to options.
  if exists("g:conoline_use_colorscheme_default_normal") && g:conoline_use_colorscheme_default_normal == 1
    " NOTE: I wonder why this loop works as I expected...
    highlight! def link CursorLineNormal CursorLine
    highlight! def link CursorLineNormalNr CursorLineNr
  else
    exec 'highlight! CursorLineNormal ' . s:color_normal
    exec 'highlight! CursorLineNormalNr ' . s:color_normal_nr
  endif

  if exists("g:conoline_use_colorscheme_default_insert") && g:conoline_use_colorscheme_default_insert == 1
    highlight! def link CursorLineInsert CursorLine
    highlight! def link CursorLineInsertNr CursorLineNr
  else
    exec 'highlight! CursorLineInsert ' . s:color_insert
    exec 'highlight! CursorLineInsertNr ' . s:color_insert_nr
  endif

  " Highlights cursor line enter current window and clear when leave
  augroup conoline_only_active_window
    autocmd!
    autocmd WinEnter,BufEnter * call s:winenter()
    autocmd WinLeave,BufLeave * call s:winleave()
  augroup END

  " Change cursor line color when enter/leave insert mode.
  augroup conoline_color_insert
    autocmd!
    autocmd InsertEnter * call s:insert()
    autocmd InsertLeave * call s:normal()
  augroup END

  " Enable again when highlight is cleared.
  augroup conoline_color_enable
    autocmd!
    autocmd Syntax,ColorScheme * call conoline#enable()
  augroup END

  setlocal cursorline
  call s:normal()
  let s:coloring = 1
endfunction

function! conoline#toggle()
  if !exists("s:coloring")
    let s:coloring = 1
  endif
  if s:coloring == 1
    call conoline#disable()
  elseif s:coloring == 0
    call conoline#enable()
  endif
endfunction

function! conoline#status()
  if exists('s:coloring') && s:coloring ==1
    return 1
  else
    return 0
  endif
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
" vim set\ ts=2\ sts=2\ sw=2\ et
