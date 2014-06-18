" File:         autoload/TWCommand.vim
" Description:  A plugin for moving & managing a tab or window.
" Author:       yssl <http://github.com/yssl>
" License:      

""""""""""""""""""""""""""""""""""""""""
" script variables
if !exists('s:twhistory')
	let s:twhistory = []
endif
if !exists('s:twhistory_cur_idx')
	let s:twhistory_cur_idx = -1
endif

""""""""""""""""""""""""""""""""""""""""
" interface
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
	elseif a:cmd==#'twh'
		call s:twh(a:arg)
	endif
endfun

fun! TWCommand#PushHistory(tabnr, winnr)
	if len(s:twhistory)>0
		let [lasttabnr, lastwinnr] = s:twhistory[-1]
		if lasttabnr==a:tabnr && lastwinnr==a:winnr
			return
		endif
	endif

	call add(s:twhistory, [a:tabnr,a:winnr])
	if len(s:twhistory) > g:twcommand_maxhistory
		unlet s:twhistory[0]
	endif
	let s:twhistory_cur_idx = -1
	"echo 'push' [a:tabnr,a:winnr]
	"echo s:twhistory
endfun

fun! TWCommand#PrintHistory()
	echo s:twhistory
	echo s:twhistory_cur_idx
endfun

""""""""""""""""""""""""""""""""""""""""
" common functions
fun! s:PopHistory()
	if len(s:twhistory) > 0
		let tw = s:twhistory[-1]
		unlet s:twhistory[-1]
		let s:twhistory_cur_idx = -1
		"echo 'pop' tw
		"echo s:twhistory
		return tw
	else
		return [-1,-1]
	endif
endfun

fun! s:JumpToTabWin(tabnr, winnr)
	let g:twcommand_push = 0
	call s:JumpToTab(a:tabnr)
	call s:JumpToWin(a:winnr)
	let g:twcommand_push = 1
endfun

fun! s:RemoveWinFromHistory(basetabnr, closewinnr)
	let i = 0
	while i < len(s:twhistory)
		let tabnr = s:twhistory[i][0]
		let winnr = s:twhistory[i][1]
		if tabnr==a:basetabnr
			if winnr==a:closewinnr
				unlet s:twhistory[i]
				continue	|" do not increase i
			elseif winnr>a:closewinnr
				let s:twhistory[i][1] = winnr-1
			endif
		endif
		let i = i+1
	endwhile	
endfun

fun! s:RemoveTabFromHistory(closetabnr)
	let i = 0
	while i < len(s:twhistory)
		let tabnr = s:twhistory[i][0]
		if tabnr==a:closetabnr
			unlet s:twhistory[i]
			continue	|" do not increase i
		elseif tabnr>a:closetabnr
			let s:twhistory[i][0] = tabnr-1
		endif
		let i = i+1
	endwhile	
endfun

fun! s:CleanDuplicatedHistory()
	if len(s:twhistory)<2
		return
	endif

	let i = 0
	while i < len(s:twhistory)-1
		if s:twhistory[i][0]==s:twhistory[i+1][0] && s:twhistory[i][1]==s:twhistory[i+1][1]
			unlet s:twhistory[i]
		else
			let i = i+1
		endif
	endwhile
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
	let curtabnr = tabpagenr()
	let prevtabnr = curtabnr
	let i = -1
	while i > -len(s:twhistory)-1
		let tabnr = s:twhistory[i][0]
		if tabnr!=curtabnr
			let prevtabnr=tabnr
			break
		endif
		let i = i-1
	endwhile	
	call s:JumpToTab(prevtabnr)
endfun

fun! s:CloseTab()
	"echo 'before s:CloseTab()' s:twhistory
	let closingtabnr = tabpagenr()

	let beforetabcount = tabpagenr('$')
	tabclose
	let aftertabcount = tabpagenr('$')
	"echo 'after tabclose' s:twhistory

	"when tab closed
	if beforetabcount != aftertabcount 
		"echo 'tab closed' closingtabnr 
		call s:RemoveTabFromHistory(closingtabnr)
		"echo 'after s:RemoveTabFromHistory' s:twhistory
		call s:CleanDuplicatedHistory()
		"echo 'after s:CleanDuplicatedHistory' s:twhistory
		let [prevtabnr, prevwinnr] = s:PopHistory()
		"echo 'popped' prevtabnr prevwinnr
		"echo 'after s:PopHistory' s:twhistory
		if g:twcommand_restore_prevfocus==1 && prevtabnr!=-1
			call s:JumpToTabWin(prevtabnr, prevwinnr)
		endif
	endif
	"echo 'after s:CloseTab()' s:twhistory
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
	"echo 'before s:CloseWin()' s:twhistory
	let closingtabnr = tabpagenr()
	let closingwinnr = winnr()

	let beforetabcount = tabpagenr('$')
	let beforewincount = winnr('$')
	quit
	let aftertabcount = tabpagenr('$')
	let afterwincount = winnr('$')
	"echo 'after quit' s:twhistory

	"when tab closed
	if beforetabcount != aftertabcount 
		"echo 'tab closed' closingtabnr
		call s:RemoveTabFromHistory(closingtabnr)
		"echo 'after s:RemoveTabFromHistory' s:twhistory
		call s:CleanDuplicatedHistory()
		"echo 'after s:CleanDuplicatedHistory' s:twhistory
		let [prevtabnr, prevwinnr] = s:PopHistory()
		"echo 'popped' prevtabnr prevwinnr
		"echo 'after s:PopHistory' s:twhistory
		if g:twcommand_restore_prevfocus==1 && prevtabnr!=-1
			call s:JumpToTabWin(prevtabnr, prevwinnr)
		endif
	"when win closed
	elseif beforewincount != afterwincount 
		"echo 'win closed' closingtabnr closingwinnr
		call s:RemoveWinFromHistory(closingtabnr, closingwinnr)
		"echo 'after s:RemoveWinFromHistory' s:twhistory
		call s:CleanDuplicatedHistory()
		"echo 'after s:CleanDuplicatedHistory' s:twhistory
		let [prevtabnr, prevwinnr] = s:PopHistory()
		"echo 'popped' prevtabnr prevwinnr
		"echo 'after s:PopHistory' s:twhistory
		if g:twcommand_restore_prevfocus==1 && prevtabnr!=-1
			call s:JumpToTabWin(prevtabnr, prevwinnr)
		endif
	endif
	"echo 'after s:CloseWin()' s:twhistory
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

""""""""""""""""""""""""""""""""""""""""
" twh
fun! s:twh(arg)
	if a:arg==#'h'
		call s:ForwardHistory()
	elseif a:arg==#'l'
		call s:BackwardHistory()
	endif
endfun

fun! s:ForwardHistory()
	if s:twhistory_cur_idx==0
		return
	endif

	if s:twhistory_cur_idx==-1
		let s:twhistory_cur_idx = len(s:twhistory)-1
	else
		let s:twhistory_cur_idx = s:twhistory_cur_idx-1
	endif

	let [tabnr, winnr] = s:twhistory[s:twhistory_cur_idx]
	call s:JumpToTabWin(tabnr, winnr)
	"call TWCommand#PrintHistory()
endfun

fun! s:BackwardHistory()
	if s:twhistory_cur_idx==len(s:twhistory)-1
		return
	endif

	if s:twhistory_cur_idx==-1
		return
	endif

	let s:twhistory_cur_idx = s:twhistory_cur_idx+1

	let [tabnr, winnr] = s:twhistory[s:twhistory_cur_idx]
	call s:JumpToTabWin(tabnr, winnr)
	"call TWCommand#PrintHistory()
endfun

