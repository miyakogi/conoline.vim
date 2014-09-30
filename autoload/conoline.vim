scriptencoding utf-8

let s:save_cpo = &cpo
set cpo&vim

function! s:insert()
  highlight! def link CursorLine ConoLineInsert
  highlight! def link CursorLineNr ConoLineInsertNr
endfunction

function! s:normal()
  highlight! def link CursorLine ConoLineNormal
  highlight! def link CursorLineNr ConoLineNormalNr
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
  let s:enabled = 0
endfunction

function! conoline#enable()
  if !exists("s:enabled")
    let s:enabled = 0
  endif

  if &background ==# 'light'
    let bg = 'light'
  else
    let bg = 'dark'
  endif

  " Set highlight according to options.
  if g:conoline_use_colorscheme_default_normal
    highlight! def link ConoLineNormal CursorLine
    highlight! def link ConoLineNormalNr CursorLineNr
  else
    execute "execute 'highlight! ConoLineNormal ' . g:conoline_color_normal_" . bg
    execute "execute 'highlight! ConoLineNormalNr ' . g:conoline_color_normal_nr_" . bg
  endif

  if g:conoline_use_colorscheme_default_insert
    highlight! def link ConoLineInsert CursorLine
    highlight! def link ConoLineInsertNr CursorLineNr
  else
    execute "execute 'highlight! ConoLineInsert ' . g:conoline_color_insert_" . bg
    execute "execute 'highlight! ConoLineInsertNr ' . g:conoline_color_insert_nr_" . bg
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
  let s:enabled = 1
endfunction

function! conoline#toggle()
  if !exists("s:enabled")
    let s:enabled = 0
  endif

  if s:enabled == 1
    call conoline#disable()
  elseif s:enabled == 0
    call conoline#enable()
  endif
endfunction

function! conoline#status()
  if exists('s:enabled') && s:enabled ==1
    return 1
  else
    return 0
  endif
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
" vim set\ ts=2\ sts=2\ sw=2\ et
