" File:         autoload/TWCommand.vim
" Description:  A plugin for moving & managing a tab or window.
" Author:       yssl <http://github.com/yssl>
" License:      

fun! TWCommand#TWCommand(cmd, arg)
	if a:cmd==#'tcm'
		call s:tcm(a:arg)
	elseif a:cmd==#'tmv'
		call s:tmv(a:arg)
	elseif a:cmd==#'wcm'
		call s:wcm(a:arg)
	elseif a:cmd==#'wmv'
		call s:wmv(a:arg)
	elseif a:cmd==#'wmvt'
		call s:wmvt(a:arg)
	endif
endfun

""""""""""""""""""""""""""""""""""""""""
" tcm
fun! s:tcm(arg)
	if a:arg==#'h'
		call s:LeftTab()
	elseif a:arg==#'l'
		call s:RightTab()
	elseif a:arg==#'p'
		call s:PrevTab()
	elseif a:arg==#'q'
		call s:CloseTab()
	elseif a:arg==#'n'
		tabnew
	elseif a:arg==#'t'
		exec 'tabnext' 1
	elseif a:arg==#'b'
		exec 'tabnext' tabpagenr('$')
	elseif a:arg==#'w'
		tabnext
	elseif a:arg==#'W'
		tabprev
	elseif a:arg==#'o'
		tabonly
	endif
endfun

fun! s:LeftTab()
	if tabpagenr()==1
		return
	endif
	tabprev
endfun

fun! s:RightTab()
	if tabpagenr()==tabpagenr('$')
		return
	endif
	tabnext
endfun

fun! s:PrevTab()
	call s:JumpToTab(g:twcommand_prevtabnr)
endfun

fun! s:CloseTab()
	let prevtabnr = g:twcommand_prevtabnr
	if prevtabnr > tabpagenr()
		let prevtabnr = prevtabnr - 1
	endif

	tabclose

	if g:twcommand_restore_prevfocus==1
		call s:JumpToTab(prevtabnr)
	endif
endfun

fun! s:JumpToTab(tabnum)
	exec 'tabnext' a:tabnum
endfun

""""""""""""""""""""""""""""""""""""""""
" tmv
fun! s:tmv(arg)
	let tabnr1 = tabpagenr()
	call s:tcm(a:arg)
	let tabnr2 = tabpagenr()
	call s:MoveTab(tabnr1, tabnr2)
endfun

fun! s:MoveTab(tabnr1, tabnr2)
	if a:tabnr1==a:tabnr2 
		return
	endif

	if a:tabnr1<a:tabnr2
		let pos1 = a:tabnr1-1
		let pos2 = a:tabnr2-2
	else
		let pos1 = a:tabnr1-1
		let pos2 = a:tabnr2
	endif

	exec 'tabnext' a:tabnr1
	exec 'tabmove' pos2

	exec 'tabnext' a:tabnr2
	exec 'tabmove' pos1

	exec 'tabnext' a:tabnr2
endfun

""""""""""""""""""""""""""""""""""""""""
" wcm
fun! s:wcm(arg)
	if a:arg==#'q'
		call s:CloseWin()
	elseif a:arg==#'m'
		call s:ToggleMaxWin()
	else
		exec 'wincmd' a:arg
	endif
endfun

fun! s:CloseWin()
	let prevwinnr = g:twcommand_prevwinnr
	if prevwinnr > winnr()
		let prevwinnr = prevwinnr - 1
	endif

	quit

	if g:twcommand_restore_prevfocus==1
		call s:JumpToWin(prevwinnr)
	endif
endfun

fun! s:JumpToWin(winnum)
	exec a:winnum.'wincmd w'
endfun

fun! s:ToggleMaxWin()
	if exists('s:origsizecmd')
		exec s:origsizecmd
		unlet s:origsizecmd
	elseif winnr('$')>1
		let s:origsizecmd = winrestcmd()
		resize
		vert resize
	endif
endfun

""""""""""""""""""""""""""""""""""""""""
" wmv
fun! s:wmv(arg)
	let winnr1 = winnr()
	call s:wcm(a:arg)
	let winnr2 = winnr()
	call s:MoveWin(winnr1, winnr2)
endfun

fun! s:MoveWin(winnr1, winnr2)
	if a:winnr1==a:winnr2 
		return
	endif

	exec a:winnr1.'wincmd w'
	let bufnr1 = winbufnr(a:winnr1)
	let view1 = winsaveview()
	"mkview! 0

	exec a:winnr2.'wincmd w'
	let bufnr2 = winbufnr(a:winnr2)
	let view2 = winsaveview()
	"mkview! 1

	execute 'buffer'.bufnr1
	call winrestview(view1)
	"loadview 0

	wincmd p
	exec 'buffer'.bufnr2
	call winrestview(view2)
	"loadview 1

	wincmd p
endfun

""""""""""""""""""""""""""""""""""""""""
" wmvt
fun! s:wmvt(arg)
	let tabnr1 = tabpagenr()
	let winnr1 = winnr()

	if tabnr1==1 && winnr('$')>1 && a:arg==#'h'
		exec '0tabnew'
		let tabnr1 = tabnr1 + 1
		exec 'tabnext' tabnr1
	elseif tabnr1==tabpagenr('$') && winnr('$')>1 && a:arg==#'l'
		exec tabpagenr('$').'tabnew'
		exec 'tabnext' tabnr1
	endif

	call s:tcm(a:arg)

	let tabnr2 = tabpagenr()
	call s:MoveWinBtwnTabs(tabnr1, winnr1, tabnr2)
endfun

fun! s:MoveWinBtwnTabs(tabnr1, winnr1, tabnr2)
	if a:tabnr1==a:tabnr2 
		return
	endif

	exec 'tabnext' a:tabnr1
	exec a:winnr1.'wincmd w'
	let bufnr1 = winbufnr(a:winnr1)
	if a:tabnr1<a:tabnr2 && winnr('$')==1
		let tabnr2 = a:tabnr2 - 1
	else
		let tabnr2 = a:tabnr2
	endif
	close

	exec 'tabnext' tabnr2

	let bufnr = bufnr('%')
	let bufname = bufname(bufnr)
	let buftype = getbufvar(bufnr, '&buftype')

	" if not ([No Name] is the only one window
	" 		and its buffer is empty)
	if !(winnr('$')==1 && bufname==#'' && buftype==#'' &&
		\ line('$')==1 && getline(1)=='')
		vnew
	endif

	exec 'buffer' bufnr1
endfun
