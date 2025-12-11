function Reverse(text)
	return join(reverse(split(a:text, '\zs')),'')
endfunction

function Reload()
	let b:ext = expand('%:e')
	if filereadable(expand("~/.vim/predictions/") . b:ext . ".pred")
		let b:extPred = readfile(expand("~/.vim/predictions/") . b:ext . ".pred")
	else
		let b:extPred = []
	endif

	let b:curPred = []
	for l in getline(1,'$')
		let ws = split(l,'\W\+')
		call extend(b:curPred,ws)
	endfor
	let b:curPred = filter(b:curPred,'v:val !=# ""')
	let b:curPred = filter(b:curPred, 'v:val !~ ''^\d''')
	let b:curPred = filter(b:curPred, 'len(v:val) > 1')
	
	let curDir = expand("%:p:h")
	let parDir = fnamemodify(curDir, ':h')
	if filereadable(curDir . "/.vim.pred")
		let b:projPred = readfile(curDir . "/.vim.pred")
	elseif filereadable(parDir . "/.vim.pred")
		let b:projPred = readfile(parDir . "/.vim.pred")
	else
		let b:projPred = []
	endif

	let b:updProj = b:projPred + b:curPred
	let b:updProj = MakeUnique(b:updProj)
	let b:updProj = map(copy(b:updProj),'v:val . ""')
	let extDict = {}
	for item in b:extPred
		let extDict[item] = 1
	endfor
	let b:updProj = filter(b:updProj,'!has_key(extDict,v:val)')
	if filereadable(curDir . "/.vim.pred")
		call writefile(b:updProj,curDir . "/.vim.pred")
	elseif filereadable(parDir . "/.vim.pred")
		call writefile(b:updProj, parDir . "/.vim.pred")
	endif
endfunction

function GetCurrentWord()
	let line = getline('.')
	let col = col('.')-2
	let left = line[0:col]
	let left = Reverse(left)
	let left = Reverse(matchstr(left,'\w*'))
	return left
endfunction

function MakeUnique(list)
	let seen = {}
	let unique = []

	for item in a:list
			if !has_key(seen, item)
					let seen[item] = 1
					call add(unique, item)
			endif
	endfor
	return unique
endfunction

function! PrefixFilter(list, prefix) abort
    let result = []
    for item in a:list
        if type(item) == type("") && item =~ '^' . escape(a:prefix, '\')
            call add(result, item)
        endif
    endfor
    return result
endfunction

function GetTextPrediction()
	let g:word = GetCurrentWord()
	if empty(g:word)
		return []
	endif
	let ret = b:curPred + b:projPred + b:extPred
	let ret = MakeUnique(ret)
	let ret = PrefixFilter(ret,g:word)
	if len(ret) >= 4
		return ret[0:3]
	endif
	return ret
endfunction

let g:Line = 0

function MenuUp()
	let g:Line = g:Line - 1
	if g:Line < 1
		let g:Line = 1
		return "\<UP>"
	endif
	call win_execute(g:wind,'-')
	call popup_setoptions(g:wind,#{cursorline:1})
	return ""
endfunction

function MenuDown()
	let g:Line = g:Line + 1
	echo len(g:options) < g:Line
	if g:Line > len(g:options)
		let g:Line = g:Line - 1
		return "\<DOWN>"
	endif
	if g:Line != 1
		call win_execute(g:wind,'+')
	endif
	call popup_setoptions(g:wind,#{cursorline:1})
	return ""
endfunction

function MenuSelect()
	if g:Line < 1
		return "\<CR>"
	endif
	return (g:options[g:Line-1])[len(g:word):]
endfunction

function MenuTab()
	if g:Line < 0
		return ""
	endif
	if g:Line == 0
		return (g:options[g:Line])[len(g:word):]
	endif
	return
		return (g:options[g:Line-1])[len(g:word):]
endfunction

let g:wind = ""
let g:options = []
let g:buf = ""
function! OnType()
	let g:Line = 0
	let settings = #{line:'cursor+1',col:'cursor',moved:"any",pos:"topleft",cursorline:0,maxheight:4}
	let g:options = GetTextPrediction()
	if !empty(g:options)
		let g:wind = popup_create(g:options,settings)
		let g:buf = winbufnr(g:wind)
	endif
endfunction
