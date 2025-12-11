" ---- Highlight groups ----
" Mode block (background = blue, foreground = black)
hi StatusLineText guifg=#000000 guibg=#5fd7ff ctermfg=0 ctermbg=81

" Triangle bridging ModeBlock → Normal statusline
" Foreground = background of ModeBlock
" Background = background of Normal
hi StatusLineSlopeFirst guifg=#5fd7ff guibg=#2048ff ctermfg=81 ctermbg=21
hi StatusLineSlopeSecond guifg=#5fd7ff guibg=#1c1c1c ctermfg=81 ctermbg=234

" Normal section (just background)
hi StatusLineNormal guifg=#ffffff guibg=#1c1c1c ctermfg=15 ctermbg=234

" ---- Function that builds the left part of the statusline ----
function! ModeSegment()
    " Select mode name
	let l:stat = ''
	let l:stat .= '%#StatusLineSlopeFirst#' . ' ◥'
		
	
  let l:m = mode()

  if l:m ==# 'n'
    let l:txt = ' NORMAL '
  elseif l:m ==# 'i'
    let l:txt = ' INSERT '
  elseif l:m =~# 'v'
		let l:txt = ' VISUAL '
  else
		let l:txt = ' OTHER '
  endif
		
		

	let l:stat .= '%#StatusLineText#' . l:txt . '%#StatusLineSlopeSecond#' . '◣ ' 
	let l:stat .= '%#StatusLineNormal' . '#%m ' . '%t ' . '%='
	let l:stat .= '%#StatusLineSlopeSecond#' . '◥' . '%#StatusLineText#'
	let l:stat .= ' Ln %l, Col %c' 
	let l:stat .= ' ' . strftime("%H:%M:%S")
	let l:stat .= '%#StatusLineSlopeFirst#' . '◣ '

	return l:stat
endfunction


" ---- Build the full statusline ----
set statusline=%!ModeSegment()
set laststatus=2
autocmd ModeChanged * redrawstatus
