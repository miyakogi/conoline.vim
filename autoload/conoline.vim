function! conoline#insert()
	highlight! def link CursorLine CursorLineInsert
	highlight! def link CursorLineNr CursorLineInsertNr
endfunction

function! conoline#normal()
	highlight! def link CursorLine CursorLineNormal
	highlight! def link CursorLineNr CursorLineNormalNr
endfunction

function! conoline#winenter()
	setlocal cursorline
endfunction

function! conoline#winleave()
	setlocal nocursorline
endfunction

function! conoline#disable()
	setlocal nocursorline
	augroup conoline_only_active_window
		autocmd!
	augroup END
	augroup conoline_color_insert
		autocmd!
	augroup END
	let g:conoline_coloring = 0
endfunction

function! conoline#setcolors()
	" TODO: Refactor this function.
	if &background == "light"
		if !exists("g:conoline_color_insert_light")
			let g:conoline_color_insert_light = "guibg=#ffffff"
		endif
		if !exists("g:conoline_color_insert_nr_light")
			let g:conoline_color_insert_nr_light = "guibg=#ffffff"
		endif
		if !exists("g:conoline_color_normal_light")
			let g:conoline_color_normal_light = "guibg=#eaeaea"
		endif
		if !exists("g:conoline_color_normal_nr_light")
			let g:conoline_color_normal_nr_light = "guibg=#eaeaea"
		endif
		let g:conoline_color_insert = g:conoline_color_insert_light
		let g:conoline_color_insert_nr = g:conoline_color_insert_nr_light
		let g:conoline_color_normal = g:conoline_color_normal_light
		let g:conoline_color_normal_nr = g:conoline_color_normal_nr_light
	else
		if !exists("g:conoline_color_insert_dark")
			let g:conoline_color_insert_dark = "guibg=#000000"
		endif
		if !exists("g:conoline_color_insert_nr_dark")
			let g:conoline_color_insert_nr_dark = "guibg=#000000"
		endif
		if !exists("g:conoline_color_normal_dark")
			let g:conoline_color_normal_dark = "guibg=#181818"
		endif
		if !exists("g:conoline_color_normal_nr_dark")
			let g:conoline_color_normal_nr_dark = "guibg=#181818"
		endif
		let g:conoline_color_insert = g:conoline_color_insert_dark
		let g:conoline_color_insert_nr = g:conoline_color_insert_nr_dark
		let g:conoline_color_normal = g:conoline_color_normal_dark
		let g:conoline_color_normal_nr = g:conoline_color_normal_nr_dark
	endif
endfunction

function! conoline#enable()
	if !exists("g:conoline_coloring")
		let g:conoline_coloring = 1
	endif
	call conoline#setcolors()
	" Set highlight according to options.
	if exists("g:conoline_use_colorscheme_default_normal") && g:conoline_use_colorscheme_default_normal == 1
		" NOTE: I wonder why this loop works as I expected...
		highlight! def link CursorLineNormal CursorLine
		highlight! def link CursorLineNormalNr CursorLineNr
	else
		exec 'highlight! CursorLineNormal ' . g:conoline_color_normal
		exec 'highlight! CursorLineNormalNr ' . g:conoline_color_normal_nr
	endif
	if exists("g:conoline_use_colorscheme_default_insert") && g:conoline_use_colorscheme_default_insert == 1
		highlight! def link CursorLineInsert CursorLine
		highlight! def link CursorLineInsertNr CursorLineNr
	else
		exec 'highlight! CursorLineInsert ' . g:conoline_color_insert
		exec 'highlight! CursorLineInsertNr ' . g:conoline_color_insert_nr
	endif
	" Highlights cursor line enter current window and clear when leave
	augroup conoline_only_active_window
		autocmd!
		autocmd WinEnter,BufEnter * call conoline#winenter()
		autocmd WinLeave,BufLeave * call conoline#winleave()
	augroup END
	" Change cursor line color when enter/leave insert mode.
	augroup conoline_color_insert
		autocmd!
		autocmd InsertEnter * call conoline#insert()
		autocmd InsertLeave * call conoline#normal()
	augroup END
	" Enable again when highlight is cleared.
	augroup conoline_color_enable
		autocmd!
		autocmd Syntax,ColorScheme * call conoline#enable()
	augroup END

	setlocal cursorline
	call conoline#normal()
	let g:conoline_coloring = 1
endfunction

function! conoline#toggle()
	if !exists("g:conoline_coloring")
		let g:conoline_coloring = 1
	endif
	if g:conoline_coloring == 1
		call conoline#disable()
	elseif g:conoline_coloring == 0
		call conoline#enable()
	endif
endfunction
